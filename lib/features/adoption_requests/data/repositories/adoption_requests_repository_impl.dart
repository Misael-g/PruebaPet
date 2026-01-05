// lib/features/adoption_requests/data/repositories/adoption_requests_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/adoption_request_entity.dart';
import '../../domain/repositories/adoption_requests_repository.dart';
import '../datasources/adoption_requests_remote_datasource.dart';
import '../models/adoption_request_model.dart';

class AdoptionRequestsRepositoryImpl implements AdoptionRequestsRepository {
  final AdoptionRequestsRemoteDataSource remoteDataSource;

  AdoptionRequestsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> createRequest(Map<String, dynamic> payload) async {
    try {
      final id = await remoteDataSource.createRequest(payload);
      return Right(id);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<AdoptionRequestEntity>>> getMyRequests() async {
    try {
      final res = await remoteDataSource.getRequestsForCurrentUser();
      return Right(res.map((e) => e as AdoptionRequestEntity).toList());
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<AdoptionRequestEntity>>> getRequestsForRefugio(String refugioId) async {
    try {
      final res = await remoteDataSource.getRequestsForRefugio(refugioId);
      return Right(res.map((e) => e as AdoptionRequestEntity).toList());
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, AdoptionRequestEntity>> getRequestById(String id) async {
    try {
      final res = await remoteDataSource.getRequestById(id);
      return Right(res as AdoptionRequestEntity);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateRequestStatus(String id, String estado, {String? comentarios}) async {
    try {
      await remoteDataSource.updateRequestStatus(id, estado, comentarios: comentarios);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
