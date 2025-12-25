/// Constantes gerais do aplicativo
class AppConstants {
  AppConstants._();

  /// Nome do aplicativo
  static const String appName = 'Cosmic Vision';

  /// Versão do aplicativo
  static const String appVersion = '1.0.0';

  /// Descrição do aplicativo
  static const String appDescription =
      'Explore o universo com as imagens astronômicas da NASA';

  /// Nome do banco de dados SQLite
  static const String databaseName = 'cosmic_vision.db';

  /// Versão do banco de dados
  static const int databaseVersion = 1;

  /// Chave para SharedPreferences - tema
  static const String prefKeyTheme = 'theme_mode';

  /// Chave para SharedPreferences - qualidade de imagem
  static const String prefKeyImageQuality = 'image_quality';

  /// Chave para SharedPreferences - notificações
  static const String prefKeyNotifications = 'notifications_enabled';

  /// Chave para SharedPreferences - horário de notificação
  static const String prefKeyNotificationTime = 'notification_time';

  /// Chave para SharedPreferences - primeiro acesso
  static const String prefKeyFirstAccess = 'first_access';

  /// Duração do cache de imagens em dias
  static const int imageCacheDuration = 7;

  /// Máximo de itens no cache
  static const int maxCacheItems = 100;
}

/// Enum para tipos de mídia APOD
enum MediaType {
  image('image'),
  video('video');

  const MediaType(this.value);
  final String value;

  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MediaType.image,
    );
  }
}

/// Enum para qualidade de imagem
enum ImageQuality {
  sd('sd', 'SD'),
  hd('hd', 'HD'),
  original('original', 'Original');

  const ImageQuality(this.value, this.label);
  final String value;
  final String label;

  static ImageQuality fromString(String value) {
    return ImageQuality.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ImageQuality.hd,
    );
  }
}

/// Enum para modo de tema
enum AppThemeMode {
  dark('dark', 'Escuro'),
  light('light', 'Claro'),
  system('system', 'Sistema');

  const AppThemeMode(this.value, this.label);
  final String value;
  final String label;

  static AppThemeMode fromString(String value) {
    return AppThemeMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AppThemeMode.dark,
    );
  }
}
