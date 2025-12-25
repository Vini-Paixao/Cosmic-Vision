import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../services/favorites_sync_service.dart';
import 'base_viewmodel.dart';

/// ViewModel da tela Explore
///
/// Gerencia a listagem de APODs por data e aleatórios.
class ExploreViewModel extends BaseViewModel {
  ExploreViewModel({
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

  List<ApodEntity> _apods = [];
  DateTime? _selectedDate;
  bool _isLoadingMore = false;

  /// Lista de APODs carregados
  List<ApodEntity> get apods => _apods;

  /// Data selecionada para busca
  DateTime? get selectedDate => _selectedDate;

  /// Indica se está carregando mais itens
  bool get isLoadingMore => _isLoadingMore;
  
  void _onFavoritesChanged() {
    notifyListeners();
  }

  /// Carrega APODs aleatórios
  Future<void> loadRandomApods({int count = 10}) async {
    if (isLoading) return;

    setLoading();

    final result = await _apodRepository.getRandomApods(count);

    result.fold(
      onSuccess: (apods) async {
        _apods = apods;
        await _loadFavoriteStatuses();
        setSuccess();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro ao carregar APOD por data');
      },
    );
  }

  /// Carrega APODs de um período específico
  Future<void> loadApodsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (isLoading) return;

    setLoading();

    final result = await _apodRepository.getApodsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      onSuccess: (apods) async {
        _apods = apods;
        await _loadFavoriteStatuses();
        setSuccess();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro desconhecido');
      },
    );
  }

  /// Carrega APOD de uma data específica
  Future<void> loadApodByDate(DateTime date) async {
    _selectedDate = date;
    setLoading();

    final result = await _apodRepository.getApodByDate(date);

    result.fold(
      onSuccess: (apod) async {
        _apods = [apod];
        await _loadFavoriteStatuses();
        setSuccess();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro ao carregar APOD por data');
      },
    );
  }

  /// Carrega mais APODs (para infinite scroll)
  Future<void> loadMore() async {
    if (_isLoadingMore || isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    final result = await _apodRepository.getRandomApods(5);

    result.fold(
      onSuccess: (newApods) async {
        // Filtra APODs já existentes
        final existingDates = _apods.map((a) => a.date).toSet();
        final uniqueApods = newApods.where((a) => !existingDates.contains(a.date)).toList();
        
        _apods = [..._apods, ...uniqueApods];
        await _loadFavoriteStatuses();
        _isLoadingMore = false;
        notifyListeners();
      },
      onFailure: (failure) {
        _isLoadingMore = false;
        notifyListeners();
      },
    );
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadRandomApods();
  }

  /// Limpa a seleção de data
  void clearDateSelection() {
    _selectedDate = null;
    notifyListeners();
  }

  /// Verifica se um APOD está nos favoritos
  bool isFavorite(String date) {
    return _syncService.isFavorite(date);
  }

  /// Alterna o status de favorito de um APOD
  Future<void> toggleFavorite(ApodEntity apod) async {
    if (_syncService.isFavorite(apod.date)) {
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

  /// Carrega o status de favorito de todos os APODs e sincroniza
  Future<void> _loadFavoriteStatuses() async {
    final favoriteDates = <String>{};

    for (final apod in _apods) {
      final result = await _favoritesRepository.isFavorite(apod.date);
      result.fold(
        onSuccess: (isFav) {
          if (isFav) favoriteDates.add(apod.date);
        },
        onFailure: (_) {},
      );
    }
    
    // Atualiza o serviço de sincronização com as datas dos favoritos atuais
    // Isso só adiciona os que estão na lista, não remove os outros
    for (final date in favoriteDates) {
      if (!_syncService.isFavorite(date)) {
        _syncService.addFavorite(date);
      }
    }
  }

  @override
  void dispose() {
    _syncService.removeListener(_onFavoritesChanged);
    super.dispose();
  }
}
