import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../datasources/remote/apod_remote_datasource.dart';

/// Implementação do repositório APOD
class ApodRepositoryImpl implements ApodRepository {
  ApodRepositoryImpl({required this.remoteDataSource});

  final ApodRemoteDataSource remoteDataSource;

  @override
  Future<Result<ApodEntity>> getTodayApod() async {
    Logger.info('Repository: Buscando APOD do dia');

    try {
      final apod = await remoteDataSource.getTodayApod();
      return Result.success(apod.toEntity());
    } on NetworkException catch (e) {
      Logger.error('Erro de rede', error: e);
      return Result.error(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      Logger.error('Erro do servidor', error: e);
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on ApiKeyException catch (e) {
      Logger.error('Erro de API Key', error: e);
      return Result.error(ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      Logger.error('Limite de requisições excedido', error: e);
      return Result.error(RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<ApodEntity>> getApodByDate(DateTime date) async {
    Logger.info('Repository: Buscando APOD da data: $date');

    try {
      final apod = await remoteDataSource.getApodByDate(date);
      return Result.success(apod.toEntity());
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on InvalidDateException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on ApiKeyException catch (e) {
      return Result.error(ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      return Result.error(RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<List<ApodEntity>>> getApodsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    Logger.info('Repository: Buscando APODs do período: $startDate - $endDate');

    try {
      final apods = await remoteDataSource.getApodsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
      return Result.success(apods.map((m) => m.toEntity()).toList());
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on ValidationException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on InvalidDateException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on ApiKeyException catch (e) {
      return Result.error(ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      return Result.error(RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<List<ApodEntity>>> getRandomApods(int count) async {
    Logger.info('Repository: Buscando $count APODs aleatórios');

    try {
      final apods = await remoteDataSource.getRandomApods(count);
      return Result.success(apods.map((m) => m.toEntity()).toList());
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on ValidationException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on ApiKeyException catch (e) {
      return Result.error(ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      return Result.error(RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }
}
