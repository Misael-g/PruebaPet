// lib/core/constants/app_constants.dart

class AppConstants {
  // Configuración de la app
  static const String appName = 'PetAdopt';
  static const String appVersion = '1.0.0';
  
  // Tipos de usuario
  static const String userTypeAdoptante = 'adoptante';
  static const String userTypeRefugio = 'refugio';
  
  // Estados de mascotas
  static const String petStatusDisponible = 'disponible';
  static const String petStatusEnProceso = 'en_proceso';
  static const String petStatusAdoptado = 'adoptado';
  static const String petStatusNoDisponible = 'no_disponible';
  
  // Estados de solicitudes
  static const String requestStatusPendiente = 'pendiente';
  static const String requestStatusEnRevision = 'en_revision';
  static const String requestStatusAprobada = 'aprobada';
  static const String requestStatusRechazada = 'rechazada';
  static const String requestStatusCancelada = 'cancelada';
  
  // Especies
  static const String speciePerro = 'perro';
  static const String specieGato = 'gato';
  static const String specieOtro = 'otro';
  
  // Tamaños
  static const String sizePequeno = 'pequeño';
  static const String sizeMediano = 'mediano';
  static const String sizeGrande = 'grande';
  
  // Sexos
  static const String sexMacho = 'macho';
  static const String sexHembra = 'hembra';
  
  // Validaciones
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Mensajes de error comunes
  static const String errorGeneral = 'Ha ocurrido un error. Por favor, intenta nuevamente.';
  static const String errorNetwork = 'Error de conexión. Verifica tu internet.';
  static const String errorAuth = 'Error de autenticación. Por favor, inicia sesión nuevamente.';
  
  // Expresiones regulares
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp phoneRegex = RegExp(
    r'^[0-9]{10}$',
  );
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
}