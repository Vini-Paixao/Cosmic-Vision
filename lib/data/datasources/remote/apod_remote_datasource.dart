import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/utils/logger.dart';
import '../../models/apod_model.dart';

/// Interface do datasource remoto APOD
abstract class ApodRemoteDataSource {
  /// Busca o APOD do dia atual
  Future<ApodModel> getTodayApod();

  /// Busca o APOD de uma data específica
  Future<ApodModel> getApodByDate(DateTime date);

  /// Busca APODs de um período
  Future<List<ApodModel>> getApodsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca N APODs aleatórios
  Future<List<ApodModel>> getRandomApods(int count);
}

/// Implementação do datasource remoto usando Dio
class ApodRemoteDataSourceImpl implements ApodRemoteDataSource {
  ApodRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<ApodModel> getTodayApod() async {
    Logger.network('Buscando APOD do dia');

    try {
      final response = await dio.get(
        ApiConstants.apodEndpoint,
        queryParameters: {'api_key': ApiConstants.apiKey},
      );

      return ApodModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<ApodModel> getApodByDate(DateTime date) async {
    Logger.network('Buscando APOD da data: ${date.toApiFormat()}');

    // Validação da data
    if (!date.isValidApodDate) {
      throw const InvalidDateException(
        message: 'Data fora do intervalo permitido (16/06/1995 até hoje)',
      );
    }

    try {
      final response = await dio.get(
        ApiConstants.apodEndpoint,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'date': date.toApiFormat(),
        },
      );

      return ApodModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<ApodModel>> getApodsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    Logger.network(
      'Buscando APODs de ${startDate.toApiFormat()} até ${endDate.toApiFormat()}',
    );

    // Validações
    if (!startDate.isValidApodDate || !endDate.isValidApodDate) {
      throw const InvalidDateException(
        message: 'Data fora do intervalo permitido',
      );
    }

    if (startDate.isAfter(endDate)) {
      throw const ValidationException(
        message: 'Data inicial deve ser anterior à data final',
      );
    }

    final daysDifference = endDate.difference(startDate).inDays;
    if (daysDifference > ApiConstants.maxPeriodDays) {
      throw ValidationException(
        message: 'Período máximo permitido é de ${ApiConstants.maxPeriodDays} dias',
      );
    }

    try {
      final response = await dio.get(
        ApiConstants.apodEndpoint,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'start_date': startDate.toApiFormat(),
          'end_date': endDate.toApiFormat(),
        },
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => ApodModel.fromJson(json as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Mais recente primeiro
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<ApodModel>> getRandomApods(int count) async {
    Logger.network('Buscando $count APODs aleatórios');

    // Validação
    if (count < 1 || count > ApiConstants.maxRandomCount) {
      throw ValidationException(
        message: 'Quantidade deve ser entre 1 e ${ApiConstants.maxRandomCount}',
      );
    }

    try {
      final response = await dio.get(
        ApiConstants.apodEndpoint,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'count': count,
        },
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => ApodModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Converte DioException em exceções do app
  AppException _handleDioException(DioException e) {
    Logger.error(
      'Erro na requisição: ${e.message}',
      error: e,
      stackTrace: e.stackTrace,
    );

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Tempo de conexão esgotado');

      case DioExceptionType.connectionError:
        return const NetworkException(message: 'Falha na conexão. Verifique sua internet.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _getErrorMessageFromStatusCode(statusCode);

        if (statusCode == 403) {
          return ApiKeyException(message: message);
        }
        if (statusCode == 429) {
          return RateLimitException(message: message);
        }

        return ServerException(
          message: message,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const ServerException(message: 'Requisição cancelada');

      default:
        return ServerException(message: e.message ?? 'Erro desconhecido');
    }
  }

  /// Retorna mensagem de erro apropriada para o status code
  String _getErrorMessageFromStatusCode(int? statusCode) {
    return switch (statusCode) {
      400 => 'Requisição inválida',
      403 => 'API Key inválida ou sem permissão',
      404 => 'Dados não encontrados para a data solicitada',
      429 => 'Limite de requisições excedido. Tente novamente mais tarde.',
      500 => 'Erro interno do servidor',
      503 => 'Serviço temporariamente indisponível',
      _ => 'Erro ao buscar dados (código: $statusCode)',
    };
  }
}
