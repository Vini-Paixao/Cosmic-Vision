// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ImageHelper {
  void downloadMedia(BuildContext context, dynamic media, String date) async {
    final formatter = DateFormat('dd-MM-yyyy');
    final formattedDate = formatter.format(DateTime.parse(date));
    String fileName = '';

    if (media is String) {
      final response = await http.get(Uri.parse(media));
      final mediaBytes = response.bodyBytes;
      fileName = 'imagem-do-dia-$formattedDate.jpg';

      // Salva a imagem na galeria
      final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(mediaBytes),
        quality: 100,
        name: fileName,
      );

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imagem salva na galeria como $fileName'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao salvar a imagem.'),
          ),
        );
      }
    } else if (media is Map<String, dynamic>) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vídeo não pode ser baixado'),
        ),
      );
    }
  }

  void shareImage(BuildContext context, String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(bytes);

    final xFile = XFile(file.path);
    await Share.shareXFiles([xFile], text: 'Confira a imagem do dia da NASA!');
  }
}
