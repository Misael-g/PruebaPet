// lib/features/auth/data/models/user_model.dart

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.nombre,
    super.apellido,
    required super.tipoUsuario,
    super.telefono,
    super.direccion,
    super.ciudad,
    super.provincia,
    super.avatarUrl,
    super.verificado,
    required super.createdAt,
    required super.updatedAt,
  });

  // Crear desde JSON (respuesta de Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String?,
      tipoUsuario: json['tipo_usuario'] as String,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      ciudad: json['ciudad'] as String?,
      provincia: json['provincia'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      verificado: json['verificado'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convertir a JSON (para enviar a Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'tipo_usuario': tipoUsuario,
      'telefono': telefono,
      'direccion': direccion,
      'ciudad': ciudad,
      'provincia': provincia,
      'avatar_url': avatarUrl,
      'verificado': verificado,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convertir de Entity a Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      nombre: entity.nombre,
      apellido: entity.apellido,
      tipoUsuario: entity.tipoUsuario,
      telefono: entity.telefono,
      direccion: entity.direccion,
      ciudad: entity.ciudad,
      provincia: entity.provincia,
      avatarUrl: entity.avatarUrl,
      verificado: entity.verificado,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  UserModel copyWith({
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
    return UserModel(
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