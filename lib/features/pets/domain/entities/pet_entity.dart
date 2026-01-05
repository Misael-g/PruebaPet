// lib/features/pets/domain/entities/pet_entity.dart

class PetEntity {
  final String id;
  final String refugioId;
  final String nombre;
  final String especie; // 'perro', 'gato', 'otro'
  final String? raza;
  final int? edadAnios;
  final int? edadMeses;
  final String? sexo; // 'macho', 'hembra'
  final String? tamanio; // 'pequeño', 'mediano', 'grande'
  final double? pesoKg;
  final String? color;
  final String? descripcion;
  final List<String>? personalidad;
  final String? requisitosAdopcion;
  final String? historia;
  final String? estadoSalud;
  final bool vacunado;
  final bool esterilizado;
  final bool desparasitado;
  final String? necesidadesEspeciales;
  final bool? buenoConNinos;
  final bool? buenoConPerros;
  final bool? buenoConGatos;
  final String? imagenPrincipal;
  final List<String>? imagenes;
  final String estado; // 'disponible', 'en_proceso', 'adoptado', 'no_disponible'
  final DateTime? fechaRescate;
  final DateTime? fechaIngreso;
  final DateTime fechaPublicacion;
  final int visitas;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Datos del refugio (para joins)
  final String? nombreRefugio;
  final String? ciudadRefugio;

  const PetEntity({
    required this.id,
    required this.refugioId,
    required this.nombre,
    required this.especie,
    this.raza,
    this.edadAnios,
    this.edadMeses,
    this.sexo,
    this.tamanio,
    this.pesoKg,
    this.color,
    this.descripcion,
    this.personalidad,
    this.requisitosAdopcion,
    this.historia,
    this.estadoSalud,
    this.vacunado = false,
    this.esterilizado = false,
    this.desparasitado = false,
    this.necesidadesEspeciales,
    this.buenoConNinos,
    this.buenoConPerros,
    this.buenoConGatos,
    this.imagenPrincipal,
    this.imagenes,
    this.estado = 'disponible',
    this.fechaRescate,
    this.fechaIngreso,
    required this.fechaPublicacion,
    this.visitas = 0,
    required this.createdAt,
    required this.updatedAt,
    this.nombreRefugio,
    this.ciudadRefugio,
  });

  String get edadTexto {
    if (edadAnios == null && edadMeses == null) return 'Edad desconocida';
    
    List<String> partes = [];
    if (edadAnios != null && edadAnios! > 0) {
      partes.add('$edadAnios ${edadAnios == 1 ? 'año' : 'años'}');
    }
    if (edadMeses != null && edadMeses! > 0) {
      partes.add('$edadMeses ${edadMeses == 1 ? 'mes' : 'meses'}');
    }
    
    return partes.isEmpty ? 'Edad desconocida' : partes.join(' y ');
  }

  String get iconoEspecie {
    switch (especie.toLowerCase()) {
      case 'perro':
        return '🐕';
      case 'gato':
        return '🐈';
      default:
        return '🐾';
    }
  }

  bool get esDisponible => estado == 'disponible';

  PetEntity copyWith({
    String? id,
    String? refugioId,
    String? nombre,
    String? especie,
    String? raza,
    int? edadAnios,
    int? edadMeses,
    String? sexo,
    String? tamanio,
    double? pesoKg,
    String? color,
    String? descripcion,
    List<String>? personalidad,
    String? requisitosAdopcion,
    String? historia,
    String? estadoSalud,
    bool? vacunado,
    bool? esterilizado,
    bool? desparasitado,
    String? necesidadesEspeciales,
    bool? buenoConNinos,
    bool? buenoConPerros,
    bool? buenoConGatos,
    String? imagenPrincipal,
    List<String>? imagenes,
    String? estado,
    DateTime? fechaRescate,
    DateTime? fechaIngreso,
    DateTime? fechaPublicacion,
    int? visitas,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? nombreRefugio,
    String? ciudadRefugio,
  }) {
    return PetEntity(
      id: id ?? this.id,
      refugioId: refugioId ?? this.refugioId,
      nombre: nombre ?? this.nombre,
      especie: especie ?? this.especie,
      raza: raza ?? this.raza,
      edadAnios: edadAnios ?? this.edadAnios,
      edadMeses: edadMeses ?? this.edadMeses,
      sexo: sexo ?? this.sexo,
      tamanio: tamanio ?? this.tamanio,
      pesoKg: pesoKg ?? this.pesoKg,
      color: color ?? this.color,
      descripcion: descripcion ?? this.descripcion,
      personalidad: personalidad ?? this.personalidad,
      requisitosAdopcion: requisitosAdopcion ?? this.requisitosAdopcion,
      historia: historia ?? this.historia,
      estadoSalud: estadoSalud ?? this.estadoSalud,
      vacunado: vacunado ?? this.vacunado,
      esterilizado: esterilizado ?? this.esterilizado,
      desparasitado: desparasitado ?? this.desparasitado,
      necesidadesEspeciales: necesidadesEspeciales ?? this.necesidadesEspeciales,
      buenoConNinos: buenoConNinos ?? this.buenoConNinos,
      buenoConPerros: buenoConPerros ?? this.buenoConPerros,
      buenoConGatos: buenoConGatos ?? this.buenoConGatos,
      imagenPrincipal: imagenPrincipal ?? this.imagenPrincipal,
      imagenes: imagenes ?? this.imagenes,
      estado: estado ?? this.estado,
      fechaRescate: fechaRescate ?? this.fechaRescate,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      fechaPublicacion: fechaPublicacion ?? this.fechaPublicacion,
      visitas: visitas ?? this.visitas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nombreRefugio: nombreRefugio ?? this.nombreRefugio,
      ciudadRefugio: ciudadRefugio ?? this.ciudadRefugio,
    );
  }
}