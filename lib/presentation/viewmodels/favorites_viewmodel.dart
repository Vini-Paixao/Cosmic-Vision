import '../../core/utils/logger.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../services/favorites_sync_service.dart';
import 'base_viewmodel.dart';

/// ViewModel da tela Favorites
///
/// Gerencia a lista de APODs favoritos.
class FavoritesViewModel extends BaseViewModel {
  FavoritesViewModel({
    required FavoritesRepository favoritesRepository,
  }) : _favoritesRepository = favoritesRepository;

  final FavoritesRepository _favoritesRepository;
  final FavoritesSyncService _syncService = FavoritesSyncService.instance;

  List<FavoriteEntity> _favorites = [];
  List<FavoriteEntity> _filteredFavorites = [];
  String _searchQuery = '';
  bool _sortByDate = true;

  /// Lista de favoritos
  List<FavoriteEntity> get favorites => _searchQuery.isEmpty 
      ? _favorites 
      : _filteredFavorites;

  /// Query de busca atual
  String get searchQuery => _searchQuery;

  /// Indica se está ordenando por data
  bool get sortByDate => _sortByDate;

  /// Total de favoritos
  int get totalCount => _favorites.length;

  /// Indica se não há favoritos
  bool get isEmpty => _favorites.isEmpty;

  /// Carrega todos os favoritos
  Future<void> loadFavorites() async {
    Logger.debug('FavoritesViewModel: Iniciando carregamento de favoritos');
    
    if (isLoading) {
      Logger.debug('FavoritesViewModel: Já está carregando, ignorando');
      return;
    }

    setLoading();

    final result = await _favoritesRepository.getAllFavorites(
      sortByDate: _sortByDate,
    );

    result.fold(
      onSuccess: (favorites) {
        Logger.debug('FavoritesViewModel: Carregados ${favorites.length} favoritos');
        _favorites = favorites;
        _applySearch();
        
        // Sincroniza o serviço com as datas dos favoritos
        final favoriteDates = favorites.map((f) => f.apod.date).toSet();
        _syncService.updateFavorites(favoriteDates);
        
        setSuccess();
      },
      onFailure: (failure) {
        Logger.error('FavoritesViewModel: Erro ao carregar - ${failure.message}');
        setError(failure.message ?? 'Erro desconhecido');
      },
    );
  }

  /// Recarrega os favoritos
  Future<void> refresh() async {
    await loadFavorites();
  }

  /// Remove um favorito
  Future<bool> removeFavorite(FavoriteEntity favorite) async {
    if (favorite.id == null) return false;

    final result = await _favoritesRepository.removeFavoriteById(favorite.id!);

    return result.fold(
      onSuccess: (_) {
        _favorites.removeWhere((f) => f.id == favorite.id);
        _applySearch();
        
        // Notifica o serviço de sincronização
        _syncService.removeFavorite(favorite.apod.date);
        
        notifyListeners();
        return true;
      },
      onFailure: (_) => false,
    );
  }

  /// Remove favorito pela data do APOD
  Future<bool> removeFavoriteByDate(String date) async {
    final result = await _favoritesRepository.removeFavoriteByDate(date);

    return result.fold(
      onSuccess: (_) {
        _favorites.removeWhere((f) => f.apod.date == date);
        _applySearch();
        
        // Notifica o serviço de sincronização
        _syncService.removeFavorite(date);
        
        notifyListeners();
        return true;
      },
      onFailure: (_) => false,
    );
  }

  /// Define a query de busca
  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applySearch();
    notifyListeners();
  }

  /// Limpa a busca
  void clearSearch() {
    _searchQuery = '';
    _filteredFavorites = [];
    notifyListeners();
  }

  /// Aplica a busca localmente
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredFavorites = [];
      return;
    }

    final query = _searchQuery.toLowerCase();
    _filteredFavorites = _favorites.where((f) {
      return f.apod.title.toLowerCase().contains(query) ||
          f.apod.explanation.toLowerCase().contains(query);
    }).toList();
  }

  /// Alterna a ordenação
  void toggleSortOrder() {
    _sortByDate = !_sortByDate;
    _sortFavorites();
    notifyListeners();
  }

  /// Ordena os favoritos
  void _sortFavorites() {
    if (_sortByDate) {
      _favorites.sort((a, b) => b.apod.date.compareTo(a.apod.date));
    } else {
      _favorites.sort((a, b) => b.favoritedAt.compareTo(a.favoritedAt));
    }
    _applySearch();
  }

  /// Limpa todos os favoritos
  Future<bool> clearAllFavorites() async {
    final result = await _favoritesRepository.clearAllFavorites();

    return result.fold(
      onSuccess: (_) {
        _favorites.clear();
        _filteredFavorites.clear();
        
        // Notifica o serviço de sincronização
        _syncService.clearAll();
        
        notifyListeners();
        return true;
      },
      onFailure: (_) => false,
    );
  }
}
