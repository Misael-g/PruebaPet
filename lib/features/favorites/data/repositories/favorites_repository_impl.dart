// lib/features/favorites/data/repositories/favorites_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<String>>> getFavoritePetIds() async {
    try {
      final ids = await remoteDataSource.getFavoritePetIdsForCurrentUser();
      return Right(ids);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String petId) async {
    try {
      final res = await remoteDataSource.isFavorite(petId);
      return Right(res);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(String petId) async {
    try {
      await remoteDataSource.addFavorite(petId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String petId) async {
    try {
      await remoteDataSource.removeFavorite(petId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}