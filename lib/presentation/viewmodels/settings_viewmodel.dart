import '../../core/constants/app_constants.dart';
import '../../domain/repositories/settings_repository.dart';
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
  bool _notificationsEnabled = true;

  /// Modo de tema atual
  AppThemeMode get themeMode => _themeMode;

  /// Qualidade de imagem atual
  ImageQuality get imageQuality => _imageQuality;

  /// Indica se notificações estão habilitadas
  bool get notificationsEnabled => _notificationsEnabled;

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
      onFailure: (_) => _notificationsEnabled = true,
    );

    setSuccess();
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
  Future<void> setNotificationsEnabled(bool enabled) async {
    final result = await _settingsRepository.setNotificationsEnabled(enabled);

    result.fold(
      onSuccess: (_) {
        _notificationsEnabled = enabled;
        notifyListeners();
      },
      onFailure: (failure) {
        setError(failure.message ?? 'Erro ao salvar notificações');
      },
    );
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
