import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'di/dependency_injection.dart';

void main() async {
  // Zona de erro para capturar exceções não tratadas
  runZonedGuarded<Future<void>>(() async {
    // Garante que os bindings estão inicializados
    WidgetsFlutterBinding.ensureInitialized();

    // Configura handler de erros do Flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('🔴 [FlutterError] ${details.exception}');
      debugPrint('🔴 [FlutterError] Stack: ${details.stack}');
    };

    // Configura handler de erros da plataforma (erros assíncronos)
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('🔴 [PlatformError] $error');
      debugPrint('🔴 [PlatformError] Stack: $stack');
      return true;
    };

    debugPrint('🚀 [Main] Iniciando Cosmic Vision...');

    try {
      // Inicializa os dados de locale para formatação de datas
      debugPrint('📅 [Main] Inicializando locale pt_BR...');
      await initializeDateFormatting('pt_BR', null);
      debugPrint('✅ [Main] Locale inicializado');

      // Configura a orientação da tela (apenas retrato)
      debugPrint('📱 [Main] Configurando orientação...');
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      debugPrint('✅ [Main] Orientação configurada');

      // Configura o estilo da barra de status
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF0B0D21), // DeepSpace
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
      debugPrint('✅ [Main] UI Overlay configurado');

      // Inicializa as dependências
      debugPrint('🔧 [Main] Inicializando dependências...');
      await DependencyInjection.instance.initialize();
      debugPrint('✅ [Main] Dependências inicializadas');

      debugPrint('🎉 [Main] App pronto para iniciar!');
    } catch (e, stack) {
      debugPrint('❌ [Main] ERRO NA INICIALIZAÇÃO: $e');
      debugPrint('❌ [Main] Stack: $stack');
      // Continua mesmo com erro para mostrar algum feedback
    }

    // Inicia o app
    runApp(const CosmicVisionApp());
  }, (error, stack) {
    debugPrint('🔴 [ZoneError] Erro não capturado: $error');
    debugPrint('🔴 [ZoneError] Stack: $stack');
  });
}
