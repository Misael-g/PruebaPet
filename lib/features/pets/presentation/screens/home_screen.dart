// lib/features/pets/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/pets_provider.dart';
import '../../domain/entities/pet_entity.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../adoption_requests/presentation/screens/my_requests_screen.dart';
import '../../../user/presentation/screens/profile_screen.dart';

// Provider real: PetsProvider (proveer desde el nivel superior en main.dart)



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar mascotas iniciales desde el provider
      final provider = context.read<PetsProvider>();
      provider.loadPets();

      // Cargar favoritos del usuario
      final favProvider = context.read<FavoritesProvider>();
      favProvider.loadFavorites();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final provider = context.read<PetsProvider>();
    final threshold = 300.0;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - threshold) {
      if (provider.hasMoreData && !provider.isLoadingMore) {
        provider.loadMorePets();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Build pages once we have context (so providers are available)
    if (_pages.isEmpty) {
      _pages.addAll([
        // Home page
        SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildFilterChips(),
              Expanded(child: _buildPetGrid()),
            ],
          ),
        ),

        // Map placeholder
        const Center(child: Text('Mapa - En desarrollo')),

        // Chat IA placeholder
        const Center(child: Text('Chat IA - En desarrollo')),

        // Requests page
        const MyRequestsScreen(),

        // Profile page
        const ProfileScreen(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final name = auth.currentUser?.nombre ?? auth.currentUser?.email?.split('@').first ?? 'Usuario';

        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Hola, ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '$name 👋',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Encuentra tu mascota',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Consumer<PetsProvider>(
              builder: (context, provider, _) {
                return TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      provider.loadPets(refresh: true);
                    } else {
                      provider.searchPets(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar mascota...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                );
              },
            ),

          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () {
                _showFilterBottomSheet(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Todos', 'Perro', 'Gato'];
    
    return Consumer<PetsProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: filters.map((filter) {
              final isSelected = (provider.filtroEspecie == null && filter == 'Todos') || (provider.filtroEspecie == filter.toLowerCase());
              final icon = filter == 'Perro' ? '🐕' : filter == 'Gato' ? '🐈' : '';
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon.isNotEmpty) ...[
                        Text(icon, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                      ],
                      Text(filter),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    if (filter == 'Todos') {
                      provider.clearFilters();
                    } else {
                      provider.setFiltros(especie: filter.toLowerCase());
                    }
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildPetGrid() {
    return Consumer<PetsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.pets.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron mascotas',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final pets = provider.pets;

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: pets.length + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < pets.length) {
              return _buildPetCard(pets[index]);
            }

            // Loading más
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPetCard(PetEntity pet) {
    final colors = [
      const Color(0xFFFFF4E6),
      const Color(0xFFE6F7F1),
      const Color(0xFFFFE6F0),
      const Color(0xFFF0E6FF),
    ];
    
    final color = colors[pet.id.hashCode % colors.length];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/pet-detail', arguments: pet.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: pet.imagenPrincipal != null
                          ? Image.network(
                              pet.imagenPrincipal!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Center(
                              child: Text(
                                pet.iconoEspecie,
                                style: const TextStyle(fontSize: 64),
                              ),
                            ),
                    ),
                  ),
                  // Botón de favorito (connectado a FavoritesProvider)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favProvider, _) {
                        final isFav = favProvider.isFavorite(pet.id);
                        return GestureDetector(
                          onTap: () => favProvider.toggleFavorite(pet.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Información
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${pet.raza ?? ''} • ${pet.edadTexto}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Text(
                          pet.ciudadRefugio ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat IA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'Solicitudes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtros Avanzados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Aquí irían más filtros avanzados
              ListTile(
                leading: const Icon(Icons.pets),
                title: const Text('Tamaño'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Edad'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Distancia'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Aplicar Filtros'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}