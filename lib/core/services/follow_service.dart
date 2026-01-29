import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowService {
  static final FollowService _instance = FollowService._internal();
  static FollowService get instance => _instance;

  final ValueNotifier<Set<String>> followedPostsNotifier = ValueNotifier({});
  static const String _storageKey = 'followed_posts';

  FollowService._internal() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList(_storageKey);
    if (stored != null) {
      followedPostsNotifier.value = stored.toSet();
    }
  }

  bool isFollowed(String postId) {
    return followedPostsNotifier.value.contains(postId);
  }

  Future<void> toggleFollow(String postId) async {
    final Set<String> current = Set.from(followedPostsNotifier.value);
    if (current.contains(postId)) {
      current.remove(postId);
    } else {
      current.add(postId);
    }
    
    // Update notifier immediately for UI responsiveness
    followedPostsNotifier.value = current;

    // Persist to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, current.toList());
  }
}
