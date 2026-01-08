import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to manage saved/bookmarked styles with persistence
class SavedStylesNotifier extends StateNotifier<Set<String>> {
  SavedStylesNotifier() : super({}) {
    _loadSavedStyles();
  }

  static const String _storageKey = 'saved_styles';

  Future<void> _loadSavedStyles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList(_storageKey) ?? [];
      state = savedList.toSet();
    } catch (e) {
      // If loading fails, start with empty set
      state = {};
    }
  }

  Future<void> _saveSavedStyles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, state.toList());
    } catch (e) {
      // Handle save error silently
    }
  }

  Future<void> toggleSave(String imageId) async {
    if (state.contains(imageId)) {
      state = {...state}..remove(imageId);
    } else {
      state = {...state, imageId};
    }
    await _saveSavedStyles();
  }

  bool isSaved(String imageId) {
    return state.contains(imageId);
  }
}

final savedStylesProvider = StateNotifierProvider<SavedStylesNotifier, Set<String>>((ref) {
  return SavedStylesNotifier();
});
