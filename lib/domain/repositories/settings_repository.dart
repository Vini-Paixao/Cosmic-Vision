import '../../core/constants/app_constants.dart';
import '../../core/utils/result.dart';

/// Interface do repositório de Configurações
///
/// Define o contrato para gerenciamento de preferências
/// do usuário persistidas localmente.
abstract class SettingsRepository {
  /// Obtém o modo de tema atual
  Future<Result<AppThemeMode>> getThemeMode();

  /// Define o modo de tema
  Future<Result<void>> setThemeMode(AppThemeMode mode);

  /// Obtém a qualidade de imagem preferida
  Future<Result<ImageQuality>> getImageQuality();

  /// Define a qualidade de imagem
  Future<Result<void>> setImageQuality(ImageQuality quality);

  /// Verifica se as notificações estão habilitadas
  Future<Result<bool>> isNotificationsEnabled();

  /// Habilita/desabilita notificações
  Future<Result<void>> setNotificationsEnabled(bool enabled);

  /// Obtém o horário de notificação (em minutos desde meia-noite)
  Future<Result<int>> getNotificationTime();

  /// Define o horário de notificação
  Future<Result<void>> setNotificationTime(int minutesSinceMidnight);

  /// Verifica se é o primeiro acesso
  Future<Result<bool>> isFirstAccess();

  /// Marca que não é mais o primeiro acesso
  Future<Result<void>> setFirstAccessDone();

  /// Limpa todas as preferências
  Future<Result<void>> clearAll();
}
