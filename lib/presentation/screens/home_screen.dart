import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/themes/themes.dart';
import '../../core/constants/route_constants.dart';
import '../../domain/entities/apod_entity.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_shimmer.dart';

/// Tela Home - APOD do dia
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega o APOD do dia ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadTodayApod();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.galaxy,
        ),
        child: SafeArea(
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading && viewModel.todayApod == null) {
                return const FeaturedImageShimmer();
              }

              if (viewModel.isError && viewModel.todayApod == null) {
                return ErrorView(
                  message: viewModel.errorMessage ?? 'Erro ao carregar',
                  onRetry: viewModel.loadTodayApod,
                );
              }

              final apod = viewModel.todayApod;
              if (apod == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.nebulaPurple,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: viewModel.refresh,
                color: AppColors.nebulaPurple,
                backgroundColor: AppColors.surfaceDark,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      _buildFeaturedImage(context, apod, viewModel),
                      _buildApodInfo(context, apod, viewModel),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Row(
        children: [
          // Logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppShadows.glowStardust,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/icon/icon.png',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          
          // Título
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cosmic Vision',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Imagem astronômica do dia',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedImage(
    BuildContext context,
    ApodEntity apod,
    HomeViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, apod),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          boxShadow: AppShadows.glowNebula,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagem
              Hero(
                tag: 'apod_${apod.date}',
                child: CachedNetworkImage(
                  imageUrl: apod.displayUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surfaceDark,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.nebulaPurple,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surfaceDark,
                    child: const Icon(
                      Icons.broken_image_rounded,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),

              // Overlay de vídeo
              if (apod.isVideo)
                Container(
                  color: AppColors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_filled_rounded,
                      size: 80,
                      color: AppColors.white,
                    ),
                  ),
                ),

              // Gradiente inferior
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),

              // Data badge
              Positioned(
                top: AppDimensions.md,
                left: AppDimensions.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Text(
                    'HOJE',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.stardust,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              // Botão favorito
              Positioned(
                top: AppDimensions.md,
                right: AppDimensions.md,
                child: GestureDetector(
                  onTap: viewModel.toggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.sm),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      viewModel.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 24,
                      color: viewModel.isFavorite
                          ? AppColors.accentOrange
                          : AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApodInfo(
    BuildContext context,
    ApodEntity apod,
    HomeViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            apod.title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // Data e copyright
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: AppColors.stardust,
              ),
              const SizedBox(width: AppDimensions.xs),
              Text(
                apod.formattedDate,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.stardust,
                ),
              ),
              if (apod.hasCopyright) ...[
                const SizedBox(width: AppDimensions.md),
                Icon(
                  Icons.camera_alt_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: AppDimensions.xs),
                Expanded(
                  child: Text(
                    apod.copyright!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // Descrição resumida
          Text(
            apod.explanation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.md),

          // Botão ver mais
          GestureDetector(
            onTap: () => _navigateToDetail(context, apod),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ver detalhes',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.nebulaPurple,
                  ),
                ),
                const SizedBox(width: AppDimensions.xs),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.nebulaPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ApodEntity apod) {
    Navigator.of(context).pushNamed(
      RouteConstants.detail,
      arguments: apod,
    );
  }
}
