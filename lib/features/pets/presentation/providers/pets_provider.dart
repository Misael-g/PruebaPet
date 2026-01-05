// lib/features/pets/presentation/providers/pets_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pets_repository.dart';

enum PetsStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class PetsProvider with ChangeNotifier {
  final PetsRepository repository;

  PetsProvider({required this.repository});

  PetsStatus _status = PetsStatus.initial;
  List<PetEntity> _pets = [];
  String? _errorMessage;

  // Filtros
  String? _filtroEspecie;
  String? _filtroTamanio;
  String? _filtroCiudad;
  String? _filtroSexo;
  String _busqueda = '';

  // Paginación
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  bool _hasMoreData = true;

  // Getters
  PetsStatus get status => _status;
  List<PetEntity> get pets => _pets;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == PetsStatus.loading;
  bool get isLoadingMore => _status == PetsStatus.loadingMore;
  bool get hasMoreData => _hasMoreData;

  String? get filtroEspecie => _filtroEspecie;
  String? get filtroTamanio => _filtroTamanio;
  String? get filtroCiudad => _filtroCiudad;
  String? get filtroSexo => _filtroSexo;

  // Cargar mascotas iniciales
  Future<void> loadPets({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _pets.clear();
      _hasMoreData = true;
    }

    if (_status == PetsStatus.loading) return;

    _status = PetsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.getPetsByFilters(
        especie: _filtroEspecie,
        tamanio: _filtroTamanio,
        ciudad: _filtroCiudad,
        sexo: _filtroSexo,
        limit: _itemsPerPage,
        offset: _currentPage * _itemsPerPage,
      );

      result.fold(
        (failure) {
          _status = PetsStatus.error;
          _errorMessage = failure.message;
        },
        (pets) {
          if (refresh) {
            _pets = pets;
          } else {
            _pets.addAll(pets);
          }

          _hasMoreData = pets.length == _itemsPerPage;
          _status = PetsStatus.loaded;
        },
      );
    } catch (e) {
      _status = PetsStatus.error;
      _errorMessage = 'Error inesperado: $e';
    }

    notifyListeners();
  }

  // Cargar más mascotas (paginación)
  Future<void> loadMorePets() async {
    if (!_hasMoreData || _status == PetsStatus.loadingMore) return;

    _status = PetsStatus.loadingMore;
    notifyListeners();

    _currentPage++;

    try {
      final result = await repository.getPetsByFilters(
        especie: _filtroEspecie,
        tamanio: _filtroTamanio,
        ciudad: _filtroCiudad,
        sexo: _filtroSexo,
        limit: _itemsPerPage,
        offset: _currentPage * _itemsPerPage,
      );

      result.fold(
        (failure) {
          _status = PetsStatus.error;
          _errorMessage = failure.message;
          _currentPage--; // Revertir incremento
        },
        (pets) {
          _pets.addAll(pets);
          _hasMoreData = pets.length == _itemsPerPage;
          _status = PetsStatus.loaded;
        },
      );
    } catch (e) {
      _status = PetsStatus.error;
      _errorMessage = 'Error inesperado: $e';
      _currentPage--; // Revertir incremento
    }

    notifyListeners();
  }

  // Buscar mascotas
  Future<void> searchPets(String query) async {
    _busqueda = query;

    if (query.isEmpty) {
      loadPets(refresh: true);
      return;
    }

    _status = PetsStatus.loading;
    _errorMessage = null;
    _currentPage = 0;
    notifyListeners();

    try {
      final result = await repository.searchPets(query);

      result.fold(
        (failure) {
          _status = PetsStatus.error;
          _errorMessage = failure.message;
        },
        (pets) {
          _pets = pets;
          _hasMoreData = false; // No hay paginación en búsqueda
          _status = PetsStatus.loaded;
        },
      );
    } catch (e) {
      _status = PetsStatus.error;
      _errorMessage = 'Error inesperado: $e';
    }

    notifyListeners();
  }

  // Aplicar filtros
  void setFiltros({
    String? especie,
    String? tamanio,
    String? ciudad,
    String? sexo,
  }) {
    _filtroEspecie = especie;
    _filtroTamanio = tamanio;
    _filtroCiudad = ciudad;
    _filtroSexo = sexo;

    loadPets(refresh: true);
  }

  // Limpiar filtros
  void clearFilters() {
    _filtroEspecie = null;
    _filtroTamanio = null;
    _filtroCiudad = null;
    _filtroSexo = null;

    loadPets(refresh: true);
  }

  // Obtener mascota por ID
  PetEntity? getPetById(String id) {
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  // Incrementar visitas
  Future<void> incrementVisits(String petId) async {
    await repository.incrementVisits(petId);
  }

  // Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset provider
  void reset() {
    _status = PetsStatus.initial;
    _pets.clear();
    _errorMessage = null;
    _currentPage = 0;
    _hasMoreData = true;
    _filtroEspecie = null;
    _filtroTamanio = null;
    _filtroCiudad = null;
    _filtroSexo = null;
    _busqueda = '';
    notifyListeners();
  }
}