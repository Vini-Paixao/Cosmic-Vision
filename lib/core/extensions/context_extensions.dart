import 'package:flutter/material.dart';

/// Extensões para BuildContext
extension ContextExtensions on BuildContext {
  // ═══════════════════════════════════════════════════════════════════════════
  // THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Acesso rápido ao Theme
  ThemeData get theme => Theme.of(this);

  /// Acesso rápido ao ColorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Acesso rápido ao TextTheme
  TextTheme get textTheme => theme.textTheme;

  /// Verifica se o tema é escuro
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ═══════════════════════════════════════════════════════════════════════════
  // MEDIA QUERY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Acesso rápido ao MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Largura da tela
  double get screenWidth => mediaQuery.size.width;

  /// Altura da tela
  double get screenHeight => mediaQuery.size.height;

  /// Padding seguro (notch, barra de navegação, etc.)
  EdgeInsets get safePadding => mediaQuery.padding;

  /// Padding do teclado
  double get keyboardHeight => mediaQuery.viewInsets.bottom;

  /// Verifica se o teclado está visível
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Orientação da tela
  Orientation get orientation => mediaQuery.orientation;

  /// Verifica se é landscape
  bool get isLandscape => orientation == Orientation.landscape;

  /// Verifica se é portrait
  bool get isPortrait => orientation == Orientation.portrait;

  // ═══════════════════════════════════════════════════════════════════════════
  // BREAKPOINTS (Design Responsivo)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Verifica se é mobile (< 600)
  bool get isMobile => screenWidth < 600;

  /// Verifica se é tablet (600 - 900)
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Verifica se é desktop (>= 900)
  bool get isDesktop => screenWidth >= 900;

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Navigator do contexto
  NavigatorState get navigator => Navigator.of(this);

  /// Voltar para tela anterior
  void pop<T>([T? result]) => navigator.pop(result);

  /// Verificar se pode voltar
  bool get canPop => navigator.canPop();

  /// Navegar para rota nomeada
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed<T>(routeName, arguments: arguments);

  /// Substituir rota atual
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushReplacementNamed<T, void>(routeName, arguments: arguments);

  /// Limpar stack e ir para rota
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) =>
      navigator.pushNamedAndRemoveUntil<T>(
        routeName,
        (route) => false,
        arguments: arguments,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // FOCUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Remove o foco do campo atual (esconde teclado)
  void unfocus() => FocusScope.of(this).unfocus();

  // ═══════════════════════════════════════════════════════════════════════════
  // SNACKBAR
  // ═══════════════════════════════════════════════════════════════════════════

  /// Mostra um SnackBar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Mostra um SnackBar de erro
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
      ),
    );
  }

  /// Mostra um SnackBar de sucesso
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
