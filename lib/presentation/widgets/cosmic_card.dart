import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/themes/themes.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/apod_entity.dart';

/// Card para exibição de APOD na listagem
///
/// Exibe thumbnail, título, data e indicador de favorito.
class CosmicCard extends StatelessWidget {
  const CosmicCard({
    required this.apod,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    super.key,
  });

  final ApodEntity apod;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: AppDimensions.marginCard,
        decoration: BoxDecoration(
          gradient: AppGradients.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: AppShadows.elevation1,
          border: Border.all(
            color: AppColors.stardust.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagem/Thumbnail
              _buildMediaSection(context),

              // Informações
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e favorito
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            apod.title,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingSM),
                        _buildFavoriteButton(context),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingXS),

                    // Data
                    Text(
                      apod.formattedDate,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    final imageUrl = apod.thumbnail;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem com cache
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildShimmer(context),
            errorWidget: (context, url, error) => _buildErrorWidget(context),
          ),

          // Overlay de vídeo
          if (apod.mediaType == MediaType.video)
            Container(
              color: AppColors.surfaceDark.withValues(alpha: 0.3),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  size: 64,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceDark,
      highlightColor: AppColors.stardust,
      child: Container(
        color: AppColors.surfaceDark,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      color: AppColors.surfaceLight,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return GestureDetector(
      onTap: onFavoriteTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXS),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 24,
          color: isFavorite ? AppColors.errorRed : AppColors.white,
        ),
      ),
    );
  }
}
