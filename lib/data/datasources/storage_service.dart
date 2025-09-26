import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soli/data/models/memory_model.dart';
import 'package:soli/data/models/proposal_plan_model.dart';
import 'package:soli/data/models/user_model.dart';

/// 本地存储服务
class StorageService {
  static const String _userKey = 'user_data';
  static const String _memoriesKey = 'memories_data';
  static const String _proposalsKey = 'proposals_data';
  static const String _chatMessagesKey = 'chat_messages';
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _likedMemoriesKey = 'liked_memories_data';
  static const String _memoryLikeCountsKey = 'memory_like_counts_data';

  // 单例模式
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  // 初始化存储
  Future<void> initializeStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // 检查是否是首次启动
    if (!prefs.containsKey(_isFirstLaunchKey)) {
      // 标记为非首次启动
      await prefs.setBool(_isFirstLaunchKey, false);

      // 初始化默认用户数据
      final defaultUser = UserModel(
        id: 'user1',
        name: '用户',
        avatarUrl: null,
        memoryCount: 0,
        albumCount: 0,
        proposalCount: 0,
      );

      await saveUser(defaultUser);

      // 初始化空的回忆和方案列表
      await prefs.setStringList(_memoriesKey, []);
      await prefs.setStringList(_proposalsKey, []);

      // 初始化AI欢迎消息
      await saveChatMessages([
        {
          'isAi': true,
          'content': '你好，我是Soli的情感助手。今天有什么想分享的吗？无论是快乐还是烦恼，我都在这里倾听。',
        },
      ]);
    }
  }

  // 保存用户数据
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // 获取用户数据
  Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);

    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    } else {
      // 如果没有数据，返回默认用户
      return UserModel(
        id: 'user1',
        name: '用户',
        avatarUrl: null,
        memoryCount: 0,
        albumCount: 0,
        proposalCount: 0,
      );
    }
  }

  // 保存回忆列表
  Future<void> saveMemories(List<MemoryModel> memories) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> memoryJsonList = memories
        .map((memory) => jsonEncode(memory.toJson()))
        .toList();
    await prefs.setStringList(_memoriesKey, memoryJsonList);
  }

  // 获取回忆列表
  Future<List<MemoryModel>> getMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final memoryJsonList = prefs.getStringList(_memoriesKey);

    if (memoryJsonList != null && memoryJsonList.isNotEmpty) {
      return memoryJsonList
          .map((json) => MemoryModel.fromJson(jsonDecode(json)))
          .toList();
    } else {
      // 如果没有数据，返回空列表
      return [];
    }
  }

  // 添加新回忆
  Future<void> addMemory(MemoryModel memory) async {
    final memories = await getMemories();
    memories.add(memory);
    await saveMemories(memories);
  }

  // 这个方法已被替换为 saveProposalPlans

  // 获取求婚方案列表
  Future<List<ProposalPlanModel>> getProposalPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final proposalJsonList = prefs.getStringList(_proposalsKey);

    if (proposalJsonList != null && proposalJsonList.isNotEmpty) {
      return proposalJsonList
          .map((json) => ProposalPlanModel.fromJson(jsonDecode(json)))
          .toList();
    } else {
      // 如果没有数据，返回空列表
      return [];
    }
  }

  // 添加新求婚方案
  Future<void> addProposalPlan(ProposalPlanModel proposal) async {
    final proposals = await getProposalPlans();
    proposals.add(proposal);
    await saveProposalPlans(proposals);
  }

  // 保存求婚方案列表
  Future<void> saveProposalPlans(List<ProposalPlanModel> proposals) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> proposalJsonList = proposals
        .map((proposal) => jsonEncode(proposal.toJson()))
        .toList();
    await prefs.setStringList(_proposalsKey, proposalJsonList);
  }

  // 保存聊天消息
  Future<void> saveChatMessages(List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatMessagesKey, jsonEncode(messages));
  }

  // 获取聊天消息
  Future<List<Map<String, dynamic>>> getChatMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString(_chatMessagesKey);

    if (messagesJson != null) {
      final List<dynamic> decodedList = jsonDecode(messagesJson);
      return decodedList.cast<Map<String, dynamic>>();
    } else {
      // 如果没有数据，返回AI欢迎消息
      return [
        {
          'isAi': true,
          'content': '你好，我是Soli的情感助手。今天有什么想分享的吗？无论是快乐还是烦恼，我都在这里倾听。',
        },
      ];
    }
  }

  // 添加新聊天消息
  Future<void> addChatMessage(Map<String, dynamic> message) async {
    final messages = await getChatMessages();
    messages.add(message);
    await saveChatMessages(messages);
  }

  // 保存点赞状态
  Future<void> saveLikedMemories(Map<String, bool> likedMemories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_likedMemoriesKey, jsonEncode(likedMemories));
  }

  // 获取点赞状态
  Future<Map<String, bool>> getLikedMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final likedMemoriesJson = prefs.getString(_likedMemoriesKey);

    if (likedMemoriesJson != null) {
      final Map<String, dynamic> decodedMap = jsonDecode(likedMemoriesJson);
      return decodedMap.map((key, value) => MapEntry(key, value as bool));
    } else {
      // 如果没有数据，返回空Map
      return {};
    }
  }

  // 更新单个记忆的点赞状态
  Future<void> updateMemoryLikeStatus(String memoryId, bool isLiked) async {
    final likedMemories = await getLikedMemories();
    likedMemories[memoryId] = isLiked;
    await saveLikedMemories(likedMemories);
  }

  // 保存点赞数量
  Future<void> saveLikeCounts(Map<String, int> likeCounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_memoryLikeCountsKey, jsonEncode(likeCounts));
  }

  // 获取点赞数量
  Future<Map<String, int>> getLikeCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final likeCountsJson = prefs.getString(_memoryLikeCountsKey);

    if (likeCountsJson != null) {
      final Map<String, dynamic> decodedMap = jsonDecode(likeCountsJson);
      return decodedMap.map((key, value) => MapEntry(key, value as int));
    } else {
      // 如果没有数据，返回空Map
      return {};
    }
  }

  // 更新单个记忆的点赞数量
  Future<void> updateMemoryLikeCount(String memoryId, int likeCount) async {
    final likeCounts = await getLikeCounts();
    likeCounts[memoryId] = likeCount;
    await saveLikeCounts(likeCounts);
  }

  // 同时更新点赞状态和数量
  Future<void> updateMemoryLike(
    String memoryId,
    bool isLiked,
    int likeCount,
  ) async {
    await updateMemoryLikeStatus(memoryId, isLiked);
    await updateMemoryLikeCount(memoryId, likeCount);
  }
}
