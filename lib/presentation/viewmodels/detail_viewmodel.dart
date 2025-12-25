import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'base_viewmodel.dart';

/// ViewModel da tela de detalhes
///
/// Gerencia a exibição detalhada de um APOD.
class DetailViewModel extends BaseViewModel {
  DetailViewModel({
    required FavoritesRepository favoritesRepository,
  }) : _favoritesRepository = favoritesRepository;

  final FavoritesRepository _favoritesRepository;

  ApodEntity? _apod;
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;

  /// APOD atual
  ApodEntity? get apod => _apod;

  /// Indica se é favorito
  bool get isFavorite => _isFavorite;

  /// Indica se a descrição está expandida
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  /// Inicializa com um APOD
  Future<void> initialize(ApodEntity apod) async {
    _apod = apod;
    await _checkFavoriteStatus();
    setSuccess();
  }

  /// Verifica se é favorito
  Future<void> _checkFavoriteStatus() async {
    final apod = _apod;
    if (apod == null) return;

    final result = await _favoritesRepository.isFavorite(apod.date);
    result.fold(
      onSuccess: (isFav) {
        _isFavorite = isFav;
        notifyListeners();
      },
      onFailure: (_) {
        _isFavorite = false;
      },
    );
  }

  /// Alterna o status de favorito
  Future<void> toggleFavorite() async {
    final apod = _apod;
    if (apod == null) return;

    if (_isFavorite) {
      final result = await _favoritesRepository.removeFavoriteByDate(apod.date);
      result.fold(
        onSuccess: (_) {
          _isFavorite = false;
          notifyListeners();
        },
        onFailure: (_) {},
      );
    } else {
      final result = await _favoritesRepository.addFavorite(apod);
      result.fold(
        onSuccess: (_) {
          _isFavorite = true;
          notifyListeners();
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

  /// Atualiza o status de favorito
  Future<void> refreshFavoriteStatus() async {
    await _checkFavoriteStatus();
  }
}
