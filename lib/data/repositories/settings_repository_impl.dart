import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/settings_local_datasource.dart';

/// Implementação do repositório de configurações
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.localDataSource});

  final SettingsLocalDataSource localDataSource;

  @override
  Future<Result<AppThemeMode>> getThemeMode() async {
    Logger.info('Repository: Obtendo modo de tema');

    try {
      final themeMode = await localDataSource.getThemeMode();
      return Result.success(themeMode);
    } catch (e) {
      Logger.error('Erro ao obter tema', error: e);
      return Result.error(CacheFailure(message: 'Erro ao obter tema: $e'));
    }
  }

  @override
  Future<Result<void>> setThemeMode(AppThemeMode themeMode) async {
    Logger.info('Repository: Definindo modo de tema: ${themeMode.value}');

    try {
      await localDataSource.setThemeMode(themeMode);
      return Result.success(null);
    } catch (e) {
      Logger.error('Erro ao definir tema', error: e);
      return Result.error(CacheFailure(message: 'Erro ao definir tema: $e'));
    }
  }

  @override
  Future<Result<ImageQuality>> getImageQuality() async {
    Logger.info('Repository: Obtendo qualidade de imagem');

    try {
      final quality = await localDataSource.getImageQuality();
      return Result.success(quality);
    } catch (e) {
      Logger.error('Erro ao obter qualidade', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao obter qualidade de imagem: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setImageQuality(ImageQuality quality) async {
    Logger.info('Repository: Definindo qualidade de imagem: ${quality.value}');

    try {
      await localDataSource.setImageQuality(quality);
      return Result.success(null);
    } catch (e) {
      Logger.error('Erro ao definir qualidade', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao definir qualidade de imagem: $e'),
      );
    }
  }

  @override
  Future<Result<bool>> isNotificationsEnabled() async {
    Logger.info('Repository: Obtendo status de notificações');

    try {
      final enabled = await localDataSource.getNotificationsEnabled();
      return Result.success(enabled);
    } catch (e) {
      Logger.error('Erro ao obter notificações', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao obter status de notificações: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setNotificationsEnabled(bool enabled) async {
    Logger.info('Repository: Definindo notificações: $enabled');

    try {
      await localDataSource.setNotificationsEnabled(enabled);
      return Result.success(null);
    } catch (e) {
      Logger.error('Erro ao definir notificações', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao definir notificações: $e'),
      );
    }
  }

  @override
  Future<Result<bool>> isFirstAccess() async {
    Logger.info('Repository: Verificando primeiro acesso');

    try {
      final isFirst = await localDataSource.isFirstAccess();
      return Result.success(isFirst);
    } catch (e) {
      Logger.error('Erro ao verificar primeiro acesso', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao verificar primeiro acesso: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setFirstAccessDone() async {
    Logger.info('Repository: Marcando primeiro acesso como completo');

    try {
      await localDataSource.setFirstAccessCompleted();
      return Result.success(null);
    } catch (e) {
      Logger.error('Erro ao marcar primeiro acesso', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao marcar primeiro acesso: $e'),
      );
    }
  }

  @override
  Future<Result<int>> getNotificationTime() async {
    Logger.info('Repository: Obtendo horário de notificação');

    try {
      final time = await localDataSource.getNotificationTime();
      return Result.success(time);
    } catch (e) {
      Logger.error('Erro ao obter horário de notificação', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao obter horário de notificação: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setNotificationTime(int minutesSinceMidnight) async {
    Logger.info('Repository: Definindo horário de notificação: $minutesSinceMidnight');

    try {
      await localDataSource.setNotificationTime(minutesSinceMidnight);
      return Result.success(null);
    } catch (e) {
      Logger.error('Erro ao definir horário de notificação', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao definir horário de notificação: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    Logger.info('Repository: Limpando todas as configurações');

    try {
      await localDataSource.clearAll();
      return Result.success(null);
    } catch (e) {
      Logger.error('Erro ao limpar configurações', error: e);
      return Result.error(
        CacheFailure(message: 'Erro ao limpar configurações: $e'),
      );
    }
  }
}
