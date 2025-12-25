import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

/// Tema principal do Cosmic Vision
///
/// Configuração completa do ThemeData com design system cósmico.
/// Suporta tema escuro (principal) e claro (opcional).
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA ESCURO (PRINCIPAL)
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: AppTextStyles.fontFamily,

        // Esquema de cores
        colorScheme: const ColorScheme.dark(
          primary: AppColors.nebulaPurple,
          onPrimary: AppColors.moonlightWhite,
          secondary: AppColors.stardust,
          onSecondary: AppColors.moonlightWhite,
          tertiary: AppColors.galacticTeal,
          onTertiary: AppColors.moonlightWhite,
          error: AppColors.error,
          onError: AppColors.moonlightWhite,
          surface: AppColors.eventHorizon,
          onSurface: AppColors.moonlightWhite,
          surfaceContainerHighest: AppColors.eventHorizon,
          outline: AppColors.asteroidGray,
        ),

        // Cor de fundo do Scaffold
        scaffoldBackgroundColor: AppColors.deepSpace,

        // AppBar Theme
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: AppColors.deepSpace,
          ),
          titleTextStyle: AppTextStyles.headlineSmall,
          iconTheme: const IconThemeData(
            color: AppColors.moonlightWhite,
            size: AppDimensions.iconSize,
          ),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.eventHorizon,
          selectedItemColor: AppColors.nebulaPurple,
          unselectedItemColor: AppColors.asteroidGray,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: AppTextStyles.labelSmall,
          unselectedLabelStyle: AppTextStyles.labelSmall,
        ),

        // Navigation Bar Theme (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.eventHorizon,
          indicatorColor: AppColors.nebulaPurple.withValues(alpha: 0.2),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          height: AppDimensions.bottomNavHeight,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTextStyles.labelSmall.copyWith(
                color: AppColors.nebulaPurple,
              );
            }
            return AppTextStyles.labelSmall.copyWith(
              color: AppColors.asteroidGray,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AppColors.nebulaPurple,
                size: AppDimensions.iconSize,
              );
            }
            return const IconThemeData(
              color: AppColors.asteroidGray,
              size: AppDimensions.iconSize,
            );
          }),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.eventHorizon,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusCard,
          ),
          margin: AppDimensions.marginCard,
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.nebulaPurple,
            foregroundColor: AppColors.moonlightWhite,
            elevation: 0,
            padding: AppDimensions.paddingButton,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusButton,
            ),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.stardust,
            padding: AppDimensions.paddingButton,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusButton,
            ),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),

        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.stardust,
            side: const BorderSide(color: AppColors.stardust),
            padding: AppDimensions.paddingButton,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusButton,
            ),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),

        // Icon Button Theme
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.moonlightWhite,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(AppDimensions.spacingSM),
          ),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.nebulaPurple,
          foregroundColor: AppColors.moonlightWhite,
          elevation: 4,
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.eventHorizon,
          contentPadding: AppDimensions.paddingContent,
          border: OutlineInputBorder(
            borderRadius: AppDimensions.borderRadiusDefault,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDimensions.borderRadiusDefault,
            borderSide: BorderSide(
              color: AppColors.asteroidGray.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDimensions.borderRadiusDefault,
            borderSide: const BorderSide(
              color: AppColors.nebulaPurple,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppDimensions.borderRadiusDefault,
            borderSide: const BorderSide(
              color: AppColors.error,
            ),
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.asteroidGray,
          ),
          labelStyle: AppTextStyles.bodyMedium,
        ),

        // Dialog Theme
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.eventHorizon,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusCard,
          ),
          titleTextStyle: AppTextStyles.titleLarge,
          contentTextStyle: AppTextStyles.bodyMedium,
        ),

        // Bottom Sheet Theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.eventHorizon,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusCard),
            ),
          ),
        ),

        // Snackbar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.eventHorizon,
          contentTextStyle: AppTextStyles.bodyMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusDefault,
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: AppColors.asteroidGray.withValues(alpha: 0.2),
          thickness: 1,
          space: AppDimensions.spacingMD,
        ),

        // Progress Indicator Theme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.nebulaPurple,
          circularTrackColor: AppColors.eventHorizon,
          linearTrackColor: AppColors.eventHorizon,
        ),

        // Switch Theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.nebulaPurple;
            }
            return AppColors.asteroidGray;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.nebulaPurple.withValues(alpha: 0.5);
            }
            return AppColors.eventHorizon;
          }),
        ),

        // Checkbox Theme
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.nebulaPurple;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.moonlightWhite),
          side: const BorderSide(color: AppColors.asteroidGray),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        // Text Theme
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          displaySmall: AppTextStyles.displaySmall,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          titleLarge: AppTextStyles.titleLarge,
          titleMedium: AppTextStyles.titleMedium,
          titleSmall: AppTextStyles.titleSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelMedium: AppTextStyles.labelMedium,
          labelSmall: AppTextStyles.labelSmall,
        ),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA CLARO (OPCIONAL)
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: AppTextStyles.fontFamily,

        colorScheme: const ColorScheme.light(
          primary: AppColors.nebulaPurple,
          onPrimary: AppColors.moonlightWhite,
          secondary: AppColors.cosmicBlue,
          onSecondary: AppColors.moonlightWhite,
          tertiary: AppColors.galacticTeal,
          onTertiary: AppColors.moonlightWhite,
          error: AppColors.error,
          onError: AppColors.moonlightWhite,
          surface: AppColors.moonlightWhite,
          onSurface: AppColors.deepSpace,
        ),

        scaffoldBackgroundColor: AppColors.moonlightWhite,

        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.moonlightWhite,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          titleTextStyle: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.deepSpace,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.deepSpace,
            size: AppDimensions.iconSize,
          ),
        ),

        // Outros temas podem ser configurados conforme necessário
      );
}
