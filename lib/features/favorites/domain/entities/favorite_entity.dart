// lib/features/favorites/domain/entities/favorite_entity.dart

class FavoriteEntity {
  final String id;
  final String userId;
  final String mascotaId;
  final DateTime createdAt;

  FavoriteEntity({
    required this.id,
    required this.userId,
    required this.mascotaId,
    required this.createdAt,
  });
}