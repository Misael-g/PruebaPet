// lib/features/user/data/repositories/user_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSourceImpl? remoteDataSource;

  UserRepositoryImpl({this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserProfile() async {
    final now = DateTime.now();
    final user = UserEntity(
      id: 'demo',
      email: 'demo@example.com',
      nombre: 'Demo',
      apellido: 'User',
      tipoUsuario: 'adoptante',
      telefono: null,
      direccion: null,
      ciudad: null,
      provincia: null,
      avatarUrl: null,
      verificado: false,
      createdAt: now,
      updatedAt: now,
    );
    return Right(user);
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? nombre,
    String? apellido,
    String? telefono,
    String? direccion,
    String? ciudad,
    String? provincia,
  }) async {
    final now = DateTime.now();
    final user = UserEntity(
      id: 'demo',
      email: 'demo@example.com',
      nombre: nombre ?? 'Demo',
      apellido: apellido ?? 'User',
      tipoUsuario: 'adoptante',
      telefono: telefono,
      direccion: direccion,
      ciudad: ciudad,
      provincia: provincia,
      avatarUrl: null,
      verificado: false,
      createdAt: now,
      updatedAt: now,
    );
    return Right(user);
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(XFile image) async {
    // Return a fake url for now
    return Right('https://example.com/avatar.png');
  }

  @override
  Future<Either<Failure, UserEntity>> updateAvatar(String avatarUrl) async {
    final now = DateTime.now();
    final user = UserEntity(
      id: 'demo',
      email: 'demo@example.com',
      nombre: 'Demo',
      apellido: 'User',
      tipoUsuario: 'adoptante',
      telefono: null,
      direccion: null,
      ciudad: null,
      provincia: null,
      avatarUrl: avatarUrl,
      verificado: false,
      createdAt: now,
      updatedAt: now,
    );
    return Right(user);
  }

  @override
  Future<Either<Failure, void>> deleteAvatar() async {
    return Right(null);
  }
}
