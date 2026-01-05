// lib/features/user/domain/usecases/update_avatar_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateAvatarUseCase {
  final UserRepository repository;

  UpdateAvatarUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String avatarUrl) async {
    return await repository.updateAvatar(avatarUrl);
  }
} 