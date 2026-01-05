import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:provider/provider.dart';

import 'package:petadopt/features/pets/presentation/screens/pet_detail_screen.dart';
import 'package:petadopt/features/pets/domain/repositories/pets_repository.dart';
import 'package:petadopt/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt/features/pets/presentation/providers/pets_provider.dart';

class MockPetsRepository extends Mock implements PetsRepository {}

void main() {
  late MockPetsRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(const <Type, dynamic>{});
  });

  setUp(() {
    mockRepo = MockPetsRepository();
  });

  final pet = PetEntity(
    id: 'p1',
    refugioId: 'r1',
    nombre: 'Luna',
    especie: 'perro',
    fechaPublicacion: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  testWidgets('PetDetailScreen displays pet info', (tester) async {
    when(() => mockRepo.getPetById('p1')).thenAnswer((_) async => Right(pet));
    when(() => mockRepo.incrementVisits('p1')).thenAnswer((_) async => const Right(null));

    final provider = PetsProvider(repository: mockRepo);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PetsProvider>.value(value: provider),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      ),
    );

    // pump PetDetailScreen directly
    await tester.pumpWidget(
      ChangeNotifierProvider<PetsProvider>.value(
        value: provider,
        child: MaterialApp(
          home: PetDetailScreen(petId: 'p1', repository: mockRepo),
        ),
      ),
    );

    // Inicialmente muestra CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Esperar a que FutureBuilder complete
    await tester.pumpAndSettle();

    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('Sobre la mascota'), findsOneWidget);
    expect(find.text('Solicitar Adopción'), findsOneWidget);
  });
}