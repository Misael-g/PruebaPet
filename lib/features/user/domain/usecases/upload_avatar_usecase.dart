// lib/features/user/domain/usecases/upload_avatar_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class UploadAvatarUseCase {
  final UserRepository repository;

  UploadAvatarUseCase(this.repository);

  Future<Either<Failure, String>> call(XFile image) async {
    return await repository.uploadAvatar(image);
  }
} 