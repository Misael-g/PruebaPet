// lib/features/user/domain/repositories/user_repository.dart

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getCurrentUserProfile();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? nombre,
    String? apellido,
    String? telefono,
    String? direccion,
    String? ciudad,
    String? provincia,
  });

  Future<Either<Failure, String>> uploadAvatar(XFile image);

  Future<Either<Failure, UserEntity>> updateAvatar(String avatarUrl);

  Future<Either<Failure, void>> deleteAvatar();
}
