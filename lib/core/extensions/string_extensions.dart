/// Extensões para String
extension StringExtensions on String {
  /// Capitaliza a primeira letra
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitaliza cada palavra
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Trunca o texto com reticências
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Remove quebras de linha extras
  String normalizeWhitespace() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Verifica se é uma URL válida
  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  /// Verifica se é uma URL do YouTube
  bool get isYouTubeUrl {
    return contains('youtube.com') || contains('youtu.be');
  }

  /// Extrai o ID do vídeo do YouTube
  String? get youTubeVideoId {
    if (!isYouTubeUrl) return null;

    // Padrão: https://www.youtube.com/embed/VIDEO_ID
    final embedRegex = RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]+)');
    var match = embedRegex.firstMatch(this);
    if (match != null) return match.group(1);

    // Padrão: https://www.youtube.com/watch?v=VIDEO_ID
    final watchRegex = RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)');
    match = watchRegex.firstMatch(this);
    if (match != null) return match.group(1);

    // Padrão: https://youtu.be/VIDEO_ID
    final shortRegex = RegExp(r'youtu\.be/([a-zA-Z0-9_-]+)');
    match = shortRegex.firstMatch(this);
    if (match != null) return match.group(1);

    return null;
  }
}

/// Extensão para String nullable
extension NullableStringExtensions on String? {
  /// Retorna true se a string for null ou vazia
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Retorna true se a string não for null e não for vazia
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Retorna a string ou um valor padrão
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;
}
