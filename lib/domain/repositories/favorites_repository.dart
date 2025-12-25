import '../../core/utils/result.dart';
import '../entities/apod_entity.dart';
import '../entities/favorite_entity.dart';

/// Interface do repositório de Favoritos
///
/// Define o contrato para gerenciamento de favoritos
/// persistidos localmente no banco SQLite.
abstract class FavoritesRepository {
  /// Obtém todos os favoritos
  ///
  /// [sortByDate] - Se true, ordena por data do APOD (mais recente primeiro)
  ///                Se false, ordena por data de adição (mais recente primeiro)
  Future<Result<List<FavoriteEntity>>> getAllFavorites({
    bool sortByDate = true,
  });

  /// Adiciona um APOD aos favoritos
  ///
  /// [apod] - APOD a ser favoritado
  /// Retorna o FavoriteEntity criado
  Future<Result<FavoriteEntity>> addFavorite(ApodEntity apod);

  /// Remove um favorito pelo ID
  ///
  /// [id] - ID do favorito no banco
  Future<Result<void>> removeFavoriteById(int id);

  /// Remove um favorito pela data do APOD
  ///
  /// [date] - Data do APOD no formato YYYY-MM-DD
  Future<Result<void>> removeFavoriteByDate(String date);

  /// Verifica se um APOD está nos favoritos
  ///
  /// [date] - Data do APOD no formato YYYY-MM-DD
  Future<Result<bool>> isFavorite(String date);

  /// Busca favoritos por título
  ///
  /// [query] - Termo de busca
  Future<Result<List<FavoriteEntity>>> searchFavorites(String query);

  /// Conta o total de favoritos
  Future<Result<int>> getFavoritesCount();

  /// Remove todos os favoritos
  Future<Result<void>> clearAllFavorites();

  /// Obtém um favorito específico pela data
  ///
  /// [date] - Data do APOD
  Future<Result<FavoriteEntity?>> getFavoriteByDate(String date);
}
