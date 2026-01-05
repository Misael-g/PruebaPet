// lib/core/config/supabase_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get redirectUrl => dotenv.env['REDIRECT_URL'] ?? '';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(
        retryAttempts: 3,
      ),
    );
  }

  // Cliente de Supabase
  static SupabaseClient get client => Supabase.instance.client;
  
  // Auth
  static GoTrueClient get auth => client.auth;
  
  // Database
  static PostgrestClient get db => client;
  
  // Storage
  static SupabaseStorageClient get storage => client.storage;
  
  // Realtime
  static RealtimeClient get realtime => client.realtime;
  
  // Nombres de tablas
  static const String profilesTable = 'profiles';
  static const String refugiosTable = 'refugios';
  static const String mascotasTable = 'mascotas';
  static const String solicitudesTable = 'solicitudes_adopcion';
  static const String favoritosTable = 'favoritos';
  static const String chatConversacionesTable = 'chat_conversaciones';
  static const String chatMensajesTable = 'chat_mensajes';
  
  // Buckets de Storage
  static const String mascotasFotosBucket = 'mascotas-fotos';
  static const String avataresUsuariosBucket = 'avatares-usuarios';
}