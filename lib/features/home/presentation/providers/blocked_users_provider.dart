import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to manage blocked users with persistence
class BlockedUsersNotifier extends StateNotifier<Set<String>> {
  BlockedUsersNotifier() : super({}) {
    _loadBlockedUsers();
  }

  static const String _storageKey = 'blocked_users';

  Future<void> _loadBlockedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blockedList = prefs.getStringList(_storageKey) ?? [];
      state = blockedList.toSet();
    } catch (e) {
      // If loading fails, start with empty set
      state = {};
    }
  }

  Future<void> _saveBlockedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, state.toList());
    } catch (e) {
      // Handle save error silently
    }
  }

  Future<void> blockUser(String imageId) async {
    state = {...state, imageId};
    await _saveBlockedUsers();
  }

  Future<void> unblockUser(String imageId) async {
    state = {...state}..remove(imageId);
    await _saveBlockedUsers();
  }

  bool isBlocked(String imageId) {
    return state.contains(imageId);
  }
}

final blockedUsersProvider = StateNotifierProvider<BlockedUsersNotifier, Set<String>>((ref) {
  return BlockedUsersNotifier();
});
