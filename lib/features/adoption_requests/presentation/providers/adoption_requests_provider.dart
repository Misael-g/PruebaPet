// lib/features/adoption_requests/presentation/providers/adoption_requests_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/adoption_request_entity.dart';
import '../../domain/repositories/adoption_requests_repository.dart';

enum RequestsStatus { initial, loading, loaded, error }

class AdoptionRequestsProvider with ChangeNotifier {
  final AdoptionRequestsRepository repository;

  AdoptionRequestsProvider({required this.repository});

  RequestsStatus _status = RequestsStatus.initial;
  List<AdoptionRequestEntity> _requests = [];
  String? _errorMessage;

  RequestsStatus get status => _status;
  List<AdoptionRequestEntity> get requests => _requests;
  String? get errorMessage => _errorMessage;

  Future<void> loadMyRequests() async {
    _status = RequestsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.getMyRequests();
    result.fold((failure) {
      _status = RequestsStatus.error;
      _errorMessage = failure.message;
    }, (list) {
      _requests = list;
      _status = RequestsStatus.loaded;
    });

    notifyListeners();
  }

  Future<void> createRequest(Map<String, dynamic> payload) async {
    // Crear y luego recargar
    await repository.createRequest(payload);
    await loadMyRequests();
  }

  Future<void> updateRequestStatus(String id, String estado, {String? comentarios}) async {
    await repository.updateRequestStatus(id, estado, comentarios: comentarios);
    await loadMyRequests();
  }
}