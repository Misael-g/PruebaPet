// lib/features/user/domain/usecases/update_profile_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateProfileUseCase {
  final UserRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    String? nombre,
    String? apellido,
    String? telefono,
    String? direccion,
    String? ciudad,
    String? provincia,
  }) async {
    return await repository.updateProfile(
      nombre: nombre,
      apellido: apellido,
      telefono: telefono,
      direccion: direccion,
      ciudad: ciudad,
      provincia: provincia,
    );
  }
} 