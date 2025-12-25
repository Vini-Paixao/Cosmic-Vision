import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/cosmic_bottom_nav.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// Tela principal com navegação por abas
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  final List<CosmicNavItem> _navItems = const [
    CosmicNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Início',
    ),
    CosmicNavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'Explorar',
    ),
    CosmicNavItem(
      icon: Icons.favorite_outline_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Favoritos',
    ),
    CosmicNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Ajustes',
    ),
  ];

  void _onTabTapped(int index) {
    _previousIndex = _currentIndex;
    setState(() => _currentIndex = index);
    
    // Recarrega favoritos quando navegar para a aba de favoritos
    if (index == 2) {
      context.read<FavoritesViewModel>().loadFavorites();
    }
    
    // Atualiza status de favorito na Home quando voltar para ela
    if (index == 0 && _previousIndex != 0) {
      context.read<HomeViewModel>().refreshFavoriteStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CosmicBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _navItems,
      ),
    );
  }
}
