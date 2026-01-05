// lib/features/favorites/presentation/providers/favorites_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesProvider with ChangeNotifier {
  final FavoritesRepository repository;

  FavoritesProvider({required this.repository});

  final List<String> _favoritePetIds = [];
  bool _isLoading = false;

  List<String> get favoritePetIds => List.unmodifiable(_favoritePetIds);
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    final result = await repository.getFavoritePetIds();
    result.fold((failure) {
      _isLoading = false;
      notifyListeners();
    }, (ids) {
      _favoritePetIds
        ..clear()
        ..addAll(ids);
      _isLoading = false;
      notifyListeners();
    });
  }

  bool isFavorite(String petId) {
    return _favoritePetIds.contains(petId);
  }

  Future<void> _addFavorite(String petId) async {
    final res = await repository.addFavorite(petId);
    res.fold((failure) {}, (_) {
      _favoritePetIds.add(petId);
      notifyListeners();
    });
  }

  Future<void> _removeFavorite(String petId) async {
    final res = await repository.removeFavorite(petId);
    res.fold((failure) {}, (_) {
      _favoritePetIds.remove(petId);
      notifyListeners();
    });
  }

  Future<void> toggleFavorite(String petId) async {
    if (isFavorite(petId)) {
      await _removeFavorite(petId);
    } else {
      await _addFavorite(petId);
    }
  }
}