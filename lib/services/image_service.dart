import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../core/utils/logger.dart';
import '../domain/entities/apod_entity.dart';

/// Resultado de operação do serviço de imagem
sealed class ImageServiceResult {
  const ImageServiceResult();
}

class ImageServiceSuccess extends ImageServiceResult {
  const ImageServiceSuccess({required this.message, this.filePath});
  final String message;
  final String? filePath;
}

class ImageServiceError extends ImageServiceResult {
  const ImageServiceError({required this.message});
  final String message;
}

/// Serviço para download e compartilhamento de imagens
class ImageService {
  ImageService._();
  
  static final ImageService instance = ImageService._();
  
  final Dio _dio = Dio();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Faz download da imagem do APOD para a galeria
  Future<ImageServiceResult> downloadImage(
    ApodEntity apod, {
    bool useHd = true,
    Function(int, int)? onProgress,
  }) async {
    try {
      Logger.info('Iniciando download: ${apod.title}');
      
      // Verifica e solicita permissões
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        return const ImageServiceError(
          message: 'Permissão de armazenamento negada. Por favor, permita o acesso nas configurações do app.',
        );
      }

      // Obtém a URL da imagem
      final imageUrl = useHd ? (apod.hdUrl ?? apod.url) : apod.url;
      
      Logger.debug('Baixando de: $imageUrl');

      // Faz o download dos bytes da imagem
      final response = await _dio.get<List<int>>(
        imageUrl,
        onReceiveProgress: onProgress,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.data == null || response.data!.isEmpty) {
        return const ImageServiceError(
          message: 'Erro ao baixar a imagem: dados vazios',
        );
      }

      final imageBytes = Uint8List.fromList(response.data!);
      
      // Gera nome do arquivo
      final fileName = _generateFileName(apod);
      
      Logger.debug('Salvando imagem: $fileName (${imageBytes.length} bytes)');

      // Salva na galeria usando image_gallery_saver_plus
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 100,
        name: fileName,
      );

      Logger.debug('Resultado do salvamento: $result');

      // O resultado pode ser um Map ou um dynamic dependendo da plataforma
      if (result != null) {
        final isSuccess = result['isSuccess'] == true || result['isSuccess'] == 'true';
        
        if (isSuccess) {
          final filePath = result['filePath']?.toString();
          Logger.info('Imagem salva com sucesso: $filePath');
          
          return ImageServiceSuccess(
            message: 'Imagem salva na galeria!',
            filePath: filePath,
          );
        } else {
          final errorMsg = result['errorMessage']?.toString() ?? 'Erro desconhecido ao salvar';
          Logger.error('Falha ao salvar na galeria: $errorMsg');
          return ImageServiceError(
            message: 'Erro ao salvar na galeria: $errorMsg',
          );
        }
      } else {
        Logger.error('Resultado nulo ao salvar imagem');
        return const ImageServiceError(
          message: 'Erro ao salvar na galeria: resultado nulo',
        );
      }
    } on DioException catch (e) {
      Logger.error('Erro de rede no download', error: e);
      return ImageServiceError(
        message: 'Erro ao baixar: ${e.message ?? 'Falha na conexão'}',
      );
    } catch (e, stackTrace) {
      Logger.error('Erro no download', error: e, stackTrace: stackTrace);
      return ImageServiceError(
        message: 'Erro ao salvar a imagem: $e',
      );
    }
  }

  /// Compartilha o APOD (imagem + texto)
  Future<ImageServiceResult> shareApod(
    ApodEntity apod, {
    Rect? sharePositionOrigin,
  }) async {
    try {
      Logger.info('Iniciando compartilhamento: ${apod.title}');

      // Texto de compartilhamento
      final shareText = _buildShareText(apod);

      if (apod.isVideo) {
        // Para vídeos, compartilha apenas o texto com link
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            subject: apod.title,
            sharePositionOrigin: sharePositionOrigin,
          ),
        );
      } else {
        // Para imagens, tenta baixar e compartilhar o arquivo
        final imageFile = await _downloadToTemp(apod);
        
        if (imageFile != null) {
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(imageFile.path)],
              text: shareText,
              subject: apod.title,
              sharePositionOrigin: sharePositionOrigin,
            ),
          );
          
          // Agenda limpeza do arquivo temporário após um delay
          Future.delayed(const Duration(minutes: 2), () {
            imageFile.delete().catchError((_) => imageFile);
          });
        } else {
          // Se não conseguiu baixar, compartilha só o texto
          await SharePlus.instance.share(
            ShareParams(
              text: shareText,
              subject: apod.title,
              sharePositionOrigin: sharePositionOrigin,
            ),
          );
        }
      }

      Logger.info('Compartilhamento iniciado');
      return const ImageServiceSuccess(message: 'Compartilhado!');
    } catch (e) {
      Logger.error('Erro ao compartilhar', error: e);
      return ImageServiceError(
        message: 'Erro ao compartilhar: $e',
      );
    }
  }

  /// Compartilha apenas o texto/link do APOD
  Future<ImageServiceResult> shareText(
    ApodEntity apod, {
    Rect? sharePositionOrigin,
  }) async {
    try {
      final shareText = _buildShareText(apod);
      
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: apod.title,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );

      return const ImageServiceSuccess(message: 'Compartilhando...');
    } catch (e) {
      Logger.error('Erro ao compartilhar texto', error: e);
      return ImageServiceError(message: 'Erro ao compartilhar: $e');
    }
  }

  // Métodos privados

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      
      Logger.debug('Android SDK: $sdkInt');

      // Android 10+ (API 29+): Não precisa de permissão para salvar na galeria
      // O ImageGallerySaverPlus usa MediaStore que não requer permissão de storage
      if (sdkInt >= 29) {
        Logger.debug('Android 10+: Permissão não necessária para MediaStore');
        return true;
      } else {
        // Android 9 e anteriores (API < 29): Precisa de permissão de storage
        final status = await Permission.storage.request();
        Logger.debug('Permissão storage: $status');
        
        if (status.isPermanentlyDenied) {
          Logger.debug('Permissão negada permanentemente');
          return false;
        }
        
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS: Precisa de permissão de fotos para adicionar à biblioteca
      final status = await Permission.photosAddOnly.request();
      Logger.debug('Permissão photosAddOnly: $status');
      return status.isGranted || status.isLimited;
    }
    return true;
  }

  String _generateFileName(ApodEntity apod) {
    // Remove caracteres especiais do título
    final safeTitle = apod.title
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
    
    // Limita tamanho do nome
    final truncatedTitle = safeTitle.length > 30 
        ? safeTitle.substring(0, 30) 
        : safeTitle;
    
    // Adiciona timestamp para evitar sobrescrita
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    return 'cosmic_vision_${apod.date}_${truncatedTitle}_$timestamp';
  }

  String _buildShareText(ApodEntity apod) {
    final buffer = StringBuffer();
    
    buffer.writeln('🌌 ${apod.title}');
    buffer.writeln();
    buffer.writeln('📅 ${apod.formattedDate}');
    buffer.writeln();
    
    // Adiciona descrição truncada
    final description = apod.explanation.length > 280
        ? '${apod.explanation.substring(0, 280)}...'
        : apod.explanation;
    buffer.writeln(description);
    buffer.writeln();
    
    if (apod.hasCopyright) {
      buffer.writeln('📷 ${apod.copyright}');
      buffer.writeln();
    }
    
    buffer.writeln('🔗 Ver mais: https://apod.nasa.gov/apod/ap${_formatDateForUrl(apod.date)}.html');
    buffer.writeln();
    buffer.writeln('Compartilhado via Cosmic Vision 🚀');
    
    return buffer.toString();
  }

  String _formatDateForUrl(String date) {
    // Converte 2024-12-25 para 241225
    final parts = date.split('-');
    if (parts.length == 3) {
      final year = parts[0].substring(2);
      final month = parts[1];
      final day = parts[2];
      return '$year$month$day';
    }
    return date.replaceAll('-', '');
  }

  Future<File?> _downloadToTemp(ApodEntity apod) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = _generateFileName(apod);
      final filePath = '${tempDir.path}/$fileName.jpg';
      
      final imageUrl = apod.hdUrl ?? apod.url;
      
      Logger.debug('Baixando para temp: $filePath');
      
      await _dio.download(
        imageUrl,
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );
      
      final file = File(filePath);
      if (await file.exists()) {
        Logger.debug('Arquivo temp criado: ${await file.length()} bytes');
        return file;
      }
      return null;
    } catch (e) {
      Logger.error('Erro ao baixar para temp', error: e);
      return null;
    }
  }
}

/// Acesso global ao serviço
ImageService get imageService => ImageService.instance;
