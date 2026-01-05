// lib/features/adoption_requests/domain/entities/adoption_request_entity.dart

class AdoptionRequestEntity {
  final String id;
  final String mascotaId;
  final String adoptanteId;
  final String refugioId;
  final String estado; // 'pendiente', 'aprobada', 'rechazada'
  final String experienciaMascotas;
  final bool tieneOtrasMascotas;
  final String tipoVivienda;
  final bool tienePatio;
  final int personasHogar;
  final bool hayNinos;
  final String razonAdopcion;
  final String? comentariosRefugio;
  final DateTime createdAt;

  AdoptionRequestEntity({
    required this.id,
    required this.mascotaId,
    required this.adoptanteId,
    required this.refugioId,
    required this.estado,
    required this.experienciaMascotas,
    required this.tieneOtrasMascotas,
    required this.tipoVivienda,
    required this.tienePatio,
    required this.personasHogar,
    required this.hayNinos,
    required this.razonAdopcion,
    this.comentariosRefugio,
    required this.createdAt,
  });
}