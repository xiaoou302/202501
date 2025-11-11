import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FollowService {
  static const String _followedUsersKey = 'followed_users';

  // Get list of followed user IDs
  static Future<List<String>> getFollowedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_followedUsersKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => e as String).toList();
  }

  // Check if user is followed
  static Future<bool> isFollowing(String userId) async {
    final followedUsers = await getFollowedUsers();
    return followedUsers.contains(userId);
  }

  // Follow a user
  static Future<void> followUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final followedUsers = await getFollowedUsers();

    if (!followedUsers.contains(userId)) {
      followedUsers.add(userId);
      await prefs.setString(_followedUsersKey, jsonEncode(followedUsers));
    }
  }

  // Unfollow a user
  static Future<void> unfollowUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final followedUsers = await getFollowedUsers();

    followedUsers.remove(userId);
    await prefs.setString(_followedUsersKey, jsonEncode(followedUsers));
  }

  // Toggle follow status
  static Future<bool> toggleFollow(String userId) async {
    final isCurrentlyFollowing = await isFollowing(userId);

    if (isCurrentlyFollowing) {
      await unfollowUser(userId);
      return false;
    } else {
      await followUser(userId);
      return true;
    }
  }
}
