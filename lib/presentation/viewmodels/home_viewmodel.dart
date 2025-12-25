import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'base_viewmodel.dart';

/// ViewModel da tela Home
///
/// Gerencia o APOD do dia e o estado de favorito.
class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    required ApodRepository apodRepository,
    required FavoritesRepository favoritesRepository,
  })  : _apodRepository = apodRepository,
        _favoritesRepository = favoritesRepository;

  final ApodRepository _apodRepository;
  final FavoritesRepository _favoritesRepository;

  ApodEntity? _todayApod;
  bool _isFavorite = false;

  /// APOD do dia atual
  ApodEntity? get todayApod => _todayApod;

  /// Indica se o APOD atual está nos favoritos
  bool get isFavorite => _isFavorite;

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

    if (_isFavorite) {
      final result = await _favoritesRepository.removeFavoriteByDate(apod.date);
      result.fold(
        onSuccess: (_) {
          _isFavorite = false;
          notifyListeners();
        },
        onFailure: (failure) {
          // Manter estado atual se falhar
        },
      );
    } else {
      final result = await _favoritesRepository.addFavorite(apod);
      result.fold(
        onSuccess: (_) {
          _isFavorite = true;
          notifyListeners();
        },
        onFailure: (failure) {
          // Manter estado atual se falhar
        },
      );
    }
  }

  /// Verifica se o APOD está nos favoritos
  Future<void> _checkFavoriteStatus(String date) async {
    final result = await _favoritesRepository.isFavorite(date);
    result.fold(
      onSuccess: (isFav) {
        _isFavorite = isFav;
      },
      onFailure: (_) {
        _isFavorite = false;
      },
    );
  }

  /// Atualiza o status de favorito externamente
  Future<void> refreshFavoriteStatus() async {
    final apod = _todayApod;
    if (apod != null) {
      await _checkFavoriteStatus(apod.date);
      notifyListeners();
    }
  }
}
