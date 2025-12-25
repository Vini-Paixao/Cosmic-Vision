import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';

/// Interface do datasource local de configurações
abstract class SettingsLocalDataSource {
  /// Obtém o modo de tema
  Future<AppThemeMode> getThemeMode();

  /// Define o modo de tema
  Future<void> setThemeMode(AppThemeMode themeMode);

  /// Obtém a qualidade de imagem
  Future<ImageQuality> getImageQuality();

  /// Define a qualidade de imagem
  Future<void> setImageQuality(ImageQuality quality);

  /// Obtém se notificações estão habilitadas
  Future<bool> getNotificationsEnabled();

  /// Define se notificações estão habilitadas
  Future<void> setNotificationsEnabled(bool enabled);

  /// Obtém o horário de notificação (minutos desde meia-noite)
  Future<int> getNotificationTime();

  /// Define o horário de notificação (minutos desde meia-noite)
  Future<void> setNotificationTime(int minutesSinceMidnight);

  /// Verifica se é o primeiro acesso
  Future<bool> isFirstAccess();

  /// Marca como não sendo mais o primeiro acesso
  Future<void> setFirstAccessCompleted();

  /// Limpa todas as configurações
  Future<void> clearAll();
}

/// Implementação usando SharedPreferences
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  // Chaves das preferências
  static const String _themeModeKey = 'theme_mode';
  static const String _imageQualityKey = 'image_quality';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationTimeKey = 'notification_time';
  static const String _firstAccessKey = 'first_access';
  
  // Horário padrão: 8h da manhã (480 minutos desde meia-noite)
  static const int _defaultNotificationTime = 480;

  @override
  Future<AppThemeMode> getThemeMode() async {
    final value = sharedPreferences.getString(_themeModeKey);
    Logger.debug('Obtendo tema: $value');

    return AppThemeMode.fromString(value ?? 'dark');
  }

  @override
  Future<void> setThemeMode(AppThemeMode themeMode) async {
    Logger.debug('Definindo tema: ${themeMode.value}');
    await sharedPreferences.setString(_themeModeKey, themeMode.value);
  }

  @override
  Future<ImageQuality> getImageQuality() async {
    final value = sharedPreferences.getString(_imageQualityKey);
    Logger.debug('Obtendo qualidade de imagem: $value');

    return ImageQuality.fromString(value ?? 'high');
  }

  @override
  Future<void> setImageQuality(ImageQuality quality) async {
    Logger.debug('Definindo qualidade de imagem: ${quality.value}');
    await sharedPreferences.setString(_imageQualityKey, quality.value);
  }

  @override
  Future<bool> getNotificationsEnabled() async {
    final value = sharedPreferences.getBool(_notificationsEnabledKey) ?? true;
    Logger.debug('Obtendo notificações habilitadas: $value');
    return value;
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    Logger.debug('Definindo notificações habilitadas: $enabled');
    await sharedPreferences.setBool(_notificationsEnabledKey, enabled);
  }

  @override
  Future<bool> isFirstAccess() async {
    final value = sharedPreferences.getBool(_firstAccessKey) ?? true;
    Logger.debug('Verificando primeiro acesso: $value');
    return value;
  }

  @override
  Future<void> setFirstAccessCompleted() async {
    Logger.debug('Marcando primeiro acesso como completo');
    await sharedPreferences.setBool(_firstAccessKey, false);
  }

  @override
  Future<int> getNotificationTime() async {
    final value = sharedPreferences.getInt(_notificationTimeKey) ?? _defaultNotificationTime;
    Logger.debug('Obtendo horário de notificação: $value minutos');
    return value;
  }

  @override
  Future<void> setNotificationTime(int minutesSinceMidnight) async {
    Logger.debug('Definindo horário de notificação: $minutesSinceMidnight minutos');
    await sharedPreferences.setInt(_notificationTimeKey, minutesSinceMidnight);
  }

  @override
  Future<void> clearAll() async {
    Logger.debug('Limpando todas as configurações');
    await sharedPreferences.remove(_themeModeKey);
    await sharedPreferences.remove(_imageQualityKey);
    await sharedPreferences.remove(_notificationsEnabledKey);
    await sharedPreferences.remove(_notificationTimeKey);
    await sharedPreferences.remove(_firstAccessKey);
  }
}
