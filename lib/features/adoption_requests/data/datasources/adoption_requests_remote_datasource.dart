// lib/features/adoption_requests/data/datasources/adoption_requests_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../models/adoption_request_model.dart';

abstract class AdoptionRequestsRemoteDataSource {
  Future<String> createRequest(Map<String, dynamic> payload);
  Future<List<AdoptionRequestModel>> getRequestsForCurrentUser();
  Future<List<AdoptionRequestModel>> getRequestsForRefugio(String refugioId);
  Future<AdoptionRequestModel> getRequestById(String id);
  Future<void> updateRequestStatus(String id, String estado, {String? comentarios});
}

class AdoptionRequestsRemoteDataSourceImpl implements AdoptionRequestsRemoteDataSource {
  final SupabaseClient supabaseClient;

  AdoptionRequestsRemoteDataSourceImpl({SupabaseClient? supabaseClient})
      : supabaseClient = supabaseClient ?? SupabaseConfig.client;

  @override
  Future<String> createRequest(Map<String, dynamic> payload) async {
    final res = await supabaseClient.from('solicitudes_adopcion').insert(payload).select('id').single();
    return res['id'] as String;
  }

  @override
  Future<List<AdoptionRequestModel>> getRequestsForCurrentUser() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final res = await supabaseClient.from('solicitudes_adopcion').select().eq('adoptante_id', userId).order('created_at', ascending: false);
    return (res as List).map((e) => AdoptionRequestModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<AdoptionRequestModel>> getRequestsForRefugio(String refugioId) async {
    final res = await supabaseClient.from('solicitudes_adopcion').select().eq('refugio_id', refugioId).order('created_at', ascending: false);
    return (res as List).map((e) => AdoptionRequestModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<AdoptionRequestModel> getRequestById(String id) async {
    final res = await supabaseClient.from('solicitudes_adopcion').select().eq('id', id).single();
    return AdoptionRequestModel.fromJson(res as Map<String, dynamic>);
  }

  @override
  Future<void> updateRequestStatus(String id, String estado, {String? comentarios}) async {
    await supabaseClient.from('solicitudes_adopcion').update({
      'estado': estado,
      'comentarios_refugio': comentarios,
      'fecha_decision': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }
}