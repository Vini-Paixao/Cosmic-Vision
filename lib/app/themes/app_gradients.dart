import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradientes cósmicos do Cosmic Vision
///
/// Gradientes inspirados em galáxias, nebulosas e auroras
/// para criar uma experiência visual imersiva.
class AppGradients {
  AppGradients._();

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PRINCIPAIS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gradient Galaxy - Do espaço profundo ao roxo nebuloso
  /// Ideal para backgrounds principais e splash screen
  static const LinearGradient galaxy = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.deepSpace,
      AppColors.cosmicBlue,
      AppColors.nebulaPurple,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradient Galaxy Vertical - Versão vertical do Galaxy
  static const LinearGradient galaxyVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.deepSpace,
      AppColors.cosmicBlue,
      AppColors.nebulaPurple,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradient Nebula - Do roxo ao ciano através do stardust
  /// Ideal para botões e elementos de destaque
  static const LinearGradient nebula = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.nebulaPurple,
      AppColors.stardust,
      AppColors.galacticTeal,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradient Aurora - Do laranja ao roxo através do azul
  /// Ideal para CTAs importantes e elementos especiais
  static const LinearGradient aurora = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.supernovaOrange,
      AppColors.nebulaPurple,
      AppColors.cosmicBlue,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTES DE SUPERFÍCIE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gradient para cards com efeito de profundidade
  static LinearGradient get cardSurface => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.eventHorizon.withValues(alpha: 0.8),
          AppColors.deepSpace.withValues(alpha: 0.6),
        ],
      );

  /// Gradient de superfície para cards
  static LinearGradient get surface => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.eventHorizon.withValues(alpha: 0.9),
          AppColors.deepSpace.withValues(alpha: 0.7),
        ],
      );

  /// Gradient para glassmorphism
  static LinearGradient get glass => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.moonlightWhite.withValues(alpha: 0.1),
          AppColors.moonlightWhite.withValues(alpha: 0.05),
        ],
      );

  /// Gradient para glassmorphism em superfícies
  static LinearGradient get glassSurface => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.eventHorizon.withValues(alpha: 0.6),
          AppColors.deepSpace.withValues(alpha: 0.4),
        ],
      );

  /// Gradient para overlay em imagens
  static const LinearGradient imageOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x80000000),
      Color(0xCC000000),
    ],
    stops: [0.0, 0.6, 1.0],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PARA SHIMMER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gradient para efeito shimmer cósmico
  static const LinearGradient shimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.deepSpace,
      AppColors.stardust,
      AppColors.deepSpace,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PARA APP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gradient para AppBar com transparência
  static LinearGradient get appBar => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.deepSpace.withValues(alpha: 0.95),
          AppColors.deepSpace.withValues(alpha: 0.0),
        ],
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PARA BOTTOM NAV
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gradient para Bottom Navigation Bar
  static LinearGradient get bottomNav => LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          AppColors.eventHorizon,
          AppColors.eventHorizon.withValues(alpha: 0.0),
        ],
      );
}
