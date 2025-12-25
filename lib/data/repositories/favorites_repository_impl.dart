import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/apod_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/local/favorites_local_datasource.dart';
import '../models/apod_model.dart';
import '../models/favorite_model.dart';

/// Implementação do repositório de favoritos
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required this.localDataSource});

  final FavoritesLocalDataSource localDataSource;

  @override
  Future<Result<List<FavoriteEntity>>> getAllFavorites({bool sortByDate = true}) async {
    Logger.info('Repository: Buscando todos os favoritos');

    try {
      final favorites = await localDataSource.getAllFavorites(sortByDate: sortByDate);
      return Result.success(favorites.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      Logger.error('Erro ao buscar favoritos', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<FavoriteEntity>> addFavorite(ApodEntity apod) async {
    Logger.info('Repository: Adicionando favorito: ${apod.date}');

    try {
      final apodModel = ApodModel.fromEntity(apod);
      final favoriteModel = FavoriteModel(
        apod: apodModel,
        favoritedAt: DateTime.now(),
      );

      final result = await localDataSource.addFavorite(favoriteModel);
      return Result.success(result.toEntity());
    } on DatabaseException catch (e) {
      Logger.error('Erro ao adicionar favorito', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> removeFavoriteById(int id) async {
    Logger.info('Repository: Removendo favorito: $id');

    try {
      await localDataSource.removeFavoriteById(id);
      return Result.success(null);
    } on DatabaseException catch (e) {
      Logger.error('Erro ao remover favorito', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> removeFavoriteByDate(String date) async {
    Logger.info('Repository: Removendo favorito pela data: $date');

    try {
      await localDataSource.removeFavoriteByDate(date);
      return Result.success(null);
    } on DatabaseException catch (e) {
      Logger.error('Erro ao remover favorito', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<bool>> isFavorite(String date) async {
    try {
      final result = await localDataSource.isFavorite(date);
      return Result.success(result);
    } on DatabaseException catch (e) {
      Logger.error('Erro ao verificar favorito', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<List<FavoriteEntity>>> searchFavorites(String query) async {
    Logger.info('Repository: Buscando favoritos com query: $query');

    try {
      final favorites = await localDataSource.searchFavorites(query);
      return Result.success(favorites.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      Logger.error('Erro ao buscar favoritos', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<int>> getFavoritesCount() async {
    try {
      final count = await localDataSource.getFavoritesCount();
      return Result.success(count);
    } on DatabaseException catch (e) {
      Logger.error('Erro ao contar favoritos', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> clearAllFavorites() async {
    Logger.info('Repository: Limpando todos os favoritos');

    try {
      await localDataSource.clearAllFavorites();
      return Result.success(null);
    } on DatabaseException catch (e) {
      Logger.error('Erro ao limpar favoritos', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Result<FavoriteEntity?>> getFavoriteByDate(String date) async {
    Logger.info('Repository: Buscando favorito pela data: $date');

    try {
      final favorite = await localDataSource.getFavoriteByDate(date);
      return Result.success(favorite?.toEntity());
    } on DatabaseException catch (e) {
      Logger.error('Erro ao buscar favorito', error: e);
      return Result.error(CacheFailure(message: e.message));
    } catch (e) {
      Logger.error('Erro desconhecido', error: e);
      return Result.error(CacheFailure(message: 'Erro inesperado: $e'));
    }
  }
}
