// lib/features/adoption_requests/domain/repositories/adoption_requests_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/adoption_request_entity.dart';

abstract class AdoptionRequestsRepository {
  Future<Either<Failure, String>> createRequest(Map<String, dynamic> payload);
  Future<Either<Failure, List<AdoptionRequestEntity>>> getMyRequests();
  Future<Either<Failure, List<AdoptionRequestEntity>>> getRequestsForRefugio(String refugioId);
  Future<Either<Failure, AdoptionRequestEntity>> getRequestById(String id);
  Future<Either<Failure, void>> updateRequestStatus(String id, String estado, {String? comentarios});
}