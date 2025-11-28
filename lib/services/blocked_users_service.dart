import 'package:shared_preferences/shared_preferences.dart';

class BlockedUsersService {
  static const String _blockedUsersKey = 'blocked_users';
  
  // 单例模式
  static final BlockedUsersService _instance = BlockedUsersService._internal();
  factory BlockedUsersService() => _instance;
  BlockedUsersService._internal();
  
  // 获取所有被屏蔽的用户ID列表
  Future<Set<String>> getBlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final blockedList = prefs.getStringList(_blockedUsersKey) ?? [];
    return blockedList.toSet();
  }
  
  // 屏蔽用户
  Future<void> blockUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final blockedUsers = await getBlockedUsers();
    blockedUsers.add(userId);
    await prefs.setStringList(_blockedUsersKey, blockedUsers.toList());
  }
  
  // 取消屏蔽用户
  Future<void> unblockUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final blockedUsers = await getBlockedUsers();
    blockedUsers.remove(userId);
    await prefs.setStringList(_blockedUsersKey, blockedUsers.toList());
  }
  
  // 检查用户是否被屏蔽
  Future<bool> isUserBlocked(String userId) async {
    final blockedUsers = await getBlockedUsers();
    return blockedUsers.contains(userId);
  }
  
  // 清空所有屏蔽的用户
  Future<void> clearAllBlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_blockedUsersKey);
  }
}
