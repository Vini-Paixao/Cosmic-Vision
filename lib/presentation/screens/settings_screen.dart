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
                      onTap: () {
                        // TODO: Link para a loja
                      },
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
      subtitle: 'Receba um lembrete quando o novo APOD estiver disponível',
      trailing: Switch(
        value: viewModel.notificationsEnabled,
        onChanged: viewModel.setNotificationsEnabled,
        activeColor: AppColors.nebulaPurple,
        activeTrackColor: AppColors.nebulaPurple.withValues(alpha: 0.5),
        inactiveThumbColor: AppColors.textMuted,
        inactiveTrackColor: AppColors.surfaceLight,
      ),
    );
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
