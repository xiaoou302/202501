import 'package:soli/data/datasources/storage_service.dart';
import 'package:soli/data/models/memory_model.dart';
import 'package:uuid/uuid.dart';

/// 回忆数据仓库
class MemoryRepository {
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  // 获取所有回忆
  Future<List<MemoryModel>> getAllMemories() async {
    return await _storageService.getMemories();
  }

  // 按标签筛选回忆
  Future<List<MemoryModel>> getMemoriesByTag(String tag) async {
    final memories = await _storageService.getMemories();

    if (tag == '所有回忆') {
      return memories;
    } else {
      return memories.where((memory) => memory.tags.contains(tag)).toList();
    }
  }

  // 添加新回忆
  Future<void> addMemory({
    required String title,
    required String imageUrl,
    required DateTime date,
    required List<String> tags,
    String? description,
  }) async {
    final newMemory = MemoryModel(
      id: _uuid.v4(),
      title: title,
      imageUrl: imageUrl,
      date: date,
      tags: tags,
      description: description,
    );

    await _storageService.addMemory(newMemory);

    // 更新用户统计数据
    final user = await _storageService.getUser();
    final updatedUser = user.copyWith(memoryCount: user.memoryCount + 1);
    await _storageService.saveUser(updatedUser);
  }

  // 获取回忆详情
  Future<MemoryModel?> getMemoryById(String id) async {
    final memories = await _storageService.getMemories();
    try {
      return memories.firstWhere((memory) => memory.id == id);
    } catch (e) {
      return null;
    }
  }

  // 更新回忆
  Future<void> updateMemory(MemoryModel updatedMemory) async {
    final memories = await _storageService.getMemories();
    final index = memories.indexWhere(
      (memory) => memory.id == updatedMemory.id,
    );

    if (index != -1) {
      memories[index] = updatedMemory;
      await _storageService.saveMemories(memories);
    }
  }

  // 删除回忆
  Future<void> deleteMemory(String id) async {
    final memories = await _storageService.getMemories();
    final filteredMemories = memories
        .where((memory) => memory.id != id)
        .toList();

    if (filteredMemories.length < memories.length) {
      await _storageService.saveMemories(filteredMemories);

      // 更新用户统计数据
      final user = await _storageService.getUser();
      final updatedUser = user.copyWith(memoryCount: user.memoryCount - 1);
      await _storageService.saveUser(updatedUser);
    }
  }
}
