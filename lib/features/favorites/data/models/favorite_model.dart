// lib/features/favorites/data/models/favorite_model.dart

import '../../domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  FavoriteModel({
    required String id,
    required String userId,
    required String mascotaId,
    required DateTime createdAt,
  }) : super(id: id, userId: userId, mascotaId: mascotaId, createdAt: createdAt);

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mascotaId: json['mascota_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'mascota_id': mascotaId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}