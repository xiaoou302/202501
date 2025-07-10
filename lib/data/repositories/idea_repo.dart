import 'package:uuid/uuid.dart';
import '../models/idea_model.dart';
import '../datasources/local_db.dart';

/// 灵感数据仓库
class IdeaRepository {
  final _uuid = const Uuid();
  List<IdeaModel> _ideas = [];
  bool _isLoaded = false;

  /// 加载所有灵感
  Future<List<IdeaModel>> loadIdeas() async {
    if (_isLoaded) {
      return _ideas;
    }

    final ideasJson = await LocalDatabase.getIdeas();
    _ideas = ideasJson.map((json) => IdeaModel.fromJson(json)).toList();
    _isLoaded = true;
    return _ideas;
  }

  /// 获取所有灵感
  Future<List<IdeaModel>> getAllIdeas() async {
    return await loadIdeas();
  }

  /// 根据标签筛选灵感
  Future<List<IdeaModel>> getIdeasByTag(String tag) async {
    final ideas = await loadIdeas();
    return ideas.where((idea) => idea.tags.contains(tag)).toList();
  }

  /// 添加灵感
  Future<IdeaModel> addIdea(
    String title,
    String content,
    List<String> tags,
  ) async {
    final ideas = await loadIdeas();

    final firstChapter = ChapterModel(
      title: '第一章',
      content: content,
      createdAt: DateTime.now(),
    );

    final newIdea = IdeaModel(
      id: _uuid.v4(),
      title: title,
      chapters: [firstChapter],
      tags: tags,
      createdAt: DateTime.now(),
    );

    _ideas = [...ideas, newIdea];
    await _saveIdeas();

    return newIdea;
  }

  /// 更新灵感
  Future<IdeaModel> updateIdea(IdeaModel idea) async {
    final ideas = await loadIdeas();

    _ideas = ideas.map((i) => i.id == idea.id ? idea : i).toList();
    await _saveIdeas();

    return idea;
  }

  /// 删除灵感
  Future<void> deleteIdea(String id) async {
    final ideas = await loadIdeas();

    _ideas = ideas.where((idea) => idea.id != id).toList();
    await _saveIdeas();
  }

  /// 保存灵感到本地存储
  Future<void> _saveIdeas() async {
    final ideasJson = _ideas.map((idea) => idea.toJson()).toList();
    await LocalDatabase.saveIdeas(ideasJson);
  }

  /// 清除所有灵感
  Future<void> clearAllIdeas() async {
    _ideas = [];
    _isLoaded = false;
    await _saveIdeas();
  }
}
