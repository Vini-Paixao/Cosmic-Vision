import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../services/cache_service.dart';
import '../../services/notification_service.dart';
import 'base_viewmodel.dart';

/// ViewModel da tela Settings
///
/// Gerencia as configurações do aplicativo.
class SettingsViewModel extends BaseViewModel {
  SettingsViewModel({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;

  AppThemeMode _themeMode = AppThemeMode.dark;
  ImageQuality _imageQuality = ImageQuality.hd;
  bool _notificationsEnabled = false;
  int _notificationHour = 8;
  int _notificationMinute = 0;
  
  // Cache stats
  CacheStats? _cacheStats;
  bool _isCacheLoading = false;
  bool _isCacheClearing = false;

  /// Modo de tema atual
  AppThemeMode get themeMode => _themeMode;

  /// Qualidade de imagem atual
  ImageQuality get imageQuality => _imageQuality;

  /// Indica se notificações estão habilitadas
  bool get notificationsEnabled => _notificationsEnabled;

  /// Hora da notificação (0-23)
  int get notificationHour => _notificationHour;

  /// Minuto da notificação (0-59)
  int get notificationMinute => _notificationMinute;

  /// Horário formatado da notificação
  String get notificationTimeFormatted {
    final hour = _notificationHour.toString().padLeft(2, '0');
    final minute = _notificationMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Estatísticas do cache
  CacheStats? get cacheStats => _cacheStats;

  /// Indica se está carregando stats do cache
  bool get isCacheLoading => _isCacheLoading;

  /// Indica se está limpando o cache
  bool get isCacheClearing => _isCacheClearing;

  /// Carrega todas as configurações
  Future<void> loadSettings() async {
    setLoading();

    // Carrega tema
    final themeResult = await _settingsRepository.getThemeMode();
    themeResult.fold(
      onSuccess: (mode) => _themeMode = mode,
      onFailure: (_) => _themeMode = AppThemeMode.dark,
    );

    // Carrega qualidade de imagem
    final qualityResult = await _settingsRepository.getImageQuality();
    qualityResult.fold(
      onSuccess: (quality) => _imageQuality = quality,
      onFailure: (_) => _imageQuality = ImageQuality.hd,
    );

    // Carrega status de notificações
    final notificationsResult = await _settingsRepository.isNotificationsEnabled();
    notificationsResult.fold(
      onSuccess: (enabled) => _notificationsEnabled = enabled,
      onFailure: (_) => _notificationsEnabled = false,
    );

    // Carrega horário da notificação
    final timeResult = await _settingsRepository.getNotificationTime();
    timeResult.fold(
      onSuccess: (minutesSinceMidnight) {
        _notificationHour = minutesSinceMidnight ~/ 60;
        _notificationMinute = minutesSinceMidnight % 60;
      },
      onFailure: (_) {
        _notificationHour = 8;
        _notificationMinute = 0;
      },
    );

    // Carrega estatísticas do cache
    await loadCacheStats();

    setSuccess();
  }

  /// Carrega estatísticas do cache
  Future<void> loadCacheStats() async {
    _isCacheLoading = true;
    notifyListeners();

    try {
      _cacheStats = await CacheService.instance.getCacheStats();
    } catch (e) {
      _cacheStats = null;
    }

    _isCacheLoading = false;
    notifyListeners();
  }

  /// Limpa todo o cache de APODs
  Future<void> clearCache() async {
    _isCacheClearing = true;
    notifyListeners();

    try {
      await CacheService.instance.clearAllCache();
      await loadCacheStats();
    } catch (e) {
      setError('Erro ao limpar cache: $e');
    }

    _isCacheClearing = false;
    notifyListeners();
  }

  /// Limpa apenas o cache expirado
  Future<int> cleanExpiredCache() async {
    try {
      final deleted = await CacheService.instance.cleanExpiredCache();
      await loadCacheStats();
      return deleted;
    } catch (e) {
      setError('Erro ao limpar cache expirado: $e');
      return 0;
    }
  }

  /// Define o modo de tema
  Future<void> setThemeMode(AppThemeMode mode) async {
    final result = await _settingsRepository.setThemeMode(mode);

    result.fold(
      onSuccess: (_) {
        _themeMode = mode;
        notifyListeners();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro ao salvar tema');
      },
    );
  }

  /// Define a qualidade de imagem
  Future<void> setImageQuality(ImageQuality quality) async {
    final result = await _settingsRepository.setImageQuality(quality);

    result.fold(
      onSuccess: (_) {
        _imageQuality = quality;
        notifyListeners();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro ao salvar qualidade');
      },
    );
  }

  /// Define se notificações estão habilitadas
  Future<bool> setNotificationsEnabled(bool enabled) async {
    debugPrint('🔔 [SettingsVM] setNotificationsEnabled: $enabled');
    
    // Se ativando, solicita permissão primeiro
    if (enabled) {
      final hasPermission = await NotificationService.instance.requestPermission();
      if (!hasPermission) {
        debugPrint('⚠️ [SettingsVM] Permissão negada');
        return false;
      }
    }

    final result = await _settingsRepository.setNotificationsEnabled(enabled);

    return result.fold(
      onSuccess: (_) async {
        _notificationsEnabled = enabled;
        
        if (enabled) {
          // Agenda a notificação
          await NotificationService.instance.scheduleDailyNotification(
            hour: _notificationHour,
            minute: _notificationMinute,
          );
          debugPrint('✅ [SettingsVM] Notificação agendada para $_notificationHour:$_notificationMinute');
        } else {
          // Cancela a notificação
          await NotificationService.instance.cancelDailyNotification();
          debugPrint('🚫 [SettingsVM] Notificação cancelada');
        }
        
        notifyListeners();
        return true;
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro ao salvar notificações');
        return false;
      },
    );
  }

  /// Define o horário da notificação
  Future<void> setNotificationTime(int hour, int minute) async {
    debugPrint('⏰ [SettingsVM] setNotificationTime: $hour:$minute');
    
    final minutesSinceMidnight = hour * 60 + minute;
    final result = await _settingsRepository.setNotificationTime(minutesSinceMidnight);

    result.fold(
      onSuccess: (_) async {
        _notificationHour = hour;
        _notificationMinute = minute;
        
        // Se notificações estão ativadas, reagenda com novo horário
        if (_notificationsEnabled) {
          await NotificationService.instance.scheduleDailyNotification(
            hour: hour,
            minute: minute,
          );
          debugPrint('✅ [SettingsVM] Notificação reagendada para $hour:$minute');
        }
        
        notifyListeners();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro ao salvar horário');
      },
    );
  }

  /// Envia notificação de teste
  Future<void> sendTestNotification() async {
    debugPrint('🧪 [SettingsVM] Enviando notificação de teste...');
    await NotificationService.instance.showTestNotification();
  }

  /// Retorna o label do tema
  String getThemeLabel(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => 'Claro',
      AppThemeMode.dark => 'Escuro',
      AppThemeMode.system => 'Sistema',
    };
  }

  /// Retorna o label da qualidade
  String getQualityLabel(ImageQuality quality) {
    return switch (quality) {
      ImageQuality.sd => 'Baixa (SD)',
      ImageQuality.hd => 'Alta (HD)',
      ImageQuality.original => 'Original',
    };
  }
}
