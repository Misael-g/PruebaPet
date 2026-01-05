// lib/features/user/presentation/providers/user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/usecases/update_avatar_usecase.dart';
import '../../domain/usecases/delete_avatar_usecase.dart';

enum UserStatus {
  initial,
  loading,
  loaded,
  updating,
  error,
}

class UserProvider with ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadAvatarUseCase uploadAvatarUseCase;
  final UpdateAvatarUseCase updateAvatarUseCase;
  final DeleteAvatarUseCase deleteAvatarUseCase;

  UserProvider({
    required this.getCurrentUserUseCase,
    required this.updateProfileUseCase,
    required this.uploadAvatarUseCase,
    required this.updateAvatarUseCase,
    required this.deleteAvatarUseCase,
  });

  UserStatus _status = UserStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  UserStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == UserStatus.loading;
  bool get isUpdating => _status == UserStatus.updating;

  // Cargar perfil actual
  Future<void> loadCurrentUser() async {
    _status = UserStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) {
        _status = UserStatus.error;
        _errorMessage = failure.message;
        _currentUser = null;
      },
      (user) {
        _status = UserStatus.loaded;
        _currentUser = user;
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  // Actualizar perfil
  Future<bool> updateProfile({
    String? nombre,
    String? apellido,
    String? telefono,
    String? direccion,
    String? ciudad,
    String? provincia,
  }) async {
    _status = UserStatus.updating;
    _errorMessage = null;
    notifyListeners();

    final result = await updateProfileUseCase(
      nombre: nombre,
      apellido: apellido,
      telefono: telefono,
      direccion: direccion,
      ciudad: ciudad,
      provincia: provincia,
    );

    return result.fold(
      (failure) {
        _status = UserStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _status = UserStatus.loaded;
        _currentUser = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  // Subir y actualizar avatar
  Future<bool> changeAvatar(XFile image) async {
    _status = UserStatus.updating;
    _errorMessage = null;
    notifyListeners();

    // Primero subir la imagen
    final uploadResult = await uploadAvatarUseCase(image);

    bool success = false;

    await uploadResult.fold(
      (failure) async {
        _status = UserStatus.error;
        _errorMessage = failure.message;
        success = false;
      },
      (avatarUrl) async {
        // Luego actualizar el perfil con la nueva URL
        final updateResult = await updateAvatarUseCase(avatarUrl);

        updateResult.fold(
          (failure) {
            _status = UserStatus.error;
            _errorMessage = failure.message;
            success = false;
          },
          (user) {
            _status = UserStatus.loaded;
            _currentUser = user;
            _errorMessage = null;
            success = true;
          },
        );
      },
    );

    notifyListeners();
    return success;
  }

  // Eliminar avatar
  Future<bool> removeAvatar() async {
    _status = UserStatus.updating;
    _errorMessage = null;
    notifyListeners();

    final result = await deleteAvatarUseCase();

    return result.fold(
      (failure) {
        _status = UserStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) async {
        // Recargar perfil para obtener estado actualizado
        await loadCurrentUser();
        return true;
      },
    );
  }

  // Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}