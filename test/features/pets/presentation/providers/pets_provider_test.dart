import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:petadopt/features/pets/presentation/providers/pets_provider.dart';
import 'package:petadopt/features/pets/domain/repositories/pets_repository.dart';
import 'package:petadopt/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt/core/errors/failures.dart';

class MockPetsRepository extends Mock implements PetsRepository {}

void main() {
  late MockPetsRepository mockRepo;
  late PetsProvider provider;

  setUp(() {
    mockRepo = MockPetsRepository();
    provider = PetsProvider(repository: mockRepo);
  });

  final samplePet = PetEntity(
    id: 'p1',
    refugioId: 'r1',
    nombre: 'Luna',
    especie: 'perro',
    fechaPublicacion: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('loadPets loads initial data', () async {
    when(() => mockRepo.getPetsByFilters(limit: any(named: 'limit'), offset: any(named: 'offset')))
        .thenAnswer((_) async => Right([samplePet]));

    await provider.loadPets(refresh: true);

    expect(provider.pets.length, 1);
    expect(provider.pets.first.id, 'p1');
    expect(provider.hasMoreData, false);
    expect(provider.status, PetsStatus.loaded);
  });

  test('loadMorePets appends data and updates hasMoreData', () async {
    // first page returns full page
    when(() => mockRepo.getPetsByFilters(limit: any(named: 'limit'), offset: 0))
        .thenAnswer((_) async => Right(List.generate(20, (i) => samplePet)));

    // second page returns shorter (no more data)
    when(() => mockRepo.getPetsByFilters(limit: any(named: 'limit'), offset: 20))
        .thenAnswer((_) async => Right(List.generate(5, (i) => samplePet)));

    await provider.loadPets(refresh: true);
    expect(provider.pets.length, 20);
    expect(provider.hasMoreData, true);

    await provider.loadMorePets();
    expect(provider.pets.length, 25);
    expect(provider.hasMoreData, false);
  });

  test('searchPets replaces list and disables pagination', () async {
    when(() => mockRepo.searchPets('Luna')).thenAnswer((_) async => Right([samplePet]));

    await provider.searchPets('Luna');

    expect(provider.pets.length, 1);
    expect(provider.hasMoreData, false);
    expect(provider.status, PetsStatus.loaded);
  });

  test('incrementVisits calls repository', () async {
    when(() => mockRepo.incrementVisits('p1')).thenAnswer((_) async => const Right(null));

    await provider.incrementVisits('p1');

    verify(() => mockRepo.incrementVisits('p1')).called(1);
  });
}