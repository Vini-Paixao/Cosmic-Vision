import 'package:flutter/material.dart';

import '../../app/themes/themes.dart';

/// Tipos de botão
enum CosmicButtonType { primary, secondary, text, icon }

/// Tamanhos de botão
enum CosmicButtonSize { small, medium, large }

/// Botão customizado com estilo cósmico
class CosmicButton extends StatelessWidget {
  const CosmicButton({
    required this.onPressed,
    this.label,
    this.icon,
    this.type = CosmicButtonType.primary,
    this.size = CosmicButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.fullWidth = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final CosmicButtonType type;
  final CosmicButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isEnabled && !isLoading ? onPressed : null;

    return switch (type) {
      CosmicButtonType.primary => _buildPrimaryButton(context, effectiveOnPressed),
      CosmicButtonType.secondary => _buildSecondaryButton(context, effectiveOnPressed),
      CosmicButtonType.text => _buildTextButton(context, effectiveOnPressed),
      CosmicButtonType.icon => _buildIconButton(context, effectiveOnPressed),
    };
  }

  Widget _buildPrimaryButton(BuildContext context, VoidCallback? onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: Container(
        decoration: BoxDecoration(
          gradient: isEnabled ? AppGradients.nebula : null,
          color: isEnabled ? null : colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          boxShadow: isEnabled ? AppShadows.glowNebula : null,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: colorScheme.onPrimary,
            padding: _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            ),
          ),
          child: _buildContent(context, colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, VoidCallback? onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: _getPadding(),
          side: BorderSide(
            color: isEnabled
                ? colorScheme.primary
                : colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
        ),
        child: _buildContent(
          context,
          isEnabled ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, VoidCallback? onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        ),
      ),
      child: _buildContent(
          context,
          isEnabled ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, VoidCallback? onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
                width: _getIconSize(),
                height: _getIconSize(),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              )
            : Icon(
                icon,
                size: _getIconSize(),
                color: isEnabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
        iconSize: _getIconSize(),
        padding: EdgeInsets.all(_getIconPadding()),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color color) {
    final textTheme = Theme.of(context).textTheme;
    
    if (isLoading) {
      return SizedBox(
        width: _getLoadingSize(),
        height: _getLoadingSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    if (icon != null && label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: AppDimensions.spacingSM),
          Text(label!, style: _getTextStyle(textTheme)),
        ],
      );
    }

    if (icon != null) {
      return Icon(icon, size: _getIconSize());
    }

    return Text(label ?? '', style: _getTextStyle(textTheme));
  }

  double _getHeight() {
    return switch (size) {
      CosmicButtonSize.small => AppDimensions.buttonHeightSM,
      CosmicButtonSize.medium => AppDimensions.buttonHeightMD,
      CosmicButtonSize.large => AppDimensions.buttonHeightLG,
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      CosmicButtonSize.small => const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingSM,
          vertical: AppDimensions.spacingXS,
        ),
      CosmicButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMD,
          vertical: AppDimensions.spacingSM,
        ),
      CosmicButtonSize.large => const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLG,
          vertical: AppDimensions.spacingMD,
        ),
    };
  }

  TextStyle? _getTextStyle(TextTheme textTheme) {
    return switch (size) {
      CosmicButtonSize.small => textTheme.labelMedium,
      CosmicButtonSize.medium => textTheme.labelLarge,
      CosmicButtonSize.large => textTheme.titleSmall,
    };
  }

  double _getIconSize() {
    return switch (size) {
      CosmicButtonSize.small => 18,
      CosmicButtonSize.medium => 20,
      CosmicButtonSize.large => 22,
    };
  }

  double _getIconPadding() {
    return switch (size) {
      CosmicButtonSize.small => AppDimensions.spacingXS,
      CosmicButtonSize.medium => AppDimensions.spacingSM,
      CosmicButtonSize.large => AppDimensions.spacingMD,
    };
  }

  double _getLoadingSize() {
    return switch (size) {
      CosmicButtonSize.small => 16,
      CosmicButtonSize.medium => 18,
      CosmicButtonSize.large => 20,
    };
  }
}
