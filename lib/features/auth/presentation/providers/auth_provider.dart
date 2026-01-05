// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final AuthRepository authRepository;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.resetPasswordUseCase,
    required this.authRepository,
  }) {
    _checkAuthStatus();
    _listenToAuthChanges();
  }

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  // Verificar estado inicial de autenticación
  Future<void> _checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final result = await authRepository.getCurrentUser();
    
    result.fold(
      (failure) {
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
        _errorMessage = failure.message;
      },
      (user) {
        if (user != null) {
          _status = AuthStatus.authenticated;
          _currentUser = user;
        } else {
          _status = AuthStatus.unauthenticated;
          _currentUser = null;
        }
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  // Escuchar cambios en el estado de autenticación
  void _listenToAuthChanges() {
    authRepository.authStateChanges.listen((user) {
      if (user != null) {
        _status = AuthStatus.authenticated;
        _currentUser = user;
      } else {
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
      }
      _errorMessage = null;
      notifyListeners();
    });
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _status = AuthStatus.authenticated;
        _currentUser = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String nombre,
    String? apellido,
    required String tipoUsuario,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await registerUseCase(
      email: email,
      password: password,
      nombre: nombre,
      apellido: apellido,
      tipoUsuario: tipoUsuario,
    );

    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _status = AuthStatus.authenticated;
        _currentUser = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  // Reset Password
  Future<bool> resetPassword({required String email}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await resetPasswordUseCase(email: email);

    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _status = AuthStatus.unauthenticated;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  // Logout
  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await authRepository.logout();

    _status = AuthStatus.unauthenticated;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}