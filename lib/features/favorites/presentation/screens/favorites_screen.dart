// lib/features/favorites/presentation/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/repositories/favorites_repository.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Consumer<FavoritesProvider>(
        builder: (context, favProvider, _) {
          if (favProvider.isLoading) return const Center(child: CircularProgressIndicator());
          if (favProvider.favoritePetIds.isEmpty) return const Center(child: Text('No tienes mascotas favoritas aún'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favProvider.favoritePetIds.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final petId = favProvider.favoritePetIds[index];
              return ListTile(
                title: Text('Mascota: $petId'),
                subtitle: const Text('Ver detalle'),
                trailing: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => Navigator.pushNamed(context, '/pet-detail', arguments: petId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}