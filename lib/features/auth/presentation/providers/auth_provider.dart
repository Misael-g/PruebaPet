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

    try {
      final result = await authRepository.getCurrentUser();
      
      result.fold(
        (failure) {
          _status = AuthStatus.unauthenticated;
          _currentUser = null;
          _errorMessage = null; // No mostrar error en inicio
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
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
      _errorMessage = null;
    }

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
      email: email.trim(),
      password: password,
    );

    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = _getFriendlyErrorMessage(failure.message);
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
      email: email.trim(),
      password: password,
      nombre: nombre.trim(),
      apellido: apellido?.trim(),
      tipoUsuario: tipoUsuario,
    );

    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = _getFriendlyErrorMessage(failure.message);
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

    final result = await resetPasswordUseCase(email: email.trim());

    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = _getFriendlyErrorMessage(failure.message);
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

  // Convertir mensajes de error técnicos a mensajes amigables
  String _getFriendlyErrorMessage(String technicalMessage) {
    final lowerMessage = technicalMessage.toLowerCase();
    
    if (lowerMessage.contains('email not confirmed')) {
      return 'Por favor, confirma tu email antes de iniciar sesión';
    }
    
    if (lowerMessage.contains('invalid login credentials') ||
        lowerMessage.contains('invalid email or password')) {
      return 'Email o contraseña incorrectos';
    }
    
    if (lowerMessage.contains('user already registered') ||
        lowerMessage.contains('email already exists')) {
      return 'Este email ya está registrado';
    }
    
    if (lowerMessage.contains('weak password')) {
      return 'La contraseña es demasiado débil';
    }
    
    if (lowerMessage.contains('network') || 
        lowerMessage.contains('connection')) {
      return 'Error de conexión. Verifica tu internet';
    }
    
    if (lowerMessage.contains('timeout')) {
      return 'La solicitud tardó demasiado. Intenta nuevamente';
    }

    if (lowerMessage.contains('rate limit')) {
      return 'Demasiados intentos. Espera un momento';
    }
    
    // Mensaje genérico si no se reconoce el error
    return 'Ocurrió un error. Por favor, intenta nuevamente';
  }
}