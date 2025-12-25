import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Estilos de texto do Cosmic Vision
///
/// Hierarquia tipográfica usando a fonte Poppins
/// seguindo as guidelines do Material Design 3.
class AppTextStyles {
  AppTextStyles._();

  /// Nome da fonte principal
  static const String fontFamily = 'Poppins';

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Display Large - Para títulos muito grandes
  /// Poppins Bold, 57sp
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.moonlightWhite,
  );

  /// Display Medium - Para títulos grandes
  /// Poppins Bold, 45sp
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.16,
    color: AppColors.moonlightWhite,
  );

  /// Display Small - Para títulos médios-grandes
  /// Poppins Bold, 36sp
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.22,
    color: AppColors.moonlightWhite,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Headline Large - Para seções importantes
  /// Poppins SemiBold, 32sp
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: AppColors.moonlightWhite,
  );

  /// Headline Medium - Para títulos de seção
  /// Poppins SemiBold, 28sp
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: AppColors.moonlightWhite,
  );

  /// Headline Small - Para subtítulos
  /// Poppins SemiBold, 24sp
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.moonlightWhite,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Title Large - Para títulos de cards e dialogs
  /// Poppins SemiBold, 22sp
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.moonlightWhite,
  );

  /// Title Medium - Para títulos secundários
  /// Poppins Medium, 16sp
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.moonlightWhite,
  );

  /// Title Small - Para títulos terciários
  /// Poppins Medium, 14sp
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.moonlightWhite,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Body Large - Para textos principais
  /// Poppins Regular, 16sp
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: AppColors.moonlightWhite,
  );

  /// Body Medium - Para textos padrão
  /// Poppins Regular, 14sp
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.moonlightWhite,
  );

  /// Body Small - Para textos menores
  /// Poppins Regular, 12sp
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.moonlightWhite,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Label Large - Para labels de botões
  /// Poppins Medium, 14sp
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.moonlightWhite,
  );

  /// Label Medium - Para labels médios
  /// Poppins Medium, 12sp
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.moonlightWhite,
  );

  /// Label Small - Para labels pequenos
  /// Poppins Medium, 11sp
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.moonlightWhite,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ESTILOS ESPECÍFICOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Texto de data - Para exibição de datas
  static TextStyle get date => bodySmall.copyWith(
        color: AppColors.asteroidGray,
      );

  /// Texto de descrição - Para descrições secundárias
  static TextStyle get description => bodyMedium.copyWith(
        color: AppColors.asteroidGray,
      );

  /// Texto de título de imagem APOD
  static TextStyle get apodTitle => titleLarge.copyWith(
        fontWeight: FontWeight.w600,
      );

  /// Texto de badge
  static TextStyle get badge => labelSmall.copyWith(
        color: AppColors.moonlightWhite,
        fontWeight: FontWeight.w600,
      );

  /// Texto com gradiente (usado com ShaderMask)
  static TextStyle get gradient => headlineMedium.copyWith(
        fontWeight: FontWeight.w700,
      );
}
