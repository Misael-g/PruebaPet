// lib/features/favorites/data/datasources/favorites_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<String>> getFavoritePetIdsForCurrentUser();
  Future<bool> isFavorite(String petId);
  Future<void> addFavorite(String petId);
  Future<void> removeFavorite(String petId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final SupabaseClient supabaseClient;

  FavoritesRemoteDataSourceImpl({SupabaseClient? supabaseClient})
      : supabaseClient = supabaseClient ?? SupabaseConfig.client;

  @override
  Future<List<String>> getFavoritePetIdsForCurrentUser() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabaseClient
        .from('favoritos')
        .select('mascota_id')
        .eq('user_id', userId);

    return (response as List).map((e) => e['mascota_id'] as String).toList();
  }

  @override
  Future<bool> isFavorite(String petId) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;

    final res = await supabaseClient
        .from('favoritos')
        .select('id')
        .eq('user_id', userId)
        .eq('mascota_id', petId)
        .limit(1)
        .single();

    return res != null;
  }

  @override
  Future<void> addFavorite(String petId) async {
    await supabaseClient.from('favoritos').insert({'mascota_id': petId});
  }

  @override
  Future<void> removeFavorite(String petId) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    await supabaseClient
        .from('favoritos')
        .delete()
        .eq('user_id', userId)
        .eq('mascota_id', petId);
  }
}