import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Logger utilitário para debug
///
/// Só exibe logs em modo debug para não impactar produção.
class Logger {
  Logger._();

  static const String _tag = 'CosmicVision';

  /// Log de informação
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 800, // INFO
      );
    }
  }

  /// Log de warning
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '⚠️ $message',
        name: tag ?? _tag,
        level: 900, // WARNING
      );
    }
  }

  /// Log de erro
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        '❌ $message',
        name: tag ?? _tag,
        level: 1000, // ERROR
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log de debug
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '🐛 $message',
        name: tag ?? _tag,
        level: 500, // DEBUG
      );
    }
  }

  /// Log de network
  static void network(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '🌐 $message',
        name: tag ?? '${_tag}_Network',
        level: 800,
      );
    }
  }
}
