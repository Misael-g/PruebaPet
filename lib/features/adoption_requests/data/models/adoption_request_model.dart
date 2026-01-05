// lib/features/adoption_requests/data/models/adoption_request_model.dart

import '../../domain/entities/adoption_request_entity.dart';

class AdoptionRequestModel extends AdoptionRequestEntity {
  AdoptionRequestModel({
    required String id,
    required String mascotaId,
    required String adoptanteId,
    required String refugioId,
    required String estado,
    required String experienciaMascotas,
    required bool tieneOtrasMascotas,
    required String tipoVivienda,
    required bool tienePatio,
    required int personasHogar,
    required bool hayNinos,
    required String razonAdopcion,
    String? comentariosRefugio,
    required DateTime createdAt,
  }) : super(
          id: id,
          mascotaId: mascotaId,
          adoptanteId: adoptanteId,
          refugioId: refugioId,
          estado: estado,
          experienciaMascotas: experienciaMascotas,
          tieneOtrasMascotas: tieneOtrasMascotas,
          tipoVivienda: tipoVivienda,
          tienePatio: tienePatio,
          personasHogar: personasHogar,
          hayNinos: hayNinos,
          razonAdopcion: razonAdopcion,
          comentariosRefugio: comentariosRefugio,
          createdAt: createdAt,
        );

  factory AdoptionRequestModel.fromJson(Map<String, dynamic> json) {
    return AdoptionRequestModel(
      id: json['id'] as String,
      mascotaId: json['mascota_id'] as String,
      adoptanteId: json['adoptante_id'] as String,
      refugioId: json['refugio_id'] as String,
      estado: json['estado'] as String,
      experienciaMascotas: json['experiencia_mascotas'] as String? ?? '',
      tieneOtrasMascotas: json['tiene_otras_mascotas'] as bool? ?? false,
      tipoVivienda: json['tipo_vivienda'] as String? ?? '',
      tienePatio: json['tiene_patio'] as bool? ?? false,
      personasHogar: (json['personas_hogar'] as int?) ?? 0,
      hayNinos: json['hay_niños'] as bool? ?? false,
      razonAdopcion: json['razon_adopcion'] as String? ?? '',
      comentariosRefugio: json['comentarios_refugio'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mascota_id': mascotaId,
      'adoptante_id': adoptanteId,
      'refugio_id': refugioId,
      'estado': estado,
      'experiencia_mascotas': experienciaMascotas,
      'tiene_otras_mascotas': tieneOtrasMascotas,
      'tipo_vivienda': tipoVivienda,
      'tiene_patio': tienePatio,
      'personas_hogar': personasHogar,
      'hay_niños': hayNinos,
      'razon_adopcion': razonAdopcion,
      'comentarios_refugio': comentariosRefugio,
      'created_at': createdAt.toIso8601String(),
    };
  }
}