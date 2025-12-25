import 'package:flutter/material.dart';

import '../../app/themes/themes.dart';
import 'cosmic_button.dart';

/// View de estado de erro
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
    this.title = 'Ops! Algo deu errado',
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.errorRed,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Título
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.sm),

            // Mensagem
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.xl),

            // Botão de retry
            if (onRetry != null)
              CosmicButton(
                onPressed: onRetry,
                label: 'Tentar novamente',
                icon: Icons.refresh_rounded,
              ),
          ],
        ),
      ),
    );
  }
}

/// View de estado vazio
class EmptyView extends StatelessWidget {
  const EmptyView({
    required this.message,
    this.icon = Icons.inbox_rounded,
    this.title = 'Nada por aqui',
    this.action,
    this.actionLabel,
    super.key,
  });

  final String message;
  final IconData icon;
  final String title;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                gradient: AppGradients.glassSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.stardust,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Título
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.sm),

            // Mensagem
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Ação opcional
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: AppDimensions.xl),
              CosmicButton(
                onPressed: action,
                label: actionLabel,
                type: CosmicButtonType.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// View de estado sem conexão
class NoConnectionView extends StatelessWidget {
  const NoConnectionView({
    this.onRetry,
    super.key,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      icon: Icons.wifi_off_rounded,
      title: 'Sem conexão',
      message: 'Verifique sua conexão com a internet e tente novamente.',
      onRetry: onRetry,
    );
  }
}
