import '../../core/utils/result.dart';
import '../entities/apod_entity.dart';

/// Interface do repositório APOD
///
/// Define o contrato para acesso aos dados da API NASA APOD.
/// A implementação concreta fica na camada de dados.
abstract class ApodRepository {
  /// Busca o APOD do dia atual
  Future<Result<ApodEntity>> getTodayApod();

  /// Busca o APOD de uma data específica
  ///
  /// [date] - Data no formato DateTime
  Future<Result<ApodEntity>> getApodByDate(DateTime date);

  /// Busca APODs de um período
  ///
  /// [startDate] - Data inicial
  /// [endDate] - Data final
  /// Máximo de 30 dias entre as datas
  Future<Result<List<ApodEntity>>> getApodsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Busca N APODs aleatórios
  ///
  /// [count] - Quantidade de imagens (1-10)
  Future<Result<List<ApodEntity>>> getRandomApods(int count);
}
