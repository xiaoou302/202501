import 'package:soli/core/services/ai_service.dart';
import 'package:soli/data/datasources/hot_topics_data.dart';
import 'package:soli/data/datasources/storage_service.dart';
import 'package:soli/data/models/community_post_model.dart';
import 'package:soli/data/models/hot_topic_model.dart';

/// 社区数据仓库
class CommunityRepository {
  final StorageService _storageService = StorageService();
  final AIService _aiService = AIService();

  // 获取聊天消息
  Future<List<Map<String, dynamic>>> getChatMessages() async {
    return await _storageService.getChatMessages();
  }

  // 获取社区帖子
  Future<List<CommunityPostModel>> getCommunityPosts() async {
    // 目前仅返回空列表，未来可从存储服务获取
    return [];
  }

  // 获取随机热门话题
  List<HotTopicModel> getRandomHotTopics({int count = 6}) {
    return HotTopicsData.getRandomTopics(count: count);
  }

  // 按分类获取话题
  List<HotTopicModel> getTopicsByCategory(String category) {
    return HotTopicsData.getTopicsByCategory(category);
  }

  // 获取热门话题（按人气排序）
  List<HotTopicModel> getPopularTopics({int count = 10}) {
    return HotTopicsData.getPopularTopics(count: count);
  }

  // 获取最新话题
  List<HotTopicModel> getNewTopics() {
    return HotTopicsData.getNewTopics();
  }

  // 清空聊天消息
  Future<void> clearChatMessages() async {
    // 清空聊天记录，保留AI欢迎消息
    await _storageService.saveChatMessages([]);
  }

  // 保存聊天消息列表
  Future<void> saveChatMessages(List<Map<String, dynamic>> messages) async {
    await _storageService.saveChatMessages(messages);
  }

  // 添加用户消息
  Future<void> addUserMessage(String content) async {
    await _storageService.addChatMessage({'isAi': false, 'content': content});
  }

  // 添加AI回复
  Future<void> addAiReply(String content) async {
    await _storageService.addChatMessage({'isAi': true, 'content': content});
  }

  // 生成AI回复
  Future<String> generateAiReply(String userMessage) async {
    try {
      // 获取历史聊天记录
      final chatHistory = await getChatMessages();

      // 检查消息是否与恋爱婚姻相关
      if (!_aiService.isRelationshipTopic(userMessage)) {
        final response =
            'I\'m sorry, I can only answer questions related to relationships and marriage. If you have any questions about emotional relationships, I\'d be happy to help.';
        await addAiReply(response);
        return response;
      }

      // 发送消息到AI服务并获取回复
      final response = await _aiService.GetPrevNameBase(userMessage, chatHistory);

      // 保存AI回复
      await addAiReply(response);

      return response;
    } catch (e) {
      print('生成AI回复错误: $e');
      // 出错时使用备用回复
      final fallbackResponse =
          'I\'m sorry, I can\'t answer your question at the moment. Please try again later or rephrase your question.';
      await addAiReply(fallbackResponse);
      return fallbackResponse;
    }
  }
}
