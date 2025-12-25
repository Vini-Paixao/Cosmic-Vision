import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../services/favorites_sync_service.dart';
import 'base_viewmodel.dart';

/// ViewModel da tela Home
///
/// Gerencia o APOD do dia e o estado de favorito.
class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    required ApodRepository apodRepository,
    required FavoritesRepository favoritesRepository,
  })  : _apodRepository = apodRepository,
        _favoritesRepository = favoritesRepository {
    // Escuta mudanças no serviço de sincronização
    _syncService.addListener(_onFavoritesChanged);
  }

  final ApodRepository _apodRepository;
  final FavoritesRepository _favoritesRepository;
  final FavoritesSyncService _syncService = FavoritesSyncService.instance;

  ApodEntity? _todayApod;

  /// APOD do dia atual
  ApodEntity? get todayApod => _todayApod;

  /// Indica se o APOD atual está nos favoritos (usa serviço de sincronização)
  bool get isFavorite => _todayApod != null && _syncService.isFavorite(_todayApod!.date);
  
  void _onFavoritesChanged() {
    notifyListeners();
  }

  /// Carrega o APOD do dia
  Future<void> loadTodayApod() async {
    if (isLoading) return;

    setLoading();

    final result = await _apodRepository.getTodayApod();

    result.fold(
      onSuccess: (apod) async {
        _todayApod = apod;
        await _checkFavoriteStatus(apod.date);
        setSuccess();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro desconhecido');
      },
    );
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadTodayApod();
  }

  /// Alterna o status de favorito
  Future<void> toggleFavorite() async {
    final apod = _todayApod;
    if (apod == null) return;

    if (isFavorite) {
      final result = await _favoritesRepository.removeFavoriteByDate(apod.date);
      result.fold(
        onSuccess: (_) {
          _syncService.removeFavorite(apod.date);
        },
        onFailure: (failure) {
          // Manter estado atual se falhar
        },
      );
    } else {
      final result = await _favoritesRepository.addFavorite(apod);
      result.fold(
        onSuccess: (_) {
          _syncService.addFavorite(apod.date);
        },
        onFailure: (failure) {
          // Manter estado atual se falhar
        },
      );
    }
  }

  /// Verifica se o APOD está nos favoritos e sincroniza
  Future<void> _checkFavoriteStatus(String date) async {
    final result = await _favoritesRepository.isFavorite(date);
    result.fold(
      onSuccess: (isFav) {
        if (isFav && !_syncService.isFavorite(date)) {
          _syncService.addFavorite(date);
        }
      },
      onFailure: (_) {},
    );
  }

  @override
  void dispose() {
    _syncService.removeListener(_onFavoritesChanged);
    super.dispose();
  }
}
