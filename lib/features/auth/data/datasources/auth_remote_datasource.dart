// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String nombre,
    String? apellido,
    required String tipoUsuario,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<void> resetPassword({required String email});

  Future<void> updatePassword({required String newPassword});

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({SupabaseClient? supabaseClient})
      : supabaseClient = supabaseClient ?? SupabaseConfig.client;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Error al iniciar sesión');
      }

      // Obtener perfil del usuario
      final profileData = await supabaseClient
          .from(SupabaseConfig.profilesTable)
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      return UserModel.fromJson(profileData);
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String nombre,
    String? apellido,
    required String tipoUsuario,
  }) async {
    try {
      // Registrar usuario en auth
      final authResponse = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'nombre': nombre,
          'apellido': apellido,
          'tipo_usuario': tipoUsuario,
        },
      );

      if (authResponse.user == null) {
        throw Exception('Error al registrar usuario');
      }

      // El trigger de la base de datos creará automáticamente el perfil
      // Esperamos un momento para que se cree
      await Future.delayed(const Duration(seconds: 1));

      // Obtener el perfil creado
      final profileData = await supabaseClient
          .from(SupabaseConfig.profilesTable)
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      return UserModel.fromJson(profileData);
    } catch (e) {
      throw Exception('Error en registro: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      
      if (user == null) {
        return null;
      }

      final profileData = await supabaseClient
          .from(SupabaseConfig.profilesTable)
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(profileData);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: '${SupabaseConfig.redirectUrl}/reset-password',
      );
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: $e');
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Error al actualizar contraseña: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange.asyncMap((authState) async {
      final user = authState.session?.user;
      
      if (user == null) {
        return null;
      }

      try {
        final profileData = await supabaseClient
            .from(SupabaseConfig.profilesTable)
            .select()
            .eq('id', user.id)
            .single();

        return UserModel.fromJson(profileData);
      } catch (e) {
        return null;
      }
    });
  }
}