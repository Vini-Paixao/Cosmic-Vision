import '../../core/constants/app_constants.dart';
import '../../domain/entities/apod_entity.dart';

/// Model APOD para serialização/deserialização
///
/// Converte entre JSON da API e entidade de domínio.
class ApodModel extends ApodEntity {
  const ApodModel({
    required super.date,
    required super.title,
    required super.explanation,
    required super.url,
    required super.mediaType,
    super.hdurl,
    super.copyright,
    super.thumbnailUrl,
  });

  /// Cria um ApodModel a partir de JSON da API
  factory ApodModel.fromJson(Map<String, dynamic> json) {
    return ApodModel(
      date: json['date'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      url: json['url'] as String,
      hdurl: json['hdurl'] as String?,
      mediaType: MediaType.fromString(json['media_type'] as String? ?? 'image'),
      copyright: json['copyright'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  /// Converte para JSON (para cache local)
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'title': title,
      'explanation': explanation,
      'url': url,
      'hdurl': hdurl,
      'media_type': mediaType.value,
      'copyright': copyright,
      'thumbnail_url': thumbnailUrl,
    };
  }

  /// Cria um ApodModel a partir de uma entidade
  factory ApodModel.fromEntity(ApodEntity entity) {
    return ApodModel(
      date: entity.date,
      title: entity.title,
      explanation: entity.explanation,
      url: entity.url,
      hdurl: entity.hdurl,
      mediaType: entity.mediaType,
      copyright: entity.copyright,
      thumbnailUrl: entity.thumbnailUrl,
    );
  }

  /// Converte para entidade de domínio
  ApodEntity toEntity() {
    return ApodEntity(
      date: date,
      title: title,
      explanation: explanation,
      url: url,
      hdurl: hdurl,
      mediaType: mediaType,
      copyright: copyright,
      thumbnailUrl: thumbnailUrl,
    );
  }

  /// Cria um ApodModel a partir de dados do banco SQLite
  factory ApodModel.fromDatabase(Map<String, dynamic> map) {
    return ApodModel(
      date: map['date'] as String,
      title: map['title'] as String,
      explanation: map['explanation'] as String,
      url: map['url'] as String,
      hdurl: map['hdurl'] as String?,
      mediaType: MediaType.fromString(map['media_type'] as String? ?? 'image'),
      copyright: map['copyright'] as String?,
      thumbnailUrl: map['thumbnail_url'] as String?,
    );
  }

  /// Converte para Map do banco SQLite
  Map<String, dynamic> toDatabase() {
    return {
      'date': date,
      'title': title,
      'explanation': explanation,
      'url': url,
      'hdurl': hdurl,
      'media_type': mediaType.value,
      'copyright': copyright,
      'thumbnail_url': thumbnailUrl,
    };
  }
}
