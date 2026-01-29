import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionService {
  static final CollectionService _instance = CollectionService._internal();
  static CollectionService get instance => _instance;

  final ValueNotifier<Set<String>> collectedPostsNotifier = ValueNotifier({});
  static const String _storageKey = 'collected_posts';

  CollectionService._internal() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList(_storageKey);
    if (stored != null) {
      collectedPostsNotifier.value = stored.toSet();
    }
  }

  bool isCollected(String postId) {
    return collectedPostsNotifier.value.contains(postId);
  }

  Future<void> toggleCollection(String postId) async {
    final Set<String> current = Set.from(collectedPostsNotifier.value);
    if (current.contains(postId)) {
      current.remove(postId);
    } else {
      current.add(postId);
    }
    
    // Update notifier immediately for UI responsiveness
    collectedPostsNotifier.value = current;

    // Persist to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, current.toList());
  }
}
