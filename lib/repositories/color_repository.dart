import 'package:shared_preferences/shared_preferences.dart';
import '../models/color_scheme.dart';
import 'dart:convert';

class ColorRepository {
  static const String _colorSchemesKey = 'color_schemes';
  static const String _currentSchemeKey = 'current_scheme';
  static const String _favoriteSchemeKey = 'favorite_schemes';
  static const String _recentSchemesKey = 'recent_schemes';
  static const int _maxRecentSchemes = 10;

  // Get all saved color schemes
  Future<List<CustomColorScheme>> getAllColorSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    final schemesJson = prefs.getString(_colorSchemesKey);

    if (schemesJson == null || schemesJson.isEmpty) {
      return [];
    }

    return CustomColorScheme.fromJsonList(schemesJson);
  }

  // Get current color scheme
  Future<CustomColorScheme?> getCurrentScheme() async {
    final prefs = await SharedPreferences.getInstance();
    final schemeJson = prefs.getString(_currentSchemeKey);

    if (schemeJson == null || schemeJson.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> jsonMap =
          Map<String, dynamic>.from(Map.castFrom(json.decode(schemeJson)));
      return CustomColorScheme.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  // Save all color schemes
  Future<void> saveColorSchemes(List<CustomColorScheme> schemes) async {
    final prefs = await SharedPreferences.getInstance();
    final schemesJson = CustomColorScheme.toJsonList(schemes);
    await prefs.setString(_colorSchemesKey, schemesJson);
  }

  // Save current color scheme
  Future<void> saveCurrentScheme(CustomColorScheme scheme) async {
    final prefs = await SharedPreferences.getInstance();
    final schemeJson = json.encode(scheme.toJson());
    await prefs.setString(_currentSchemeKey, schemeJson);

    // Also add to recent schemes
    await _addToRecentSchemes(scheme);
  }

  // Add new color scheme
  Future<void> addColorScheme(CustomColorScheme scheme) async {
    final schemes = await getAllColorSchemes();

    // Check if a scheme with the same name already exists
    final existingIndex = schemes.indexWhere((s) => s.name == scheme.name);
    if (existingIndex != -1) {
      // Update existing scheme instead of adding a duplicate
      schemes[existingIndex] = scheme;
    } else {
      schemes.add(scheme);
    }

    await saveColorSchemes(schemes);
    await _addToRecentSchemes(scheme);
  }

  // Delete color scheme
  Future<void> removeColorScheme(CustomColorScheme scheme) async {
    final schemes = await getAllColorSchemes();
    schemes.removeWhere(
      (s) =>
          s.name == scheme.name &&
          s.hue == scheme.hue &&
          s.saturation == scheme.saturation &&
          s.lightness == scheme.lightness,
    );
    await saveColorSchemes(schemes);

    // Also remove from favorites if present
    await _removeFromFavorites(scheme);
  }

  // Update color scheme
  Future<void> updateColorScheme(
    CustomColorScheme oldScheme,
    CustomColorScheme newScheme,
  ) async {
    final schemes = await getAllColorSchemes();
    final index = schemes.indexWhere(
      (s) =>
          s.hue == oldScheme.hue &&
          s.saturation == oldScheme.saturation &&
          s.lightness == oldScheme.lightness &&
          s.name == oldScheme.name,
    );

    if (index != -1) {
      schemes[index] = newScheme;
      await saveColorSchemes(schemes);

      // Update in favorites if present
      await _updateInFavorites(oldScheme, newScheme);

      // Update in recent schemes if present
      await _updateInRecentSchemes(oldScheme, newScheme);

      // Update current scheme if it matches
      final currentScheme = await getCurrentScheme();
      if (currentScheme != null &&
          currentScheme.name == oldScheme.name &&
          currentScheme.hue == oldScheme.hue &&
          currentScheme.saturation == oldScheme.saturation &&
          currentScheme.lightness == oldScheme.lightness) {
        await saveCurrentScheme(newScheme);
      }
    }
  }

  // Clear all color schemes
  Future<void> clearAllColorSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_colorSchemesKey);
    await prefs.remove(_currentSchemeKey);
    await prefs.remove(_favoriteSchemeKey);
    await prefs.remove(_recentSchemesKey);
  }

  // Get favorite color schemes
  Future<List<CustomColorScheme>> getFavoriteSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoriteSchemeKey);

    if (favoritesJson == null || favoritesJson.isEmpty) {
      return [];
    }

    return CustomColorScheme.fromJsonList(favoritesJson);
  }

  // Add to favorites
  Future<void> addToFavorites(CustomColorScheme scheme) async {
    final favorites = await getFavoriteSchemes();

    // Check if already in favorites
    final existingIndex = favorites.indexWhere((s) =>
        s.name == scheme.name &&
        s.hue == scheme.hue &&
        s.saturation == scheme.saturation &&
        s.lightness == scheme.lightness);

    if (existingIndex == -1) {
      favorites.add(scheme);
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = CustomColorScheme.toJsonList(favorites);
      await prefs.setString(_favoriteSchemeKey, favoritesJson);
    }
  }

  // Remove from favorites
  Future<void> _removeFromFavorites(CustomColorScheme scheme) async {
    final favorites = await getFavoriteSchemes();
    favorites.removeWhere((s) =>
        s.name == scheme.name &&
        s.hue == scheme.hue &&
        s.saturation == scheme.saturation &&
        s.lightness == scheme.lightness);

    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = CustomColorScheme.toJsonList(favorites);
    await prefs.setString(_favoriteSchemeKey, favoritesJson);
  }

  // Check if a scheme is in favorites
  Future<bool> isFavorite(CustomColorScheme scheme) async {
    final favorites = await getFavoriteSchemes();
    return favorites.any((s) =>
        s.name == scheme.name &&
        s.hue == scheme.hue &&
        s.saturation == scheme.saturation &&
        s.lightness == scheme.lightness);
  }

  // Update in favorites
  Future<void> _updateInFavorites(
      CustomColorScheme oldScheme, CustomColorScheme newScheme) async {
    final favorites = await getFavoriteSchemes();
    final index = favorites.indexWhere((s) =>
        s.name == oldScheme.name &&
        s.hue == oldScheme.hue &&
        s.saturation == oldScheme.saturation &&
        s.lightness == oldScheme.lightness);

    if (index != -1) {
      favorites[index] = newScheme;
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = CustomColorScheme.toJsonList(favorites);
      await prefs.setString(_favoriteSchemeKey, favoritesJson);
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(CustomColorScheme scheme) async {
    final isFav = await isFavorite(scheme);

    if (isFav) {
      await _removeFromFavorites(scheme);
      return false;
    } else {
      await addToFavorites(scheme);
      return true;
    }
  }

  // Get recent color schemes
  Future<List<CustomColorScheme>> getRecentSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getString(_recentSchemesKey);

    if (recentJson == null || recentJson.isEmpty) {
      return [];
    }

    return CustomColorScheme.fromJsonList(recentJson);
  }

  // Add to recent schemes
  Future<void> _addToRecentSchemes(CustomColorScheme scheme) async {
    final recent = await getRecentSchemes();

    // Remove if already exists
    recent.removeWhere((s) =>
        s.name == scheme.name &&
        s.hue == scheme.hue &&
        s.saturation == scheme.saturation &&
        s.lightness == scheme.lightness);

    // Add to beginning of list
    recent.insert(0, scheme);

    // Limit to max number of recent schemes
    if (recent.length > _maxRecentSchemes) {
      recent.removeLast();
    }

    final prefs = await SharedPreferences.getInstance();
    final recentJson = CustomColorScheme.toJsonList(recent);
    await prefs.setString(_recentSchemesKey, recentJson);
  }

  // Update in recent schemes
  Future<void> _updateInRecentSchemes(
      CustomColorScheme oldScheme, CustomColorScheme newScheme) async {
    final recent = await getRecentSchemes();
    final index = recent.indexWhere((s) =>
        s.name == oldScheme.name &&
        s.hue == oldScheme.hue &&
        s.saturation == oldScheme.saturation &&
        s.lightness == oldScheme.lightness);

    if (index != -1) {
      recent[index] = newScheme;
      final prefs = await SharedPreferences.getInstance();
      final recentJson = CustomColorScheme.toJsonList(recent);
      await prefs.setString(_recentSchemesKey, recentJson);
    }
  }
}
