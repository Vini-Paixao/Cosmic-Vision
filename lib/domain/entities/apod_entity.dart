import '../../core/constants/app_constants.dart';

/// Entidade APOD (Astronomy Picture of the Day)
///
/// Representa os dados de uma imagem/vídeo astronômico
/// retornada pela API da NASA.
class ApodEntity {
  const ApodEntity({
    required this.date,
    required this.title,
    required this.explanation,
    required this.url,
    required this.mediaType,
    this.hdurl,
    this.copyright,
    this.thumbnailUrl,
  });

  /// Data da imagem no formato YYYY-MM-DD
  final String date;

  /// Título da imagem
  final String title;

  /// Descrição/explicação da imagem
  final String explanation;

  /// URL da imagem em resolução padrão (ou embed de vídeo)
  final String url;

  /// URL da imagem em alta resolução (pode ser null)
  final String? hdurl;

  /// Tipo de mídia: 'image' ou 'video'
  final MediaType mediaType;

  /// Copyright da imagem (pode ser null se for domínio público)
  final String? copyright;

  /// URL da thumbnail para vídeos (pode ser null)
  final String? thumbnailUrl;

  /// Verifica se é uma imagem
  bool get isImage => mediaType == MediaType.image;

  /// Verifica se é um vídeo
  bool get isVideo => mediaType == MediaType.video;

  /// Verifica se tem copyright
  bool get hasCopyright => copyright != null && copyright!.isNotEmpty;

  /// URL HD (alias)
  String? get hdUrl => hdurl;

  /// Retorna o ID do vídeo do YouTube se for um vídeo do YouTube
  String? get youtubeVideoId {
    if (!isVideo || !url.contains('youtube')) return null;
    return _extractYouTubeId(url);
  }

  /// Retorna a data formatada para exibição (DD/MM/YYYY)
  String get formattedDate {
    final dt = dateTime;
    if (dt == null) return date;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  /// Retorna a melhor URL disponível para exibição
  /// Para imagens: hdurl > url
  /// Para vídeos: thumbnailUrl > url padrão
  String get displayUrl {
    if (isVideo) {
      return thumbnailUrl ?? 'https://img.youtube.com/vi/${url.split('/').last}/hqdefault.jpg';
    }
    return hdurl ?? url;
  }

  /// Retorna a URL para thumbnail
  String get thumbnail {
    if (isVideo && url.contains('youtube')) {
      // Extrai ID do vídeo e monta URL da thumbnail
      final videoId = _extractYouTubeId(url);
      return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
    }
    return url;
  }

  /// Extrai o ID do vídeo do YouTube da URL
  String _extractYouTubeId(String url) {
    final regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1) ?? '';
  }

  /// Converte a data string para DateTime
  DateTime? get dateTime {
    try {
      final parts = date.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (_) {
      return null;
    }
  }

  /// Cria uma cópia com os valores alterados
  ApodEntity copyWith({
    String? date,
    String? title,
    String? explanation,
    String? url,
    String? hdurl,
    MediaType? mediaType,
    String? copyright,
    String? thumbnailUrl,
  }) {
    return ApodEntity(
      date: date ?? this.date,
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      url: url ?? this.url,
      hdurl: hdurl ?? this.hdurl,
      mediaType: mediaType ?? this.mediaType,
      copyright: copyright ?? this.copyright,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApodEntity &&
          runtimeType == other.runtimeType &&
          date == other.date;

  @override
  int get hashCode => date.hashCode;

  @override
  String toString() {
    return 'ApodEntity(date: $date, title: $title, mediaType: $mediaType)';
  }
}
