import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/idea_model.dart';

class IdeaRepository {
  static const String _storageKey = 'ideas';
  final SharedPreferences _prefs;

  IdeaRepository(this._prefs);

  /// 获取所有灵感
  Future<List<IdeaModel>> getAllIdeas() async {
    final String? jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => IdeaModel.fromJson(json))
          .where((idea) => idea.isValid())
          .toList();
    } catch (e) {
      print('Error loading ideas: $e');
      return [];
    }
  }

  /// 保存所有灵感
  Future<bool> saveAllIdeas(List<IdeaModel> ideas) async {
    try {
      final String jsonString =
          json.encode(ideas.map((e) => e.toJson()).toList());
      return await _prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving ideas: $e');
      return false;
    }
  }

  /// 添加灵感
  Future<bool> addIdea(IdeaModel idea) async {
    if (!idea.isValid()) return false;

    final ideas = await getAllIdeas();
    if (ideas.any((e) => e.id == idea.id)) return false;

    ideas.insert(0, idea);
    return saveAllIdeas(ideas);
  }

  /// 更新灵感
  Future<bool> updateIdea(IdeaModel idea) async {
    if (!idea.isValid()) return false;

    final ideas = await getAllIdeas();
    final index = ideas.indexWhere((e) => e.id == idea.id);
    if (index == -1) return false;

    ideas[index] = idea.copyWith(updatedAt: DateTime.now());
    return saveAllIdeas(ideas);
  }

  /// 删除灵感
  Future<bool> deleteIdea(String id) async {
    final ideas = await getAllIdeas();
    final index = ideas.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    ideas.removeAt(index);
    return saveAllIdeas(ideas);
  }

  /// 根据标签搜索灵感
  Future<List<IdeaModel>> searchByTag(String tag) async {
    final ideas = await getAllIdeas();
    return ideas.where((idea) => idea.tags.contains(tag)).toList();
  }

  /// 根据关键词搜索灵感
  Future<List<IdeaModel>> searchByKeyword(String keyword) async {
    if (keyword.isEmpty) return getAllIdeas();

    final ideas = await getAllIdeas();
    final lowercaseKeyword = keyword.toLowerCase();
    return ideas.where((idea) {
      return idea.title.toLowerCase().contains(lowercaseKeyword) ||
          idea.chapters.any((chapter) =>
              chapter.title.toLowerCase().contains(lowercaseKeyword) ||
              chapter.content.toLowerCase().contains(lowercaseKeyword)) ||
          idea.tags.any((tag) => tag.toLowerCase().contains(lowercaseKeyword));
    }).toList();
  }
}
