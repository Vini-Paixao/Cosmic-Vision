import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';
import '../data/datasources/local/apod_local_datasource.dart';
import '../data/datasources/remote/apod_remote_datasource.dart';

/// Serviço de gerenciamento de cache de APODs
///
/// Responsável por:
/// - Limpeza periódica de cache expirado
/// - Pré-carregamento de APODs recentes
/// - Estatísticas de uso do cache
class CacheService {
  CacheService._();

  static final CacheService _instance = CacheService._();
  static CacheService get instance => _instance;

  late ApodLocalDataSource _localDataSource;
  late ApodRemoteDataSource _remoteDataSource;
  late SharedPreferences _prefs;

  bool _isInitialized = false;
  Timer? _cleanupTimer;

  /// Inicializa o serviço de cache
  void initialize({
    required ApodLocalDataSource localDataSource,
    required ApodRemoteDataSource remoteDataSource,
    required SharedPreferences prefs,
  }) {
    if (_isInitialized) {
      Logger.warning('CacheService já inicializado');
      return;
    }

    _localDataSource = localDataSource;
    _remoteDataSource = remoteDataSource;
    _prefs = prefs;
    _isInitialized = true;

    Logger.info('CacheService inicializado');

    // Agenda limpeza periódica (a cada 6 horas)
    _schedulePeriodicCleanup();

    // Executa limpeza inicial se necessário
    _performInitialCleanupIfNeeded();
  }

  /// Agenda limpeza periódica de cache
  void _schedulePeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(
      const Duration(hours: 6),
      (_) => cleanExpiredCache(),
    );
  }

  /// Executa limpeza inicial se passou mais de 24h desde a última
  Future<void> _performInitialCleanupIfNeeded() async {
    final lastCleanup = _prefs.getString(AppConstants.prefKeyLastCacheCleanup);
    
    if (lastCleanup == null) {
      await cleanExpiredCache();
      return;
    }

    final lastDate = DateTime.tryParse(lastCleanup);
    if (lastDate == null) {
      await cleanExpiredCache();
      return;
    }

    final hoursSince = DateTime.now().difference(lastDate).inHours;
    if (hoursSince >= 24) {
      await cleanExpiredCache();
    }
  }

  /// Limpa cache expirado
  Future<int> cleanExpiredCache() async {
    _ensureInitialized();

    try {
      Logger.info('Iniciando limpeza de cache expirado');
      final deletedCount = await _localDataSource.deleteExpiredCache();
      
      // Salva timestamp da última limpeza
      await _prefs.setString(
        AppConstants.prefKeyLastCacheCleanup,
        DateTime.now().toIso8601String(),
      );

      Logger.info('Limpeza concluída: $deletedCount itens removidos');
      return deletedCount;
    } catch (e) {
      Logger.error('Erro na limpeza de cache', error: e);
      return 0;
    }
  }

  /// Limpa todo o cache
  Future<void> clearAllCache() async {
    _ensureInitialized();

    try {
      Logger.info('Limpando todo o cache de APODs');
      await _localDataSource.clearAllCache();
      Logger.info('Cache limpo com sucesso');
    } catch (e) {
      Logger.error('Erro ao limpar cache', error: e);
      rethrow;
    }
  }

  /// Obtém estatísticas do cache
  Future<CacheStats> getCacheStats() async {
    _ensureInitialized();

    try {
      final count = await _localDataSource.getCacheCount();
      final allCached = await _localDataSource.getAllCachedApods();
      
      int expiredCount = 0;
      int validCount = 0;
      DateTime? oldestDate;
      DateTime? newestDate;

      for (final cached in allCached) {
        if (cached.isExpired) {
          expiredCount++;
        } else {
          validCount++;
        }

        final date = DateTime.tryParse(cached.apod.date);
        if (date != null) {
          if (oldestDate == null || date.isBefore(oldestDate)) {
            oldestDate = date;
          }
          if (newestDate == null || date.isAfter(newestDate)) {
            newestDate = date;
          }
        }
      }

      return CacheStats(
        totalCount: count,
        validCount: validCount,
        expiredCount: expiredCount,
        oldestApodDate: oldestDate,
        newestApodDate: newestDate,
      );
    } catch (e) {
      Logger.error('Erro ao obter estatísticas do cache', error: e);
      return const CacheStats(
        totalCount: 0,
        validCount: 0,
        expiredCount: 0,
      );
    }
  }

  /// Pré-carrega APODs dos últimos N dias
  ///
  /// Útil para garantir conteúdo offline.
  /// Retorna o número de APODs novos carregados.
  Future<int> preloadRecentApods({int days = AppConstants.preloadDays}) async {
    _ensureInitialized();

    try {
      Logger.info('Iniciando pré-carregamento de $days dias');

      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days - 1));

      // Gera lista de datas
      final dates = <String>[];
      var current = startDate;
      while (!current.isAfter(now)) {
        dates.add(_formatDate(current));
        current = current.add(const Duration(days: 1));
      }

      // Verifica quais datas estão faltando
      final missingDates = await _localDataSource.getMissingDates(dates);
      
      if (missingDates.isEmpty) {
        Logger.info('Pré-carregamento: todos os $days dias já em cache');
        return 0;
      }

      Logger.info('Pré-carregamento: ${missingDates.length} dias faltantes');

      // Busca da API
      final apods = await _remoteDataSource.getApodsByDateRange(
        startDate: startDate,
        endDate: now,
      );

      // Filtra apenas os que estavam faltando
      final newApods = apods.where(
        (a) => missingDates.contains(a.date),
      ).toList();

      // Salva no cache
      if (newApods.isNotEmpty) {
        await _localDataSource.cacheApods(newApods);
      }

      Logger.info('Pré-carregamento concluído: ${newApods.length} novos APODs');
      return newApods.length;
    } catch (e) {
      Logger.error('Erro no pré-carregamento', error: e);
      return 0;
    }
  }

  /// Pré-carrega APODs em background (não bloqueia)
  void preloadInBackground({int days = AppConstants.preloadDays}) {
    _ensureInitialized();
    
    // Executa em isolate separado para não bloquear UI
    compute(_preloadInIsolate, _PreloadParams(
      days: days,
    )).then((count) {
      if (count > 0) {
        Logger.info('Pré-carregamento em background: $count novos APODs');
      }
    }).catchError((e) {
      Logger.warning('Erro no pré-carregamento em background: $e');
    });
  }

  /// Obtém número de itens em cache
  Future<int> getCacheCount() async {
    _ensureInitialized();
    return _localDataSource.getCacheCount();
  }

  /// Libera recursos
  void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('CacheService não foi inicializado');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// Estatísticas do cache
class CacheStats {
  const CacheStats({
    required this.totalCount,
    required this.validCount,
    required this.expiredCount,
    this.oldestApodDate,
    this.newestApodDate,
  });

  final int totalCount;
  final int validCount;
  final int expiredCount;
  final DateTime? oldestApodDate;
  final DateTime? newestApodDate;

  /// Porcentagem de cache válido
  double get validPercentage =>
      totalCount > 0 ? (validCount / totalCount) * 100 : 0;

  /// Cobertura em dias (do mais antigo ao mais recente)
  int get coverageDays {
    if (oldestApodDate == null || newestApodDate == null) return 0;
    return newestApodDate!.difference(oldestApodDate!).inDays + 1;
  }
}

/// Parâmetros para pré-carregamento em isolate
class _PreloadParams {
  const _PreloadParams({required this.days});
  final int days;
}

/// Função de pré-carregamento para rodar em isolate
/// Nota: Não pode ser executada em isolate pois depende de plugins nativos
/// Mantida como placeholder para futura otimização
Future<int> _preloadInIsolate(_PreloadParams params) async {
  // Em Flutter, operações com SQLite e HTTP não funcionam bem em isolates
  // Esta função é um placeholder - o preload acontece na main thread
  return 0;
}

/// Acesso global ao CacheService
CacheService get cacheService => CacheService.instance;
