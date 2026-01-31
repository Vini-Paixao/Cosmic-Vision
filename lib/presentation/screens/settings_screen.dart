import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/themes/themes.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/cosmic_app_bar.dart';

/// Tela de Configurações
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CosmicAppBar(
        title: 'Configurações',
        showBackButton: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.galaxy,
        ),
        child: Consumer<SettingsViewModel>(
          builder: (context, viewModel, _) {
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                // Seção: Aparência
                _buildSection(
                  title: 'Aparência',
                  children: [
                    _buildThemeSelector(viewModel),
                    _buildQualitySelector(viewModel),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),

                // Seção: Notificações
                _buildSection(
                  title: 'Notificações',
                  children: [
                    _buildNotificationToggle(viewModel),
                    if (viewModel.notificationsEnabled)
                      _buildNotificationTime(viewModel),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),

                // Seção: Cache
                _buildSection(
                  title: 'Cache de Dados',
                  children: [
                    _buildCacheInfo(viewModel),
                    _buildClearCacheButton(viewModel),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),

                // Seção: Sobre
                _buildSection(
                  title: 'Sobre',
                  children: [
                    _buildAboutItem(
                      icon: Icons.info_outline_rounded,
                      title: 'Versão',
                      subtitle: AppConstants.appVersion,
                    ),
                    _buildAboutItem(
                      icon: Icons.api_rounded,
                      title: 'NASA APOD API',
                      subtitle: 'Powered by NASA Open APIs',
                      onTap: () => _openUrl(ApiConstants.nasaWebsite),
                    ),
                    _buildAboutItem(
                      icon: Icons.code_rounded,
                      title: 'Código fonte',
                      subtitle: 'Ver no GitHub',
                      onTap: () => _openUrl('https://github.com'),
                    ),
                    _buildAboutItem(
                      icon: Icons.star_outline_rounded,
                      title: 'Avaliar o app',
                      subtitle: 'Deixe sua avaliação na loja',
                      onTap: () => _openUrl(
                        'https://play.google.com/store/apps/details?id=br.com.marcuspaixao.cosmicvision',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.sm,
            bottom: AppDimensions.sm,
          ),
          child: Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.stardust,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: AppColors.nebulaPurple.withValues(alpha: 0.2),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(SettingsViewModel viewModel) {
    return _buildSettingItem(
      icon: Icons.dark_mode_rounded,
      title: 'Tema',
      trailing: DropdownButton<AppThemeMode>(
        value: viewModel.themeMode,
        underline: const SizedBox(),
        dropdownColor: AppColors.surfaceDark,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        items: AppThemeMode.values.map((mode) {
          return DropdownMenuItem(
            value: mode,
            child: Text(viewModel.getThemeLabel(mode)),
          );
        }).toList(),
        onChanged: (mode) {
          if (mode != null) {
            viewModel.setThemeMode(mode);
          }
        },
      ),
    );
  }

  Widget _buildQualitySelector(SettingsViewModel viewModel) {
    return _buildSettingItem(
      icon: Icons.high_quality_rounded,
      title: 'Qualidade de imagem',
      trailing: DropdownButton<ImageQuality>(
        value: viewModel.imageQuality,
        underline: const SizedBox(),
        dropdownColor: AppColors.surfaceDark,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        items: ImageQuality.values.map((quality) {
          return DropdownMenuItem(
            value: quality,
            child: Text(viewModel.getQualityLabel(quality)),
          );
        }).toList(),
        onChanged: (quality) {
          if (quality != null) {
            viewModel.setImageQuality(quality);
          }
        },
      ),
    );
  }

  Widget _buildNotificationToggle(SettingsViewModel viewModel) {
    return _buildSettingItem(
      icon: Icons.notifications_rounded,
      title: 'Notificação diária',
      subtitle: viewModel.notificationsEnabled 
          ? 'Ativada - ${viewModel.notificationTimeFormatted}'
          : 'Receba um lembrete quando o novo APOD estiver disponível',
      trailing: Switch(
        value: viewModel.notificationsEnabled,
        onChanged: (enabled) async {
          final success = await viewModel.setNotificationsEnabled(enabled);
          if (!success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.white),
                    SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: Text(
                        'Permissão de notificação negada. Ative nas configurações do dispositivo.',
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.supernovaOrange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                margin: const EdgeInsets.all(AppDimensions.md),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        activeThumbColor: AppColors.nebulaPurple,
        activeTrackColor: AppColors.nebulaPurple.withValues(alpha: 0.5),
        inactiveThumbColor: AppColors.textMuted,
        inactiveTrackColor: AppColors.surfaceLight,
      ),
    );
  }

  Widget _buildNotificationTime(SettingsViewModel viewModel) {
    return _buildSettingItem(
      icon: Icons.access_time_rounded,
      title: 'Horário da notificação',
      subtitle: viewModel.notificationTimeFormatted,
      onTap: () => _showTimePicker(viewModel),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.science_rounded,
              color: AppColors.galacticTeal,
              size: 20,
            ),
            tooltip: 'Testar notificação',
            onPressed: () async {
              await viewModel.sendTestNotification();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.white),
                        SizedBox(width: AppDimensions.sm),
                        Text('Notificação de teste enviada!'),
                      ],
                    ),
                    backgroundColor: AppColors.galacticTeal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    margin: const EdgeInsets.all(AppDimensions.md),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(SettingsViewModel viewModel) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: viewModel.notificationHour,
        minute: viewModel.notificationMinute,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.galacticTeal,
              onPrimary: AppColors.white,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.deepSpace,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.deepSpace,
              hourMinuteColor: AppColors.eventHorizon,
              hourMinuteTextColor: AppColors.textPrimary,
              dialBackgroundColor: AppColors.eventHorizon,
              dialHandColor: AppColors.galacticTeal,
              dialTextColor: AppColors.textPrimary,
              entryModeIconColor: AppColors.stardust,
              helpTextStyle: AppTextStyles.titleSmall.copyWith(
                color: AppColors.stardust,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await viewModel.setNotificationTime(picked.hour, picked.minute);
    }
  }

  Widget _buildCacheInfo(SettingsViewModel viewModel) {
    final stats = viewModel.cacheStats;
    
    String subtitle;
    if (viewModel.isCacheLoading) {
      subtitle = 'Carregando...';
    } else if (stats == null) {
      subtitle = 'Não foi possível carregar informações';
    } else if (stats.totalCount == 0) {
      subtitle = 'Nenhum APOD em cache';
    } else {
      subtitle = '${stats.validCount} APODs salvos';
      if (stats.coverageDays > 0) {
        subtitle += ' (${stats.coverageDays} dias de cobertura)';
      }
    }

    return _buildSettingItem(
      icon: Icons.storage_rounded,
      title: 'Dados offline',
      subtitle: subtitle,
      trailing: viewModel.isCacheLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.nebulaPurple,
              ),
            )
          : IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.stardust,
              ),
              onPressed: viewModel.loadCacheStats,
            ),
    );
  }

  Widget _buildClearCacheButton(SettingsViewModel viewModel) {
    return _buildSettingItem(
      icon: Icons.delete_outline_rounded,
      title: 'Limpar cache',
      subtitle: 'Remove todos os dados salvos localmente',
      onTap: viewModel.isCacheClearing
          ? null
          : () => _showClearCacheDialog(viewModel),
      trailing: viewModel.isCacheClearing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.nebulaPurple,
              ),
            )
          : const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
    );
  }

  Future<void> _showClearCacheDialog(SettingsViewModel viewModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: Text(
          'Limpar cache?',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Isso removerá todos os APODs salvos localmente. '
          'O app precisará de conexão com a internet para exibir conteúdo.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Limpar',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.supernovaOrange,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await viewModel.clearCache();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cache limpo com sucesso'),
            backgroundColor: AppColors.surfaceDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
          ),
        );
      }
    }
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: AppColors.nebulaPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.nebulaPurple,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildAboutItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return _buildSettingItem(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: onTap != null
          ? const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            )
          : null,
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
