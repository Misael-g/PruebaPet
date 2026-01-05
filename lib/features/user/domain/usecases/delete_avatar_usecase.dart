// lib/features/user/domain/usecases/delete_avatar_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class DeleteAvatarUseCase {
  final UserRepository repository;

  DeleteAvatarUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAvatar();
  }
} 
