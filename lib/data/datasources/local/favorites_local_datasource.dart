import 'package:sqflite/sqflite.dart';

import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';
import '../../models/favorite_model.dart';
import 'database_helper.dart';

/// Interface do datasource local de favoritos
abstract class FavoritesLocalDataSource {
  /// Obtém todos os favoritos
  Future<List<FavoriteModel>> getAllFavorites({bool sortByDate = true});

  /// Adiciona um favorito
  Future<FavoriteModel> addFavorite(FavoriteModel favorite);

  /// Remove um favorito pelo ID
  Future<void> removeFavoriteById(int id);

  /// Remove um favorito pela data do APOD
  Future<void> removeFavoriteByDate(String date);

  /// Verifica se existe um favorito com a data
  Future<bool> isFavorite(String date);

  /// Busca favoritos por título
  Future<List<FavoriteModel>> searchFavorites(String query);

  /// Conta o total de favoritos
  Future<int> getFavoritesCount();

  /// Remove todos os favoritos
  Future<void> clearAllFavorites();

  /// Obtém um favorito pela data
  Future<FavoriteModel?> getFavoriteByDate(String date);
}

/// Implementação do datasource local usando SQLite
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  static const String _tableName = 'favorites';

  @override
  Future<List<FavoriteModel>> getAllFavorites({bool sortByDate = true}) async {
    Logger.debug('Buscando todos os favoritos do banco de dados');

    try {
      final db = await databaseHelper.database;
      final orderBy = sortByDate ? 'apod_date DESC' : 'favorited_at DESC';

      final maps = await db.query(
        _tableName,
        orderBy: orderBy,
      );

      Logger.debug('Encontrados ${maps.length} favoritos no banco');
      
      final favorites = maps.map((map) {
        Logger.debug('Convertendo favorito: ${map['apod_date']} - ${map['title']}');
        return FavoriteModel.fromDatabase(map);
      }).toList();
      
      return favorites;
    } catch (e, stackTrace) {
      Logger.error('Erro ao buscar favoritos', error: e, stackTrace: stackTrace);
      throw app_exceptions.DatabaseException(message: 'Erro ao buscar favoritos: $e');
    }
  }

  @override
  Future<FavoriteModel> addFavorite(FavoriteModel favorite) async {
    Logger.debug('Adicionando favorito ao banco: ${favorite.apod.date}');

    try {
      final db = await databaseHelper.database;

      // Verifica se já existe
      final existing = await isFavorite(favorite.apod.date);
      if (existing) {
        Logger.warning('APOD ${favorite.apod.date} já está nos favoritos');
        throw const app_exceptions.DatabaseException(message: 'APOD já está nos favoritos');
      }

      final dataToInsert = favorite.toDatabase();
      Logger.debug('Dados a inserir: $dataToInsert');

      final id = await db.insert(
        _tableName,
        dataToInsert,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      Logger.debug('Favorito inserido com ID: $id');

      return FavoriteModel(
        id: id,
        apod: favorite.apod,
        favoritedAt: favorite.favoritedAt,
      );
    } catch (e, stackTrace) {
      if (e is app_exceptions.DatabaseException) rethrow;
      Logger.error('Erro ao adicionar favorito', error: e, stackTrace: stackTrace);
      throw app_exceptions.DatabaseException(message: 'Erro ao adicionar favorito: $e');
    }
  }

  @override
  Future<void> removeFavoriteById(int id) async {
    Logger.debug('Removendo favorito por ID: $id');

    try {
      final db = await databaseHelper.database;
      final count = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw const app_exceptions.DatabaseException(message: 'Favorito não encontrado');
      }
    } catch (e) {
      if (e is app_exceptions.DatabaseException) rethrow;
      Logger.error('Erro ao remover favorito', error: e);
      throw app_exceptions.DatabaseException(message: 'Erro ao remover favorito: $e');
    }
  }

  @override
  Future<void> removeFavoriteByDate(String date) async {
    Logger.debug('Removendo favorito pela data: $date');

    try {
      final db = await databaseHelper.database;
      await db.delete(
        _tableName,
        where: 'apod_date = ?',
        whereArgs: [date],
      );
    } catch (e) {
      Logger.error('Erro ao remover favorito', error: e);
      throw app_exceptions.DatabaseException(message: 'Erro ao remover favorito: $e');
    }
  }

  @override
  Future<bool> isFavorite(String date) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        _tableName,
        where: 'apod_date = ?',
        whereArgs: [date],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      Logger.error('Erro ao verificar favorito', error: e);
      throw app_exceptions.DatabaseException(message: 'Erro ao verificar favorito: $e');
    }
  }

  @override
  Future<List<FavoriteModel>> searchFavorites(String query) async {
    Logger.debug('Buscando favoritos com query: $query');

    try {
      final db = await databaseHelper.database;
      final maps = await db.query(
        _tableName,
        where: 'title LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'apod_date DESC',
      );

      return maps.map((map) => FavoriteModel.fromDatabase(map)).toList();
    } catch (e) {
      Logger.error('Erro ao buscar favoritos', error: e);
      throw app_exceptions.DatabaseException(message: 'Erro ao buscar favoritos: $e');
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      Logger.error('Erro ao contar favoritos', error: e);
      throw app_exceptions.DatabaseException(message: 'Erro ao contar favoritos: $e');
    }
  }

  @override
  Future<void> clearAllFavorites() async {
    Logger.debug('Limpando todos os favoritos');

    try {
      final db = await databaseHelper.database;
      await db.delete(_tableName);
    } catch (e) {
      Logger.error('Erro ao limpar favoritos', error: e);
      throw app_exceptions.DatabaseException(message: 'Erro ao limpar favoritos: $e');
    }
  }

  @override
  Future<FavoriteModel?> getFavoriteByDate(String date) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        _tableName,
        where: 'apod_date = ?',
        whereArgs: [date],
        limit: 1,
      );

      if (result.isEmpty) return null;
      return FavoriteModel.fromDatabase(result.first);
    } catch (e) {
      Logger.error('Erro ao buscar favorito', error: e);
      throw app_exceptions.DatabaseException(message: 'Erro ao buscar favorito: $e');
    }
  }
}
