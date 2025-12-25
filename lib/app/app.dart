import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/route_constants.dart';
import '../di/dependency_injection.dart';
import '../domain/entities/apod_entity.dart';
import '../presentation/screens/screens.dart';
import '../presentation/viewmodels/viewmodels.dart';
import 'themes/themes.dart';

/// Widget principal da aplicação
class CosmicVisionApp extends StatelessWidget {
  const CosmicVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModels
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(
            apodRepository: di.apodRepository,
            favoritesRepository: di.favoritesRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ExploreViewModel(
            apodRepository: di.apodRepository,
            favoritesRepository: di.favoritesRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(
            favoritesRepository: di.favoritesRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(
            settingsRepository: di.settingsRepository,
          ),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, _) {
          return MaterialApp(
            title: 'Cosmic Vision',
            debugShowCheckedModeBanner: false,
            
            // Tema
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _getThemeMode(settingsViewModel.themeMode),
            
            // Rotas
            initialRoute: RouteConstants.splash,
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(AppThemeMode appThemeMode) {
    return switch (appThemeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        return _buildPageRoute(
          const SplashScreen(),
          settings,
        );

      case RouteConstants.main:
        return _buildPageRoute(
          const MainScreen(),
          settings,
        );

      case RouteConstants.home:
        return _buildPageRoute(
          const HomeScreen(),
          settings,
        );

      case RouteConstants.explore:
        return _buildPageRoute(
          const ExploreScreen(),
          settings,
        );

      case RouteConstants.favorites:
        return _buildPageRoute(
          const FavoritesScreen(),
          settings,
        );

      case RouteConstants.settings:
        return _buildPageRoute(
          const SettingsScreen(),
          settings,
        );

      case RouteConstants.detail:
        final apod = settings.arguments as ApodEntity;
        return _buildPageRoute(
          ChangeNotifierProvider(
            create: (_) => DetailViewModel(
              favoritesRepository: di.favoritesRepository,
            ),
            child: DetailScreen(apod: apod),
          ),
          settings,
        );

      default:
        return _buildPageRoute(
          const MainScreen(),
          settings,
        );
    }
  }

  PageRoute<T> _buildPageRoute<T>(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<T>(
      builder: (_) => page,
      settings: settings,
    );
  }
}
