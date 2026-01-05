// lib/features/favorites/domain/repositories/favorites_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<String>>> getFavoritePetIds();
  Future<Either<Failure, bool>> isFavorite(String petId);
  Future<Either<Failure, void>> addFavorite(String petId);
  Future<Either<Failure, void>> removeFavorite(String petId);
}