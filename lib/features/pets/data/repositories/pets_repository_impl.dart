// lib/features/pets/data/repositories/pets_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pets_repository.dart';
import '../datasources/pets_remote_datasource.dart';

class PetsRepositoryImpl implements PetsRepository {
  final PetsRemoteDataSource remoteDataSource;

  PetsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PetEntity>>> getAllPets({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final pets = await remoteDataSource.getAllPets(
        limit: limit,
        offset: offset,
      );
      return Right(pets);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<PetEntity>>> getPetsByFilters({
    String? especie,
    String? tamanio,
    String? ciudad,
    String? sexo,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final pets = await remoteDataSource.getPetsByFilters(
        especie: especie,
        tamanio: tamanio,
        ciudad: ciudad,
        sexo: sexo,
        limit: limit,
        offset: offset,
      );
      return Right(pets);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, PetEntity>> getPetById(String id) async {
    try {
      final pet = await remoteDataSource.getPetById(id);
      return Right(pet);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> incrementVisits(String petId) async {
    try {
      await remoteDataSource.incrementVisits(petId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<PetEntity>>> searchPets(String query) async {
    try {
      final pets = await remoteDataSource.searchPets(query);
      return Right(pets);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
