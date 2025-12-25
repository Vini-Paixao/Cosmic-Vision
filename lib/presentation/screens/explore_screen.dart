import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/themes/themes.dart';
import '../../core/constants/route_constants.dart';
import '../../core/extensions/date_extensions.dart';
import '../../domain/entities/apod_entity.dart';
import '../viewmodels/explore_viewmodel.dart';
import '../widgets/cosmic_app_bar.dart';
import '../widgets/cosmic_card.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_shimmer.dart';

/// Tela Explore - Navegação por data e APODs aleatórios
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreViewModel>().loadRandomApods();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ExploreViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CosmicAppBar(
        title: 'Explorar',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => _showDatePicker(context),
            icon: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.stardust,
            ),
          ),
          IconButton(
            onPressed: () => context.read<ExploreViewModel>().loadRandomApods(),
            icon: const Icon(
              Icons.shuffle_rounded,
              color: AppColors.stardust,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.galaxy,
        ),
        child: Consumer<ExploreViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                // Chip de data selecionada
                if (viewModel.selectedDate != null)
                  _buildSelectedDateChip(viewModel),

                // Lista de APODs
                Expanded(
                  child: _buildApodList(context, viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedDateChip(ExploreViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.nebulaPurple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.nebulaPurple.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: AppColors.stardust,
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            viewModel.selectedDate!.toDisplayFormat(),
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.stardust,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          GestureDetector(
            onTap: () {
              viewModel.clearDateSelection();
              viewModel.loadRandomApods();
            },
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApodList(BuildContext context, ExploreViewModel viewModel) {
    if (viewModel.isLoading && viewModel.apods.isEmpty) {
      return const ApodListShimmer();
    }

    if (viewModel.isError && viewModel.apods.isEmpty) {
      return ErrorView(
        message: viewModel.errorMessage ?? 'Erro ao carregar',
        onRetry: viewModel.loadRandomApods,
      );
    }

    if (viewModel.apods.isEmpty) {
      return const EmptyView(
        icon: Icons.explore_off_rounded,
        title: 'Nenhum APOD encontrado',
        message: 'Tente uma data diferente ou recarregue',
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: AppColors.nebulaPurple,
      backgroundColor: AppColors.surfaceDark,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: AppDimensions.xl),
        itemCount: viewModel.apods.length + (viewModel.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.apods.length) {
            return _buildLoadingIndicator();
          }

          final apod = viewModel.apods[index];
          return CosmicCard(
            apod: apod,
            isFavorite: viewModel.isFavorite(apod.date),
            onTap: () => _navigateToDetail(context, apod),
            onFavoriteTap: () => viewModel.toggleFavorite(apod),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(AppDimensions.lg),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.nebulaPurple,
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final viewModel = context.read<ExploreViewModel>();
    final now = DateTime.now();
    final firstDate = DateTime(1995, 6, 16); // Primeiro APOD

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.nebulaPurple,
              onPrimary: AppColors.white,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogTheme(
              backgroundColor: AppColors.deepSpace,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      viewModel.loadApodByDate(selectedDate);
    }
  }

  void _navigateToDetail(BuildContext context, ApodEntity apod) {
    Navigator.of(context).pushNamed(
      RouteConstants.detail,
      arguments: apod,
    );
  }
}
