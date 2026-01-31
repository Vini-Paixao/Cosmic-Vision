import 'package:sqflite/sqflite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import '../../models/apod_model.dart';
import 'database_helper.dart';

/// Model para APOD em cache com metadados
class CachedApod {
  const CachedApod({
    required this.apod,
    required this.cachedAt,
    required this.expiresAt,
  });

  final ApodModel apod;
  final DateTime cachedAt;
  final DateTime expiresAt;

  /// Verifica se o cache expirou
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Cria a partir de dados do banco
  factory CachedApod.fromDatabase(Map<String, dynamic> map) {
    return CachedApod(
      apod: ApodModel.fromDatabase(map),
      cachedAt: DateTime.parse(map['cached_at'] as String),
      expiresAt: DateTime.parse(map['expires_at'] as String),
    );
  }

  /// Converte para Map do banco
  Map<String, dynamic> toDatabase() {
    return {
      ...apod.toDatabase(),
      'cached_at': cachedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}

/// Interface para datasource local de APODs
abstract class ApodLocalDataSource {
  /// Obtém um APOD do cache pela data
  Future<CachedApod?> getCachedApod(String date);

  /// Obtém múltiplos APODs do cache
  Future<List<CachedApod>> getCachedApods(List<String> dates);

  /// Obtém todos os APODs em cache
  Future<List<CachedApod>> getAllCachedApods();

  /// Salva um APOD no cache
  Future<void> cacheApod(ApodModel apod, {bool isToday = false});

  /// Salva múltiplos APODs no cache
  Future<void> cacheApods(List<ApodModel> apods);

  /// Remove APODs expirados do cache
  Future<int> deleteExpiredCache();

  /// Limpa todo o cache
  Future<void> clearAllCache();

  /// Obtém o número de itens em cache
  Future<int> getCacheCount();

  /// Obtém datas que estão faltando no cache
  Future<List<String>> getMissingDates(List<String> dates);

  /// Obtém APODs em cache para um período
  Future<List<CachedApod>> getCachedApodsInRange({
    required DateTime startDate,
    required DateTime endDate,
  });
}

/// Implementação do datasource local de APODs
class ApodLocalDataSourceImpl implements ApodLocalDataSource {
  ApodLocalDataSourceImpl({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  static const String _tableName = 'apod_cache';

  @override
  Future<CachedApod?> getCachedApod(String date) async {
    try {
      final db = await databaseHelper.database;
      
      final results = await db.query(
        _tableName,
        where: 'date = ?',
        whereArgs: [date],
        limit: 1,
      );

      if (results.isEmpty) {
        Logger.debug('📦 Cache MISS para data: $date');
        return null;
      }

      final cached = CachedApod.fromDatabase(results.first);
      final status = cached.isExpired ? '⏰ EXPIRADO' : '✅ VÁLIDO';
      Logger.info('📦 Cache HIT $status para: $date (title: ${cached.apod.title.substring(0, cached.apod.title.length.clamp(0, 30))}...)');
      return cached;
    } catch (e, stack) {
      Logger.error('❌ Erro ao buscar cache para $date', error: e, stackTrace: stack);
      return null;
    }
  }

  @override
  Future<List<CachedApod>> getCachedApods(List<String> dates) async {
    if (dates.isEmpty) return [];

    try {
      final db = await databaseHelper.database;
      
      final placeholders = List.filled(dates.length, '?').join(',');
      final results = await db.query(
        _tableName,
        where: 'date IN ($placeholders)',
        whereArgs: dates,
      );

      final cached = results.map((r) => CachedApod.fromDatabase(r)).toList();
      Logger.debug('Cache: encontrados ${cached.length}/${dates.length} APODs');
      return cached;
    } catch (e) {
      Logger.error('Erro ao buscar múltiplos caches', error: e);
      return [];
    }
  }

  @override
  Future<List<CachedApod>> getAllCachedApods() async {
    try {
      final db = await databaseHelper.database;
      
      final results = await db.query(
        _tableName,
        orderBy: 'date DESC',
      );

      return results.map((r) => CachedApod.fromDatabase(r)).toList();
    } catch (e) {
      Logger.error('Erro ao buscar todos os caches', error: e);
      return [];
    }
  }

  @override
  Future<void> cacheApod(ApodModel apod, {bool isToday = false}) async {
    try {
      final db = await databaseHelper.database;
      final now = DateTime.now();
      
      // Define expiração: hoje = 24h, antigos = 30 dias
      final expiresAt = isToday
          ? now.add(const Duration(hours: AppConstants.todayApodCacheHours))
          : now.add(const Duration(days: AppConstants.oldApodCacheDays));

      final cached = CachedApod(
        apod: apod,
        cachedAt: now,
        expiresAt: expiresAt,
      );

      await db.insert(
        _tableName,
        cached.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      Logger.info('💾 APOD salvo em cache: ${apod.date} - "${apod.title}" (expira: ${expiresAt.toIso8601String()})');
    } catch (e, stack) {
      Logger.error('❌ Erro ao cachear APOD ${apod.date}', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> cacheApods(List<ApodModel> apods) async {
    if (apods.isEmpty) return;

    try {
      final db = await databaseHelper.database;
      final now = DateTime.now();
      final todayStr = _formatDate(now);
      
      final batch = db.batch();

      for (final apod in apods) {
        final isToday = apod.date == todayStr;
        final expiresAt = isToday
            ? now.add(const Duration(hours: AppConstants.todayApodCacheHours))
            : now.add(const Duration(days: AppConstants.oldApodCacheDays));

        final cached = CachedApod(
          apod: apod,
          cachedAt: now,
          expiresAt: expiresAt,
        );

        batch.insert(
          _tableName,
          cached.toDatabase(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      Logger.info('💾 ${apods.length} APODs salvos em cache com sucesso');
    } catch (e, stack) {
      Logger.error('❌ Erro ao cachear múltiplos APODs', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<int> deleteExpiredCache() async {
    try {
      final db = await databaseHelper.database;
      final now = DateTime.now().toIso8601String();

      final deletedCount = await db.delete(
        _tableName,
        where: 'expires_at < ?',
        whereArgs: [now],
      );

      if (deletedCount > 0) {
        Logger.info('$deletedCount APODs expirados removidos do cache');
      }

      return deletedCount;
    } catch (e) {
      Logger.error('Erro ao limpar cache expirado', error: e);
      return 0;
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final db = await databaseHelper.database;
      await db.delete(_tableName);
      Logger.info('Cache de APODs limpo completamente');
    } catch (e) {
      Logger.error('Erro ao limpar todo o cache', error: e);
      rethrow;
    }
  }

  @override
  Future<int> getCacheCount() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      Logger.error('Erro ao contar itens em cache', error: e);
      return 0;
    }
  }

  @override
  Future<List<String>> getMissingDates(List<String> dates) async {
    if (dates.isEmpty) return [];

    try {
      final db = await databaseHelper.database;
      
      final placeholders = List.filled(dates.length, '?').join(',');
      final results = await db.query(
        _tableName,
        columns: ['date'],
        where: 'date IN ($placeholders)',
        whereArgs: dates,
      );

      final cachedDates = results.map((r) => r['date'] as String).toSet();
      final missing = dates.where((d) => !cachedDates.contains(d)).toList();
      
      Logger.debug('Datas faltando no cache: ${missing.length}/${dates.length}');
      return missing;
    } catch (e) {
      Logger.error('Erro ao verificar datas faltantes', error: e);
      return dates; // Retorna todas como faltantes em caso de erro
    }
  }

  @override
  Future<List<CachedApod>> getCachedApodsInRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final db = await databaseHelper.database;
      
      final startStr = _formatDate(startDate);
      final endStr = _formatDate(endDate);

      final results = await db.query(
        _tableName,
        where: 'date >= ? AND date <= ?',
        whereArgs: [startStr, endStr],
        orderBy: 'date DESC',
      );

      return results.map((r) => CachedApod.fromDatabase(r)).toList();
    } catch (e) {
      Logger.error('Erro ao buscar cache por período', error: e);
      return [];
    }
  }

  /// Formata DateTime para string no formato YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
