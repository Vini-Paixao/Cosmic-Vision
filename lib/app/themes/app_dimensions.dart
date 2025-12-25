import 'package:flutter/material.dart';

/// Dimensões e espaçamentos do Cosmic Vision
///
/// Sistema de grid baseado em unidade de 8dp
/// para consistência visual em toda a aplicação.
class AppDimensions {
  AppDimensions._();

  // ═══════════════════════════════════════════════════════════════════════════
  // UNIDADE BASE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Unidade base do sistema de grid (8dp)
  static const double unit = 8.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // ESPAÇAMENTOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Espaçamento extra pequeno (4dp)
  static const double spacingXS = unit * 0.5; // 4dp

  /// Espaçamento pequeno (8dp)
  static const double spacingSM = unit; // 8dp

  /// Espaçamento médio (16dp) - Padding padrão
  static const double spacingMD = unit * 2; // 16dp

  /// Espaçamento grande (24dp)
  static const double spacingLG = unit * 3; // 24dp

  /// Espaçamento extra grande (32dp)
  static const double spacingXL = unit * 4; // 32dp

  /// Espaçamento extra extra grande (48dp)
  static const double spacingXXL = unit * 6; // 48dp

  // Aliases para compatibilidade
  /// Alias: espaçamento extra pequeno
  static const double xs = spacingXS;
  /// Alias: espaçamento pequeno
  static const double sm = spacingSM;
  /// Alias: espaçamento médio
  static const double md = spacingMD;
  /// Alias: espaçamento grande
  static const double lg = spacingLG;
  /// Alias: espaçamento extra grande
  static const double xl = spacingXL;
  /// Alias: espaçamento extra extra grande
  static const double xxl = spacingXXL;

  // ═══════════════════════════════════════════════════════════════════════════
  // PADDING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Padding padrão para telas (16dp horizontal)
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: spacingMD,
  );

  /// Padding para conteúdo geral
  static const EdgeInsets paddingContent = EdgeInsets.all(spacingMD);

  /// Padding para cards
  static const EdgeInsets paddingCard = EdgeInsets.all(spacingMD);

  /// Padding para botões
  static const EdgeInsets paddingButton = EdgeInsets.symmetric(
    horizontal: spacingLG,
    vertical: spacingSM,
  );

  /// Padding para itens de lista
  static const EdgeInsets paddingListItem = EdgeInsets.symmetric(
    horizontal: spacingMD,
    vertical: spacingSM,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // MARGENS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Margem para cards (16dp horizontal, 12dp vertical)
  static const EdgeInsets marginCard = EdgeInsets.symmetric(
    horizontal: spacingMD,
    vertical: spacingSM + spacingXS, // 12dp
  );

  /// Margem entre seções
  static const EdgeInsets marginSection = EdgeInsets.only(
    bottom: spacingLG,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Border radius pequeno (8dp)
  static const double radiusSM = unit; // 8dp

  /// Border radius médio/padrão (12dp)
  static const double radiusMD = unit * 1.5; // 12dp

  // Aliases (camelCase minúsculo)
  /// Alias: border radius pequeno
  static const double radiusSm = radiusSM;
  /// Alias: border radius médio
  static const double radiusMd = radiusMD;

  /// Border radius padrão (16dp)
  static const double radiusDefault = unit * 2; // 16dp

  /// Border radius para cards (20dp)
  static const double radiusCard = unit * 2.5; // 20dp

  /// Border radius grande (24dp)
  static const double radiusLg = unit * 3; // 24dp

  /// Border radius extra grande (32dp)
  static const double radiusXl = unit * 4; // 32dp

  /// Border radius para botões (12dp)
  static const double radiusButton = radiusMD; // 12dp

  /// Border radius circular (para avatares)
  static const double radiusCircular = 999.0;

  /// BorderRadius padrão
  static BorderRadius get borderRadiusDefault =>
      BorderRadius.circular(radiusDefault);

  /// BorderRadius para cards
  static BorderRadius get borderRadiusCard => BorderRadius.circular(radiusCard);

  /// BorderRadius para botões
  static BorderRadius get borderRadiusButton =>
      BorderRadius.circular(radiusButton);

  /// BorderRadius pequeno
  static BorderRadius get borderRadiusSM => BorderRadius.circular(radiusSM);

  // ═══════════════════════════════════════════════════════════════════════════
  // TAMANHOS DE COMPONENTES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Altura do AppBar
  static const double appBarHeight = 56.0;

  /// Altura do Bottom Navigation Bar
  static const double bottomNavHeight = 80.0;

  /// Altura de botões padrão
  static const double buttonHeight = 48.0;

  /// Altura de botões pequenos
  static const double buttonHeightSM = 36.0;

  /// Altura de botões médios
  static const double buttonHeightMD = 44.0;

  /// Altura de botões grandes
  static const double buttonHeightLG = 56.0;

  /// Tamanho de ícones padrão
  static const double iconSize = 24.0;

  /// Tamanho de ícones pequenos
  static const double iconSizeSM = 20.0;

  /// Tamanho de ícones grandes
  static const double iconSizeLG = 32.0;

  /// Altura de cards de imagem na home
  static const double imageCardHeight = 300.0;

  /// Altura de thumbnails na lista
  static const double thumbnailHeight = 120.0;

  /// Largura de thumbnails na lista
  static const double thumbnailWidth = 160.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // ELEVAÇÃO
  // ═══════════════════════════════════════════════════════════════════════════

  /// Elevação nível 1
  static const double elevation1 = 2.0;

  /// Elevação nível 2
  static const double elevation2 = 4.0;

  /// Elevação nível 3
  static const double elevation3 = 8.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // ANIMAÇÕES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Duração de animação rápida
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Duração de animação padrão
  static const Duration animationDefault = Duration(milliseconds: 300);

  /// Duração de animação normal (alias)
  static const Duration animNormal = animationDefault;

  /// Duração de animação rápida (alias)
  static const Duration animFast = animationFast;

  /// Duração de animação lenta
  static const Duration animationSlow = Duration(milliseconds: 400);

  /// Duração de animação de press de botão
  static const Duration animationPress = Duration(milliseconds: 100);

  /// Curva de animação padrão
  static const Curve animationCurve = Curves.easeInOut;
}
