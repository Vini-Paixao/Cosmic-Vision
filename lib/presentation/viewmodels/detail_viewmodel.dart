import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../services/favorites_sync_service.dart';
import 'base_viewmodel.dart';

/// ViewModel da tela de detalhes
///
/// Gerencia a exibição detalhada de um APOD.
class DetailViewModel extends BaseViewModel {
  DetailViewModel({
    required FavoritesRepository favoritesRepository,
  }) : _favoritesRepository = favoritesRepository;

  final FavoritesRepository _favoritesRepository;
  final FavoritesSyncService _syncService = FavoritesSyncService.instance;

  ApodEntity? _apod;
  bool _isDescriptionExpanded = false;

  /// APOD atual
  ApodEntity? get apod => _apod;

  /// Indica se é favorito (usa o serviço de sincronização)
  bool get isFavorite => _apod != null && _syncService.isFavorite(_apod!.date);

  /// Indica se a descrição está expandida
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  /// Inicializa com um APOD
  Future<void> initialize(ApodEntity apod) async {
    _apod = apod;
    
    // Escuta mudanças no serviço de sincronização
    _syncService.addListener(_onFavoritesChanged);
    
    setSuccess();
  }
  
  void _onFavoritesChanged() {
    notifyListeners();
  }

  /// Alterna o status de favorito
  Future<void> toggleFavorite() async {
    final apod = _apod;
    if (apod == null) return;

    if (isFavorite) {
      final result = await _favoritesRepository.removeFavoriteByDate(apod.date);
      result.fold(
        onSuccess: (_) {
          _syncService.removeFavorite(apod.date);
        },
        onFailure: (_) {},
      );
    } else {
      final result = await _favoritesRepository.addFavorite(apod);
      result.fold(
        onSuccess: (_) {
          _syncService.addFavorite(apod.date);
        },
        onFailure: (_) {},
      );
    }
  }

  /// Alterna a expansão da descrição
  void toggleDescriptionExpanded() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    notifyListeners();
  }

  @override
  void dispose() {
    _syncService.removeListener(_onFavoritesChanged);
    super.dispose();
  }
}
