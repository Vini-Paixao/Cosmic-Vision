import 'dart:ui';

/// Paleta de cores cósmica do Cosmic Vision
///
/// Design System inspirado no universo com cores de nebulosas,
/// galáxias e elementos astronômicos.
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // CORES PRINCIPAIS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Deep Space - Azul escuro profundo do espaço sideral
  /// Cor primária para backgrounds e elementos principais
  static const Color deepSpace = Color(0xFF0B0D21);

  /// Nebula Purple - Roxo vibrante inspirado em nebulosas
  /// Cor secundária para destaques e elementos interativos
  static const Color nebulaPurple = Color(0xFF6B4CE6);

  /// Cosmic Blue - Azul cósmico profundo
  /// Cor terciária para variações e profundidade
  static const Color cosmicBlue = Color(0xFF1E3A8A);

  /// Stardust - Azul-lavanda luminoso para destaques
  /// Accent color para elementos de destaque e glow effects
  static const Color stardust = Color(0xFF818CF8);

  // ═══════════════════════════════════════════════════════════════════════════
  // CORES DE SUPORTE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Supernova Orange - Laranja energético para CTAs importantes
  static const Color supernovaOrange = Color(0xFFFF6B35);

  /// Galactic Teal - Ciano brilhante para elementos interativos
  static const Color galacticTeal = Color(0xFF06B6D4);

  /// Moonlight White - Branco suave para textos e backgrounds claros
  static const Color moonlightWhite = Color(0xFFF8FAFC);

  /// Asteroid Gray - Cinza neutro para textos secundários
  static const Color asteroidGray = Color(0xFF64748B);

  /// Event Horizon - Cinza escuro para cards e superfícies
  static const Color eventHorizon = Color(0xFF1E293B);

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIAÇÕES DE OPACIDADE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Event Horizon com 10% de opacidade (para glassmorphism)
  static Color get eventHorizon10 => eventHorizon.withValues(alpha: 0.1);

  /// Event Horizon com 20% de opacidade
  static Color get eventHorizon20 => eventHorizon.withValues(alpha: 0.2);

  /// Stardust com 20% de opacidade (para bordas glassmorphism)
  static Color get stardust20 => stardust.withValues(alpha: 0.2);

  /// Stardust com 30% de opacidade (para glow effects)
  static Color get stardust30 => stardust.withValues(alpha: 0.3);

  /// Nebula Purple com 10% de opacidade (para sombras)
  static Color get nebulaPurple10 => nebulaPurple.withValues(alpha: 0.1);

  /// Nebula Purple com 15% de opacidade (para sombras médias)
  static Color get nebulaPurple15 => nebulaPurple.withValues(alpha: 0.15);

  /// Nebula Purple com 20% de opacidade (para sombras fortes)
  static Color get nebulaPurple20 => nebulaPurple.withValues(alpha: 0.2);

  // ═══════════════════════════════════════════════════════════════════════════
  // CORES DE STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Cor de sucesso - Verde espacial
  static const Color success = Color(0xFF10B981);

  /// Cor de erro - Vermelho alerta
  static const Color error = Color(0xFFEF4444);

  /// Cor de warning - Amarelo solar
  static const Color warning = Color(0xFFF59E0B);

  /// Cor de info - Azul informativo
  static const Color info = Color(0xFF3B82F6);

  // ═══════════════════════════════════════════════════════════════════════════
  // CORES SEMÂNTICAS (aliases para facilitar uso)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Preto para fundos e sombras
  static const Color black = Color(0xFF000000);

  /// Branco para textos e ícones
  static const Color white = Color(0xFFFFFFFF);

  /// Cor primária de texto
  static const Color textPrimary = moonlightWhite;

  /// Cor secundária de texto
  static const Color textSecondary = Color(0xFFCBD5E1);

  /// Cor de texto mutado/desabilitado
  static const Color textMuted = asteroidGray;

  /// Cor de superfície escura
  static const Color surfaceDark = eventHorizon;

  /// Cor de superfície clara
  static const Color surfaceLight = Color(0xFF334155);

  /// Cor de destaque laranja (alias)
  static const Color accentOrange = supernovaOrange;

  /// Cor de destaque teal (alias)
  static const Color accentTeal = galacticTeal;

  /// Cor de erro vermelho (alias)
  static const Color errorRed = error;

  /// Cor de sucesso verde (alias)
  static const Color successGreen = success;

  // ═══════════════════════════════════════════════════════════════════════════
  // CORES PARA SHIMMER LOADING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Base color para shimmer (Deep Space)
  static const Color shimmerBase = deepSpace;

  /// Highlight color para shimmer (Stardust)
  static const Color shimmerHighlight = stardust;
}
