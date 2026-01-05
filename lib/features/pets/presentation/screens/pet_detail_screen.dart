// lib/features/pets/presentation/screens/pet_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/pet_entity.dart';
import '../../data/datasources/pets_remote_datasource.dart';
import '../../domain/repositories/pets_repository.dart';
import '../../data/repositories/pets_repository_impl.dart';
import '../providers/pets_provider.dart';

class PetDetailScreen extends StatefulWidget {
  final String petId;
  final PetsRepository? repository; // inyectable para tests

  const PetDetailScreen({super.key, required this.petId, this.repository});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late Future<PetEntity> _petFuture;
  int _currentPage = 0;

  Future<PetEntity> _loadPetDetail() async {
    final repository = widget.repository ?? PetsRepositoryImpl(remoteDataSource: PetsRemoteDataSourceImpl());

    final result = await repository.getPetById(widget.petId);
    return result.fold((failure) => throw Exception(failure.message), (pet) => pet);
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<PetsProvider>();
    // Incrementar visitas (no bloqueante)
    provider.incrementVisits(widget.petId);

    _petFuture = _loadPetDetail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PetEntity>(
      future: _petFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalle de mascota')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final pet = snapshot.data!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad de favoritos pendiente')),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Builder(builder: (context) {
                    final images = <String>[];
                    if (pet.imagenes != null && pet.imagenes!.isNotEmpty) {
                      images.addAll(pet.imagenes!.whereType<String>());
                    }
                    if (pet.imagenPrincipal != null) {
                      images.insert(0, pet.imagenPrincipal!);
                    }

                    if (images.isEmpty) {
                      return Center(child: Text(pet.iconoEspecie, style: const TextStyle(fontSize: 64)));
                    }

                    return PageView.builder(
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final img = images[index];
                        return Image.network(img, fit: BoxFit.cover);
                      },
                    );
                  }),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pet.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(pet.nombreRefugio ?? '', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: pet.esDisponible ? Colors.green[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(pet.esDisponible ? 'Disponible' : 'No disponible', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Indicador de imagen
                      Center(
                        child: Text('Foto ${_currentPage + 1}', style: TextStyle(color: Colors.grey[600])),
                      ),

                      const SizedBox(height: 12),

                      // Badges
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _badge('${pet.edadTexto}'),
                          _badge(pet.sexo ?? 'Sexo desconocido'),
                          if (pet.tamanio != null) _badge(pet.tamanio!),
                          if (pet.vacunado) _badge('Vacunado'),
                          if (pet.esterilizado) _badge('Esterilizado'),
                          if (pet.desparasitado) _badge('Desparasitado'),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Refugio
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.pets),
                          title: Text(pet.nombreRefugio ?? 'Refugio'),
                          subtitle: Text(pet.ciudadRefugio ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Llamar al refugio (pendiente)')));
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text('Sobre la mascota', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(pet.descripcion ?? 'No hay descripción disponible.'),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/request-form', arguments: pet.id);
                          },
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: const Text('Solicitar Adopción'),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
