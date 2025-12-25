import 'package:flutter/material.dart';

import '../../app/themes/themes.dart';

/// AppBar customizada com estilo cósmico
class CosmicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CosmicAppBar({
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.transparent = false,
    this.centerTitle = true,
    super.key,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool transparent;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                )
              : null),
      centerTitle: centerTitle,
      backgroundColor: transparent ? Colors.transparent : AppColors.surfaceDark,
      elevation: transparent ? 0 : 0,
      scrolledUnderElevation: 0,
      leading: leading ??
          (showBackButton && Navigator.of(context).canPop()
              ? _buildBackButton(context)
              : null),
      actions: actions,
      flexibleSpace: transparent
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.deepSpace,
                    AppColors.deepSpace.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      icon: Container(
        padding: const EdgeInsets.all(AppDimensions.xs),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar transparente para sobreposição de imagem
class CosmicTransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CosmicTransparentAppBar({
    this.actions,
    this.onBackPressed,
    super.key,
  });

  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.black.withValues(alpha: 0.7),
            AppColors.black.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.sm,
            vertical: AppDimensions.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão voltar
              if (Navigator.of(context).canPop())
                _buildCircularButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                ),
                
              const Spacer(),
              
              // Actions
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.sm),
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
