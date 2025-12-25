import 'apod_entity.dart';

/// Entidade de Favorito
///
/// Representa um APOD marcado como favorito pelo usuário,
/// com informações adicionais de quando foi favoritado.
class FavoriteEntity {
  const FavoriteEntity({
    required this.apod,
    required this.favoritedAt,
    this.id,
  });

  /// ID do favorito no banco de dados
  final int? id;

  /// Dados do APOD favoritado
  final ApodEntity apod;

  /// Data/hora em que foi adicionado aos favoritos
  final DateTime favoritedAt;

  /// Cria uma cópia com os valores alterados
  FavoriteEntity copyWith({
    int? id,
    ApodEntity? apod,
    DateTime? favoritedAt,
  }) {
    return FavoriteEntity(
      id: id ?? this.id,
      apod: apod ?? this.apod,
      favoritedAt: favoritedAt ?? this.favoritedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteEntity &&
          runtimeType == other.runtimeType &&
          apod.date == other.apod.date;

  @override
  int get hashCode => apod.date.hashCode;

  @override
  String toString() {
    return 'FavoriteEntity(id: $id, apod: ${apod.title}, favoritedAt: $favoritedAt)';
  }
}
