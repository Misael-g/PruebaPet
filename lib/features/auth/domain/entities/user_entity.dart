// lib/features/auth/domain/entities/user_entity.dart

class UserEntity {
  final String id;
  final String email;
  final String nombre;
  final String? apellido;
  final String tipoUsuario; // 'adoptante' o 'refugio'
  final String? telefono;
  final String? direccion;
  final String? ciudad;
  final String? provincia;
  final String? avatarUrl;
  final bool verificado;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.nombre,
    this.apellido,
    required this.tipoUsuario,
    this.telefono,
    this.direccion,
    this.ciudad,
    this.provincia,
    this.avatarUrl,
    this.verificado = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String get nombreCompleto {
    if (apellido != null && apellido!.isNotEmpty) {
      return '$nombre $apellido';
    }
    return nombre;
  }

  bool get isRefugio => tipoUsuario == 'refugio';
  bool get isAdoptante => tipoUsuario == 'adoptante';

  UserEntity copyWith({
    String? id,
    String? email,
    String? nombre,
    String? apellido,
    String? tipoUsuario,
    String? telefono,
    String? direccion,
    String? ciudad,
    String? provincia,
    String? avatarUrl,
    bool? verificado,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      provincia: provincia ?? this.provincia,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      verificado: verificado ?? this.verificado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}