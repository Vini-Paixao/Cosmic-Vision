import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/themes/themes.dart';

/// Imagem com cache e placeholder shimmer
class CachedImage extends StatelessWidget {
  const CachedImage({
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) =>
          placeholder ?? _buildShimmerPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(),
      fadeInDuration: AppDimensions.animFast,
      fadeOutDuration: AppDimensions.animFast,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceDark,
      highlightColor: AppColors.surfaceLight,
      child: Container(
        width: width,
        height: height,
        color: AppColors.surfaceDark,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceDark,
      child: const Center(
        child: Icon(
          Icons.broken_image_rounded,
          size: 48,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

/// Imagem hero com zoom (para visualização full screen)
class HeroImage extends StatelessWidget {
  const HeroImage({
    required this.imageUrl,
    required this.tag,
    this.onTap,
    this.fit = BoxFit.cover,
    this.borderRadius,
    super.key,
  });

  final String imageUrl;
  final String tag;
  final VoidCallback? onTap;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: onTap,
        child: CachedImage(
          imageUrl: imageUrl,
          fit: fit,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
