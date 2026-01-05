// lib/features/pets/data/datasources/pets_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../models/pet_model.dart';

abstract class PetsRemoteDataSource {
  Future<List<PetModel>> getAllPets({int limit = 20, int offset = 0});
  
  Future<List<PetModel>> getPetsByFilters({
    String? especie,
    String? tamanio,
    String? ciudad,
    String? sexo,
    int limit = 20,
    int offset = 0,
  });
  
  Future<PetModel> getPetById(String id);
  
  Future<void> incrementVisits(String petId);
  
  Future<List<PetModel>> searchPets(String query);
}

class PetsRemoteDataSourceImpl implements PetsRemoteDataSource {
  final SupabaseClient supabaseClient;

  PetsRemoteDataSourceImpl({SupabaseClient? supabaseClient})
      : supabaseClient = supabaseClient ?? SupabaseConfig.client;

  @override
  Future<List<PetModel>> getAllPets({int limit = 20, int offset = 0}) async {
    try {
      final response = await supabaseClient
          .from(SupabaseConfig.mascotasTable)
          .select('''
            *,
            refugios:refugio_id (
              id,
              nombre_refugio,
              ciudad,
              provincia
            )
          ''')
          .eq('estado', 'disponible')
          .order('fecha_publicacion', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => PetModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar mascotas: $e');
    }
  }

  @override
  Future<List<PetModel>> getPetsByFilters({
    String? especie,
    String? tamanio,
    String? ciudad,
    String? sexo,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = supabaseClient
          .from(SupabaseConfig.mascotasTable)
          .select('''
            *,
            refugios:refugio_id (
              id,
              nombre_refugio,
              ciudad,
              provincia
            )
          ''')
          .eq('estado', 'disponible');

      // Aplicar filtros
      if (especie != null && especie.isNotEmpty) {
        query = query.eq('especie', especie);
      }

      if (tamanio != null && tamanio.isNotEmpty) {
        query = query.eq('tamaño', tamanio);
      }

      if (sexo != null && sexo.isNotEmpty) {
        query = query.eq('sexo', sexo);
      }

      // Filtrar por ciudad del refugio
      if (ciudad != null && ciudad.isNotEmpty) {
        query = query.eq('refugios.ciudad', ciudad);
      }

      final response = await query
          .order('fecha_publicacion', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => PetModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al filtrar mascotas: $e');
    }
  }

  @override
  Future<PetModel> getPetById(String id) async {
    try {
      final response = await supabaseClient
          .from(SupabaseConfig.mascotasTable)
          .select('''
            *,
            refugios:refugio_id (
              id,
              nombre_refugio,
              ciudad,
              provincia,
              telefono_contacto,
              email_contacto
            )
          ''')
          .eq('id', id)
          .single();

      return PetModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al cargar mascota: $e');
    }
  }

  @override
  Future<void> incrementVisits(String petId) async {
    try {
      // Primero obtener el valor actual
      final current = await supabaseClient
          .from(SupabaseConfig.mascotasTable)
          .select('visitas')
          .eq('id', petId)
          .single();

      final currentVisits = current['visitas'] as int? ?? 0;

      // Incrementar
      await supabaseClient
          .from(SupabaseConfig.mascotasTable)
          .update({'visitas': currentVisits + 1})
          .eq('id', petId);
    } catch (e) {
      // No lanzar error, es una operación secundaria
      print('Error al incrementar visitas: $e');
    }
  }

  @override
  Future<List<PetModel>> searchPets(String query) async {
    try {
      final response = await supabaseClient
          .from(SupabaseConfig.mascotasTable)
          .select('''
            *,
            refugios:refugio_id (
              id,
              nombre_refugio,
              ciudad,
              provincia
            )
          ''')
          .eq('estado', 'disponible')
          .or('nombre.ilike.%$query%,raza.ilike.%$query%')
          .order('fecha_publicacion', ascending: false)
          .limit(20);

      return (response as List)
          .map((json) => PetModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar mascotas: $e');
    }
  }
}