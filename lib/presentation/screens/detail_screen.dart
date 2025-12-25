import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../app/themes/themes.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/apod_entity.dart';
import '../../services/image_service.dart';
import '../viewmodels/detail_viewmodel.dart';

/// Tela de detalhes do APOD
class DetailScreen extends StatefulWidget {
  const DetailScreen({
    required this.apod,
    super.key,
  });

  final ApodEntity apod;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  YoutubePlayerController? _youtubeController;
  bool _isDownloading = false;
  bool _isSharing = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().initialize(widget.apod);
    });
  }

  void _initializeVideo() {
    if (widget.apod.isVideo) {
      final videoId = widget.apod.youtubeVideoId;
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            controlsVisibleAtStart: true,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.galaxy,
            ),
            child: Consumer<DetailViewModel>(
              builder: (context, viewModel, _) {
                return CustomScrollView(
                  slivers: [
                    // AppBar transparente sobre a imagem
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.5,
                      pinned: true,
                      backgroundColor: AppColors.deepSpace,
                      leading: _buildBackButton(context),
                      actions: [
                        _buildFavoriteButton(viewModel),
                        _buildShareButton(),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildMediaContent(),
                      ),
                    ),

                    // Conteúdo
                    SliverToBoxAdapter(
                      child: _buildContent(viewModel),
                    ),
                  ],
                );
              },
            ),
          ),
          // Overlay de loading para compartilhamento
          if (_isSharing)
            _buildLoadingOverlay('Preparando compartilhamento...'),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay(String message) {
    return Container(
      color: AppColors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.xl),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppShadows.glowNebula,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.nebulaPurple,
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.sm),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(DetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.sm),
      child: GestureDetector(
        onTap: viewModel.toggleFavorite,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            viewModel.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 22,
            color: viewModel.isFavorite
                ? AppColors.accentOrange
                : AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.sm),
      child: GestureDetector(
        onTap: _isSharing ? null : _shareApod,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.share_rounded,
            size: 22,
            color: _isSharing ? AppColors.textMuted : AppColors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _shareApod() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final box = context.findRenderObject() as RenderBox?;
      final sharePosition = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null;

      final result = await imageService.shareApod(
        widget.apod,
        sharePositionOrigin: sharePosition,
      );

      if (!mounted) return;

      if (result is ImageServiceError) {
        _showSnackBar(result.message, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    final result = await imageService.downloadImage(
      widget.apod,
      useHd: true,
      onProgress: (received, total) {
        if (total != -1) {
          setState(() {
            _downloadProgress = received / total;
          });
        }
      },
    );

    if (!mounted) return;

    setState(() {
      _isDownloading = false;
      _downloadProgress = 0.0;
    });

    switch (result) {
      case ImageServiceSuccess():
        _showSnackBar(result.message, isError: false);
        break;
      case ImageServiceError():
        _showSnackBar(result.message, isError: true);
        break;
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
          ),
        ),
        backgroundColor: isError ? AppColors.errorRed : AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        margin: const EdgeInsets.all(AppDimensions.md),
      ),
    );
  }

  Widget _buildMediaContent() {
    if (widget.apod.isVideo && _youtubeController != null) {
      return _buildVideoPlayer();
    }
    return _buildImage();
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: () => _openFullScreen(context),
      child: Hero(
        tag: 'apod_${widget.apod.date}',
        child: CachedNetworkImage(
          imageUrl: widget.apod.displayUrl,
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
    );
  }

  Widget _buildVideoPlayer() {
    return YoutubePlayer(
      controller: _youtubeController!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppColors.nebulaPurple,
      progressColors: const ProgressBarColors(
        playedColor: AppColors.nebulaPurple,
        handleColor: AppColors.stardust,
      ),
    );
  }

  Widget _buildContent(DetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            widget.apod.title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Metadata
          _buildMetadata(),
          const SizedBox(height: AppDimensions.lg),

          // Descrição
          _buildDescription(viewModel),
          const SizedBox(height: AppDimensions.xl),

          // Ações
          _buildActions(),
          const SizedBox(height: AppDimensions.xxl),
        ],
      ),
    );
  }

  Widget _buildMetadata() {
    return Wrap(
      spacing: AppDimensions.md,
      runSpacing: AppDimensions.sm,
      children: [
        // Data
        _buildMetadataChip(
          icon: Icons.calendar_today_rounded,
          label: widget.apod.formattedDate,
          color: AppColors.stardust,
        ),
        
        // Tipo de mídia
        _buildMetadataChip(
          icon: widget.apod.mediaType == MediaType.video
              ? Icons.videocam_rounded
              : Icons.image_rounded,
          label: widget.apod.mediaType == MediaType.video
              ? 'Vídeo'
              : 'Imagem',
          color: AppColors.accentTeal,
        ),
        
        // Copyright
        if (widget.apod.hasCopyright)
          _buildMetadataChip(
            icon: Icons.camera_alt_rounded,
            label: widget.apod.copyright!,
            color: AppColors.textMuted,
          ),
      ],
    );
  }

  Widget _buildMetadataChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppDimensions.xs),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(DetailViewModel viewModel) {
    final isExpanded = viewModel.isDescriptionExpanded;
    final explanation = widget.apod.explanation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        AnimatedCrossFade(
          firstChild: Text(
            explanation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            explanation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: AppDimensions.animNormal,
        ),
        if (explanation.length > 300)
          GestureDetector(
            onTap: viewModel.toggleDescriptionExpanded,
            child: Padding(
              padding: const EdgeInsets.only(top: AppDimensions.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isExpanded ? 'Ver menos' : 'Ver mais',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.nebulaPurple,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.nebulaPurple,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        // Baixar imagem
        if (!widget.apod.isVideo)
          Expanded(
            child: _buildActionButton(
              icon: _isDownloading 
                  ? Icons.downloading_rounded 
                  : Icons.download_rounded,
              label: _isDownloading 
                  ? '${(_downloadProgress * 100).toInt()}%' 
                  : 'Baixar',
              onTap: _downloadImage,
              isLoading: _isDownloading,
            ),
          ),
        if (!widget.apod.isVideo) const SizedBox(width: AppDimensions.md),
        
        // Compartilhar
        Expanded(
          child: _buildActionButton(
            icon: _isSharing 
                ? Icons.hourglass_top_rounded 
                : Icons.share_rounded,
            label: _isSharing ? 'Preparando...' : 'Compartilhar',
            onTap: _shareApod,
            isLoading: _isSharing,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: AppColors.nebulaPurple.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: _downloadProgress > 0 ? _downloadProgress : null,
                  strokeWidth: 2,
                  color: AppColors.stardust,
                ),
              )
            else
              Icon(icon, size: 20, color: AppColors.stardust),
            const SizedBox(width: AppDimensions.sm),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenImage(
          imageUrl: widget.apod.hdUrl ?? widget.apod.url,
          heroTag: 'apod_${widget.apod.date}',
        ),
      ),
    );
  }
}

/// Visualização em tela cheia com zoom
class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({
    required this.imageUrl,
    required this.heroTag,
  });

  final String imageUrl;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.white,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Hero(
        tag: heroTag,
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          backgroundDecoration: const BoxDecoration(color: AppColors.black),
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(color: AppColors.nebulaPurple),
          ),
        ),
      ),
    );
  }
}
