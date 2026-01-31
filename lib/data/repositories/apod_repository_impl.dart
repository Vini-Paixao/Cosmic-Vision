import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../datasources/local/apod_local_datasource.dart';
import '../datasources/remote/apod_remote_datasource.dart';
import '../models/apod_model.dart';

/// Implementação do repositório APOD com estratégia cache-first
class ApodRepositoryImpl implements ApodRepository {
  ApodRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ApodRemoteDataSource remoteDataSource;
  final ApodLocalDataSource localDataSource;

  @override
  Future<Result<ApodEntity>> getTodayApod() async {
    Logger.info('🔍 Repository: Buscando APOD do dia');
    final todayDate = _formatDate(DateTime.now());

    try {
      // 1. Tenta buscar do cache primeiro
      final cached = await localDataSource.getCachedApod(todayDate);
      
      if (cached != null && !cached.isExpired) {
        Logger.info('✅ APOD do dia SERVIDO DO CACHE: "${cached.apod.title}"');
        return Result.success(cached.apod.toEntity());
      }

      // 2. Cache inexistente ou expirado - busca da API
      Logger.info('🌐 Cache miss/expirado - buscando APOD do dia da API...');
      final apod = await remoteDataSource.getTodayApod();
      
      // 3. Salva no cache (é APOD de hoje)
      await _cacheApodSafely(apod, isToday: true);
      
      Logger.info('✅ APOD do dia SERVIDO DA API: "${apod.title}"');
      return Result.success(apod.toEntity());
    } on NetworkException catch (e) {
      Logger.error('Erro de rede', error: e);
      // Tenta retornar cache expirado como fallback
      return _tryExpiredCacheOrFail(todayDate, NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      Logger.error('Erro do servidor', error: e);
      return _tryExpiredCacheOrFail(
        todayDate,
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on ApiKeyException catch (e) {
      Logger.error('Erro de API Key', error: e);
      return _tryExpiredCacheOrFail(todayDate, ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      Logger.error('Limite de requisições excedido', error: e);
      return _tryExpiredCacheOrFail(todayDate, RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return _tryExpiredCacheOrFail(
        todayDate,
        ServerFailure(message: 'Erro inesperado: $e'),
      );
    }
  }

  @override
  Future<Result<ApodEntity>> getApodByDate(DateTime date) async {
    Logger.info('🔍 Repository: Buscando APOD da data: $date');
    final dateStr = _formatDate(date);

    try {
      // 1. Tenta buscar do cache primeiro
      final cached = await localDataSource.getCachedApod(dateStr);
      
      if (cached != null && !cached.isExpired) {
        Logger.info('✅ APOD de $dateStr SERVIDO DO CACHE: "${cached.apod.title}"');
        return Result.success(cached.apod.toEntity());
      }

      // 2. Cache inexistente ou expirado - busca da API
      Logger.info('🌐 Cache miss/expirado - buscando APOD de $dateStr da API...');
      final apod = await remoteDataSource.getApodByDate(date);
      
      // 3. Salva no cache
      final isToday = _isToday(date);
      await _cacheApodSafely(apod, isToday: isToday);
      
      Logger.info('✅ APOD de $dateStr SERVIDO DA API: "${apod.title}"');
      return Result.success(apod.toEntity());
    } on NetworkException catch (e) {
      return _tryExpiredCacheOrFail(dateStr, NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return _tryExpiredCacheOrFail(
        dateStr,
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on InvalidDateException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on ApiKeyException catch (e) {
      return _tryExpiredCacheOrFail(dateStr, ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      return _tryExpiredCacheOrFail(dateStr, RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return _tryExpiredCacheOrFail(
        dateStr,
        ServerFailure(message: 'Erro inesperado: $e'),
      );
    }
  }

  @override
  Future<Result<List<ApodEntity>>> getApodsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    Logger.info('🔍 Repository: Buscando APODs do período: $startDate - $endDate');

    try {
      // 1. Gera lista de datas do período
      final dates = _generateDateRange(startDate, endDate);
      
      // 2. Verifica quais estão em cache válido
      final cached = await localDataSource.getCachedApodsInRange(
        startDate: startDate,
        endDate: endDate,
      );
      
      final validCached = cached.where((c) => !c.isExpired).toList();
      final cachedDates = validCached.map((c) => c.apod.date).toSet();
      
      // 3. Identifica datas faltantes
      final missingDates = dates.where((d) => !cachedDates.contains(d)).toList();
      
      Logger.debug('📦 Range: ${validCached.length} em cache válido, ${missingDates.length} faltantes');

      List<ApodModel> apiResults = [];
      
      // 4. Busca datas faltantes da API
      if (missingDates.isNotEmpty) {
        try {
          Logger.info('🌐 Buscando ${missingDates.length} APODs faltantes da API...');
          final apods = await remoteDataSource.getApodsByDateRange(
            startDate: startDate,
            endDate: endDate,
          );
          apiResults = apods;
          
          // 5. Salva novos resultados no cache
          await _cacheApodsSafely(apiResults);
          Logger.info('💾 ${apiResults.length} APODs salvos no cache');
        } on NetworkException {
          // Se falhar na API, usa só o que tem em cache
          Logger.warning('⚠️ API indisponível, usando apenas cache');
        } catch (e) {
          Logger.warning('⚠️ Erro na API, usando apenas cache: $e');
        }
      } else {
        Logger.info('✅ Todos os ${dates.length} APODs do range encontrados em CACHE!');
      }

      // 6. Combina resultados de cache e API
      final allApods = <String, ApodEntity>{};
      
      for (final c in validCached) {
        allApods[c.apod.date] = c.apod.toEntity();
      }
      
      for (final a in apiResults) {
        allApods[a.date] = a.toEntity();
      }

      // 7. Ordena por data decrescente
      final result = allApods.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      if (result.isEmpty) {
        return Result.error(
          const NetworkFailure(message: 'Sem conexão e sem dados em cache'),
        );
      }

      return Result.success(result);
    } on NetworkException catch (e) {
      return _tryExpiredCacheRangeOrFail(startDate, endDate, NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return _tryExpiredCacheRangeOrFail(
        startDate, endDate,
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on ValidationException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on InvalidDateException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on ApiKeyException catch (e) {
      return _tryExpiredCacheRangeOrFail(startDate, endDate, ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      return _tryExpiredCacheRangeOrFail(startDate, endDate, RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return _tryExpiredCacheRangeOrFail(
        startDate, endDate,
        ServerFailure(message: 'Erro inesperado: $e'),
      );
    }
  }

  @override
  Future<Result<List<ApodEntity>>> getRandomApods(int count) async {
    Logger.info('🎲 Repository: Buscando $count APODs aleatórios');

    try {
      final apods = await remoteDataSource.getRandomApods(count);
      
      // Salva no cache
      await _cacheApodsSafely(apods);
      Logger.info('💾 $count APODs aleatórios salvos no cache');
      
      return Result.success(apods.map((m) => m.toEntity()).toList());
    } on NetworkException catch (e) {
      // Para aleatórios, tenta retornar do cache existente
      return _tryRandomFromCacheOrFail(count, NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return _tryRandomFromCacheOrFail(
        count,
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on ValidationException catch (e) {
      return Result.error(ValidationFailure(message: e.message));
    } on ApiKeyException catch (e) {
      return _tryRandomFromCacheOrFail(count, ApiKeyFailure(message: e.message));
    } on RateLimitException catch (e) {
      return _tryRandomFromCacheOrFail(count, RateLimitFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return _tryRandomFromCacheOrFail(
        count,
        ServerFailure(message: 'Erro inesperado: $e'),
      );
    }
  }

  // ==================== MÉTODOS AUXILIARES ====================

  /// Tenta retornar cache expirado como fallback, ou retorna erro
  Future<Result<ApodEntity>> _tryExpiredCacheOrFail(
    String date,
    Failure failure,
  ) async {
    final cached = await localDataSource.getCachedApod(date);
    
    if (cached != null) {
      Logger.warning('⚠️ FALLBACK: Usando cache expirado para $date');
      return Result.success(cached.apod.toEntity());
    }
    
    Logger.error('❌ Sem cache disponível para $date');
    return Result.error(failure);
  }

  /// Tenta retornar cache expirado de um período como fallback
  Future<Result<List<ApodEntity>>> _tryExpiredCacheRangeOrFail(
    DateTime startDate,
    DateTime endDate,
    Failure failure,
  ) async {
    Logger.info('📦 Tentando fallback de cache para range de datas...');
    final cached = await localDataSource.getCachedApodsInRange(
      startDate: startDate,
      endDate: endDate,
    );
    
    if (cached.isNotEmpty) {
      Logger.warning('⚠️ FALLBACK: Usando ${cached.length} APODs do cache para o período');
      final entities = cached.map((c) => c.apod.toEntity()).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return Result.success(entities);
    }
    
    return Result.error(failure);
  }

  /// Tenta retornar APODs aleatórios do cache como fallback
  Future<Result<List<ApodEntity>>> _tryRandomFromCacheOrFail(
    int count,
    Failure failure,
  ) async {
    Logger.info('📦 Tentando fallback de cache para APODs aleatórios...');
    final allCached = await localDataSource.getAllCachedApods();
    
    if (allCached.isNotEmpty) {
      // Embaralha e pega a quantidade solicitada
      final shuffled = List<CachedApod>.from(allCached)..shuffle();
      final selected = shuffled.take(count).toList();
      
      Logger.warning('⚠️ FALLBACK: Usando ${selected.length} APODs do cache (de ${allCached.length} disponíveis)');
      
      return Result.success(
        selected.map((c) => c.apod.toEntity()).toList(),
      );
    }
    
    Logger.error('❌ Sem APODs em cache para fallback');
    return Result.error(failure);
  }

  /// Salva APOD no cache de forma segura (não propaga erros)
  Future<void> _cacheApodSafely(ApodModel apod, {bool isToday = false}) async {
    try {
      await localDataSource.cacheApod(apod, isToday: isToday);
    } catch (e) {
      Logger.warning('Falha ao cachear APOD (não crítico): $e');
    }
  }

  /// Salva múltiplos APODs no cache de forma segura
  Future<void> _cacheApodsSafely(List<ApodModel> apods) async {
    try {
      await localDataSource.cacheApods(apods);
    } catch (e) {
      Logger.warning('Falha ao cachear APODs (não crítico): $e');
    }
  }

  /// Formata DateTime para string YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Verifica se a data é hoje
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Gera lista de datas em string para um período
  List<String> _generateDateRange(DateTime start, DateTime end) {
    final dates = <String>[];
    var current = start;
    
    while (!current.isAfter(end)) {
      dates.add(_formatDate(current));
      current = current.add(const Duration(days: 1));
    }
    
    return dates;
  }
}
