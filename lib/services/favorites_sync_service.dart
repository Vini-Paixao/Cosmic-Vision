import 'package:flutter/foundation.dart';

import '../core/utils/logger.dart';

/// Serviço de sincronização de favoritos
/// 
/// Notifica todos os listeners quando o estado de favoritos muda,
/// garantindo que todas as telas reflitam o estado correto.
class FavoritesSyncService extends ChangeNotifier {
  FavoritesSyncService._();
  
  static final FavoritesSyncService instance = FavoritesSyncService._();
  
  final Set<String> _favoriteDates = {};
  
  /// Conjunto de datas dos APODs favoritados
  Set<String> get favoriteDates => Set.unmodifiable(_favoriteDates);
  
  /// Verifica se uma data está nos favoritos
  bool isFavorite(String date) => _favoriteDates.contains(date);
  
  /// Inicializa o serviço com as datas dos favoritos
  void initialize(Set<String> dates) {
    _favoriteDates.clear();
    _favoriteDates.addAll(dates);
    Logger.debug('FavoritesSyncService: Inicializado com ${dates.length} favoritos');
  }
  
  /// Adiciona uma data aos favoritos
  void addFavorite(String date) {
    if (_favoriteDates.add(date)) {
      Logger.debug('FavoritesSyncService: Adicionado $date');
      notifyListeners();
    }
  }
  
  /// Remove uma data dos favoritos
  void removeFavorite(String date) {
    if (_favoriteDates.remove(date)) {
      Logger.debug('FavoritesSyncService: Removido $date');
      notifyListeners();
    }
  }
  
  /// Limpa todos os favoritos
  void clearAll() {
    _favoriteDates.clear();
    Logger.debug('FavoritesSyncService: Todos removidos');
    notifyListeners();
  }
  
  /// Atualiza múltiplas datas de uma vez
  void updateFavorites(Set<String> dates) {
    _favoriteDates.clear();
    _favoriteDates.addAll(dates);
    Logger.debug('FavoritesSyncService: Atualizado com ${dates.length} favoritos');
    notifyListeners();
  }
}
