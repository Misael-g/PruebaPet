// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Login
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  // Register
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String nombre,
    String? apellido,
    required String tipoUsuario,
  });

  // Logout
  Future<Either<Failure, void>> logout();

  // Get current user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  // Reset password
  Future<Either<Failure, void>> resetPassword({
    required String email,
  });

  // Update password
  Future<Either<Failure, void>> updatePassword({
    required String newPassword,
  });

  // Check if user is logged in
  Future<bool> isLoggedIn();

  // Listen to auth state changes
  Stream<UserEntity?> get authStateChanges;
}