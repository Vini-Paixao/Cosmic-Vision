import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'di/dependency_injection.dart';

void main() async {
  // Garante que os bindings estão inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa os dados de locale para formatação de datas
  await initializeDateFormatting('pt_BR', null);

  // Configura a orientação da tela (apenas retrato)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configura o estilo da barra de status
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0B0D21), // DeepSpace
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Inicializa as dependências
  await DependencyInjection.instance.initialize();

  // Inicia o app
  runApp(const CosmicVisionApp());
}
