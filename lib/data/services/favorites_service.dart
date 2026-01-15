import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/art_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites_artworks';
  
  // Singleton pattern
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  // Get all favorites
  Future<List<ArtModel>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);
      
      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }
      
      final List<dynamic> decoded = json.decode(favoritesJson);
      return decoded.map((item) => ArtModel.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      return [];
    }
  }

  // Add to favorites
  Future<bool> addFavorite(ArtModel art) async {
    try {
      final favorites = await getFavorites();
      
      // Check if already exists
      if (favorites.any((item) => item.id == art.id)) {
        return false;
      }
      
      favorites.add(art);
      await _saveFavorites(favorites);
      return true;
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      return false;
    }
  }

  // Remove from favorites
  Future<bool> removeFavorite(String artId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((item) => item.id == artId);
      await _saveFavorites(favorites);
      return true;
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      return false;
    }
  }

  // Check if artwork is favorited
  Future<bool> isFavorite(String artId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((item) => item.id == artId);
    } catch (e) {
      debugPrint('Error checking favorite: $e');
      return false;
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(ArtModel art) async {
    final isFav = await isFavorite(art.id);
    if (isFav) {
      return await removeFavorite(art.id);
    } else {
      return await addFavorite(art);
    }
  }

  // Save favorites to storage
  Future<void> _saveFavorites(List<ArtModel> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = 
          favorites.map((art) => art.toJson()).toList();
      final String encoded = json.encode(jsonList);
      await prefs.setString(_favoritesKey, encoded);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }
}
