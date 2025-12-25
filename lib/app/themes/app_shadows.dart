import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Sombras cósmicas do Cosmic Vision
///
/// Sistema de sombras com tom azulado/roxo
/// para criar profundidade com atmosfera espacial.
class AppShadows {
  AppShadows._();

  // ═══════════════════════════════════════════════════════════════════════════
  // SOMBRAS DE ELEVAÇÃO
  // ═══════════════════════════════════════════════════════════════════════════

  /// Elevação 1 - Sombra sutil
  /// offset(0,2), blur 4, color #6B4CE6 com 10% opacity
  static List<BoxShadow> get elevation1 => [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 4,
          color: AppColors.nebulaPurple.withValues(alpha: 0.1),
        ),
      ];

  /// Elevação 2 - Sombra média
  /// offset(0,4), blur 8, color #6B4CE6 com 15% opacity
  static List<BoxShadow> get elevation2 => [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 8,
          color: AppColors.nebulaPurple.withValues(alpha: 0.15),
        ),
      ];

  /// Elevação 3 - Sombra forte
  /// offset(0,8), blur 16, color #6B4CE6 com 20% opacity
  static List<BoxShadow> get elevation3 => [
        BoxShadow(
          offset: const Offset(0, 8),
          blurRadius: 16,
          color: AppColors.nebulaPurple.withValues(alpha: 0.2),
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // EFEITOS DE GLOW
  // ═══════════════════════════════════════════════════════════════════════════

  /// Glow Effect - Brilho suave para elementos interativos
  /// offset(0,0), blur 20, color #818CF8 com 30% opacity
  static List<BoxShadow> get glow => [
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 20,
          color: AppColors.stardust.withValues(alpha: 0.3),
        ),
      ];

  /// Glow Effect Intenso - Para elementos em destaque
  static List<BoxShadow> get glowIntense => [
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 30,
          spreadRadius: 2,
          color: AppColors.stardust.withValues(alpha: 0.4),
        ),
      ];

  /// Glow Stardust - Brilho azul-lavanda suave
  static List<BoxShadow> get glowStardust => [
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 20,
          color: AppColors.stardust.withValues(alpha: 0.3),
        ),
      ];

  /// Glow Nebula - Brilho roxo para botões principais
  static List<BoxShadow> get glowNebula => [
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 20,
          color: AppColors.nebulaPurple.withValues(alpha: 0.4),
        ),
      ];

  /// Glow Orange - Brilho laranja para CTAs especiais
  static List<BoxShadow> get glowOrange => [
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 20,
          color: AppColors.supernovaOrange.withValues(alpha: 0.4),
        ),
      ];

  /// Glow Teal - Brilho ciano para elementos interativos
  static List<BoxShadow> get glowTeal => [
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 20,
          color: AppColors.galacticTeal.withValues(alpha: 0.4),
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // SOMBRAS COMBINADAS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Sombra de card com elevação e glow sutil
  static List<BoxShadow> get card => [
        ...elevation2,
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 12,
          color: AppColors.stardust.withValues(alpha: 0.1),
        ),
      ];

  /// Sombra de card em hover
  static List<BoxShadow> get cardHover => [
        ...elevation3,
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 24,
          color: AppColors.stardust.withValues(alpha: 0.2),
        ),
      ];

  /// Sombra de botão
  static List<BoxShadow> get button => [
        ...elevation1,
        ...glowNebula,
      ];

  /// Sombra de botão pressionado
  static List<BoxShadow> get buttonPressed => [
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 2,
          color: AppColors.nebulaPurple.withValues(alpha: 0.1),
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // INNER SHADOWS (Para efeitos especiais)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Inner shadow para elementos "pressionados"
  static List<BoxShadow> get innerShadow => [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: -1,
          color: Colors.black.withValues(alpha: 0.3),
        ),
      ];
}
