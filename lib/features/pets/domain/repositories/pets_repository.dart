// lib/features/pets/domain/repositories/pets_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pet_entity.dart';

abstract class PetsRepository {
  Future<Either<Failure, List<PetEntity>>> getAllPets({
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<PetEntity>>> getPetsByFilters({
    String? especie,
    String? tamanio,
    String? ciudad,
    String? sexo,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, PetEntity>> getPetById(String id);

  Future<Either<Failure, void>> incrementVisits(String petId);

  Future<Either<Failure, List<PetEntity>>> searchPets(String query);
}

