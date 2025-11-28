import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String _currentUserKey = 'current_user';

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    
    if (userJson == null) return null;
    
    return User.fromJson(json.decode(userJson));
  }

  Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(user.toJson());
    await prefs.setString(_currentUserKey, encoded);
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    final user = await getCurrentUser();
    if (user == null) return;

    final updatedUser = User(
      id: user.id,
      username: user.username,
      displayName: displayName ?? user.displayName,
      bio: bio ?? user.bio,
      avatarUrl: avatarUrl ?? user.avatarUrl,
      followersCount: user.followersCount,
      followingCount: user.followingCount,
      posesCount: user.posesCount,
      joinDate: user.joinDate,
    );

    await saveCurrentUser(updatedUser);
  }
}
