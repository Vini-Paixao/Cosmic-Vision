import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/themes/themes.dart';
import '../../core/constants/route_constants.dart';
import '../../domain/entities/favorite_entity.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/cosmic_app_bar.dart';
import '../widgets/cosmic_card.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_shimmer.dart';

/// Tela de Favoritos
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesViewModel>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CosmicAppBar(
        title: 'Favoritos',
        showBackButton: false,
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                onPressed: viewModel.toggleSortOrder,
                icon: Icon(
                  viewModel.sortByDate
                      ? Icons.calendar_today_rounded
                      : Icons.access_time_rounded,
                  color: AppColors.stardust,
                ),
                tooltip: viewModel.sortByDate
                    ? 'Ordenar por data do APOD'
                    : 'Ordenar por data de adição',
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.galaxy,
        ),
        child: Column(
          children: [
            // Barra de busca
            _buildSearchBar(),
            
            // Lista de favoritos
            Expanded(
              child: Consumer<FavoritesViewModel>(
                builder: (context, viewModel, _) {
                  return _buildContent(context, viewModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.nebulaPurple.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<FavoritesViewModel>().setSearchQuery(value);
        },
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar favoritos...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<FavoritesViewModel>().clearSearch();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textMuted,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.md,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoritesViewModel viewModel) {
    if (viewModel.isLoading) {
      return const ApodListShimmer();
    }

    if (viewModel.isError) {
      return ErrorView(
        message: viewModel.errorMessage ?? 'Erro ao carregar favoritos',
        onRetry: viewModel.loadFavorites,
      );
    }

    if (viewModel.isEmpty) {
      return const EmptyView(
        icon: Icons.favorite_border_rounded,
        title: 'Nenhum favorito ainda',
        message: 'Adicione APODs aos favoritos para vê-los aqui',
      );
    }

    final favorites = viewModel.favorites;

    if (favorites.isEmpty && viewModel.searchQuery.isNotEmpty) {
      return EmptyView(
        icon: Icons.search_off_rounded,
        title: 'Nenhum resultado',
        message: 'Nenhum favorito encontrado para "${viewModel.searchQuery}"',
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: AppColors.nebulaPurple,
      backgroundColor: AppColors.surfaceDark,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppDimensions.xl),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return Dismissible(
            key: Key('favorite_${favorite.id}'),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _removeFavorite(context, favorite),
            background: _buildDismissBackground(),
            child: CosmicCard(
              apod: favorite.apod,
              isFavorite: true,
              onTap: () => _navigateToDetail(context, favorite),
              onFavoriteTap: () => _removeFavorite(context, favorite),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppDimensions.lg),
      child: const Icon(
        Icons.delete_rounded,
        color: AppColors.errorRed,
        size: 28,
      ),
    );
  }

  void _removeFavorite(BuildContext context, FavoriteEntity favorite) async {
    final viewModel = context.read<FavoritesViewModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final removed = await viewModel.removeFavorite(favorite);

    if (mounted && removed) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Removido dos favoritos',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.surfaceDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: AppColors.nebulaPurple,
            onPressed: () {
              // TODO: Implementar desfazer
            },
          ),
        ),
      );
    }
  }

  void _navigateToDetail(BuildContext context, FavoriteEntity favorite) {
    Navigator.of(context).pushNamed(
      RouteConstants.detail,
      arguments: favorite.apod,
    );
  }
}
