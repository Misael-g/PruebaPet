// lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Error de caché']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Error de conexión']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Error de autenticación']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Error de validación']) : super(message);
}

// Extensión para convertir excepciones de Supabase en Failures
extension SupabaseExceptionHandler on Exception {
  Failure toFailure() {
    final errorMessage = toString();
    
    if (errorMessage.contains('Email not confirmed')) {
      return const AuthFailure('Por favor, confirma tu email antes de iniciar sesión');
    }
    
    if (errorMessage.contains('Invalid login credentials')) {
      return const AuthFailure('Email o contraseña incorrectos');
    }
    
    if (errorMessage.contains('User already registered')) {
      return const AuthFailure('Este email ya está registrado');
    }
    
    if (errorMessage.contains('network')) {
      return const NetworkFailure('Error de conexión. Verifica tu internet');
    }
    
    if (errorMessage.contains('timeout')) {
      return const NetworkFailure('La solicitud tardó demasiado');
    }
    
    return ServerFailure(errorMessage);
  }
}