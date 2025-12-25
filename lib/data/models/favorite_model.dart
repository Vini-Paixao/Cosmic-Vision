import '../../domain/entities/favorite_entity.dart';
import 'apod_model.dart';

/// Model de Favorito para persistência
///
/// Converte entre dados do banco SQLite e entidade de domínio.
class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    super.id,
    required super.apod,
    required super.favoritedAt,
  });

  /// Cria um FavoriteModel a partir de dados do banco SQLite
  factory FavoriteModel.fromDatabase(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] as int?,
      apod: ApodModel.fromDatabase({
        'date': map['apod_date'],
        'title': map['title'],
        'explanation': map['explanation'],
        'url': map['url'],
        'hdurl': map['hdurl'],
        'media_type': map['media_type'],
        'copyright': map['copyright'],
        'thumbnail_url': map['thumbnail_url'],
      }),
      favoritedAt: DateTime.parse(map['favorited_at'] as String),
    );
  }

  /// Converte para Map do banco SQLite
  Map<String, dynamic> toDatabase() {
    final apodModel = apod is ApodModel 
        ? apod as ApodModel 
        : ApodModel.fromEntity(apod);
    
    return {
      if (id != null) 'id': id,
      'apod_date': apod.date,
      'title': apod.title,
      'explanation': apod.explanation,
      'url': apod.url,
      'hdurl': apod.hdurl,
      'media_type': apod.mediaType.value,
      'copyright': apod.copyright,
      'thumbnail_url': apodModel.thumbnailUrl,
      'favorited_at': favoritedAt.toIso8601String(),
    };
  }

  /// Cria um FavoriteModel a partir de uma entidade
  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      id: entity.id,
      apod: entity.apod,
      favoritedAt: entity.favoritedAt,
    );
  }

  /// Converte para entidade de domínio
  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      apod: apod,
      favoritedAt: favoritedAt,
    );
  }
}
