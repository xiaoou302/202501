import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_stats.dart';
import '../models/artifact_model.dart';
import '../models/level_config.dart';
import '../models/level_model.dart';

class PlayerDataService {
  static final PlayerDataService _instance = PlayerDataService._internal();
  factory PlayerDataService() => _instance;
  PlayerDataService._internal();

  SharedPreferences? _prefs;
  PlayerStats? _cachedStats;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 获取玩家统计数据
  Future<PlayerStats> getPlayerStats() async {
    if (_cachedStats != null) return _cachedStats!;
    
    await init();
    
    final totalWins = _prefs?.getInt('total_wins') ?? 0;
    final currentStreak = _prefs?.getInt('current_streak') ?? 0;
    final longestStreak = _prefs?.getInt('longest_streak') ?? 0;
    final totalPlayTimeSeconds = _prefs?.getInt('total_play_time') ?? 0;
    final totalLevelsPlayed = _prefs?.getInt('total_levels_played') ?? 0;
    final unlockedArtifacts = _prefs?.getStringList('unlocked_artifacts') ?? [];
    
    // 计算平均时间
    final averageTime = totalLevelsPlayed > 0
        ? Duration(seconds: totalPlayTimeSeconds ~/ totalLevelsPlayed)
        : Duration.zero;
    
    // 计算完成百分比
    final completedLevels = _getCompletedLevelsCount();
    final totalLevels = LevelData.levels.length;
    final completionPercentage = totalLevels > 0 
        ? (completedLevels / totalLevels * 100) 
        : 0.0;
    
    // 获取关卡进度
    final levelProgress = _getLevelProgress();
    
    _cachedStats = PlayerStats(
      playerId: 'player_1',
      totalWins: totalWins,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalPlayTime: Duration(seconds: totalPlayTimeSeconds),
      averageTimePerLevel: averageTime,
      completionPercentage: completionPercentage,
      unlockedArtifacts: unlockedArtifacts,
      levelProgress: levelProgress,
    );
    
    return _cachedStats!;
  }

  // 获取已完成关卡数量
  int _getCompletedLevelsCount() {
    int count = 0;
    for (var level in LevelData.levels) {
      final completed = _prefs?.getBool('level_${level.id}_completed') ?? false;
      if (completed) count++;
    }
    return count;
  }

  // 获取关卡进度详情
  Map<String, LevelProgress> _getLevelProgress() {
    final Map<String, LevelProgress> progress = {};
    
    for (var level in LevelData.levels) {
      final attempts = _prefs?.getInt('level_${level.id}_attempts') ?? 0;
      final completed = _prefs?.getBool('level_${level.id}_completed') ?? false;
      final bestTimeSeconds = _prefs?.getInt('level_${level.id}_best_time');
      final stars = _prefs?.getInt('level_${level.id}_stars') ?? 0;
      final lastPlayedMs = _prefs?.getInt('level_${level.id}_last_played');
      
      progress[level.id] = LevelProgress(
        attempts: attempts,
        completed: completed,
        bestTime: bestTimeSeconds != null ? Duration(seconds: bestTimeSeconds) : null,
        stars: stars,
        lastPlayed: lastPlayedMs != null 
            ? DateTime.fromMillisecondsSinceEpoch(lastPlayedMs)
            : DateTime.now(),
      );
    }
    
    return progress;
  }

  // 记录关卡完成
  Future<void> recordLevelCompletion({
    required String levelId,
    required Duration time,
    required int moves,
    required int stars,
  }) async {
    await init();
    
    // 更新关卡数据
    await _prefs?.setBool('level_${levelId}_completed', true);
    await _prefs?.setInt('level_${levelId}_stars', stars);
    await _prefs?.setInt('level_${levelId}_last_played', DateTime.now().millisecondsSinceEpoch);
    
    // 更新最佳时间
    final currentBest = _prefs?.getInt('level_${levelId}_best_time');
    if (currentBest == null || time.inSeconds < currentBest) {
      await _prefs?.setInt('level_${levelId}_best_time', time.inSeconds);
    }
    
    // 更新尝试次数
    final attempts = (_prefs?.getInt('level_${levelId}_attempts') ?? 0) + 1;
    await _prefs?.setInt('level_${levelId}_attempts', attempts);
    
    // 更新总胜利次数
    final totalWins = (_prefs?.getInt('total_wins') ?? 0) + 1;
    await _prefs?.setInt('total_wins', totalWins);
    
    // 更新连胜
    final currentStreak = (_prefs?.getInt('current_streak') ?? 0) + 1;
    await _prefs?.setInt('current_streak', currentStreak);
    
    final longestStreak = _prefs?.getInt('longest_streak') ?? 0;
    if (currentStreak > longestStreak) {
      await _prefs?.setInt('longest_streak', currentStreak);
    }
    
    // 更新总游戏时间
    final totalPlayTime = (_prefs?.getInt('total_play_time') ?? 0) + time.inSeconds;
    await _prefs?.setInt('total_play_time', totalPlayTime);
    
    // 更新总关卡数
    final totalLevelsPlayed = (_prefs?.getInt('total_levels_played') ?? 0) + 1;
    await _prefs?.setInt('total_levels_played', totalLevelsPlayed);
    
    // 检查神器解锁
    await _checkArtifactUnlocks();
    
    _cachedStats = null; // 清除缓存
  }

  // 记录关卡失败
  Future<void> recordLevelAttempt(String levelId) async {
    await init();
    
    final attempts = (_prefs?.getInt('level_${levelId}_attempts') ?? 0) + 1;
    await _prefs?.setInt('level_${levelId}_attempts', attempts);
    await _prefs?.setInt('level_${levelId}_last_played', DateTime.now().millisecondsSinceEpoch);
    
    // 重置连胜
    await _prefs?.setInt('current_streak', 0);
    
    _cachedStats = null;
  }

  // 检查并解锁神器
  Future<void> _checkArtifactUnlocks() async {
    final stats = await getPlayerStats();
    final unlockedArtifacts = List<String>.from(stats.unlockedArtifacts);
    
    // Velocity: 完成任意关卡在3分钟内
    if (!unlockedArtifacts.contains('velocity')) {
      for (var level in LevelData.levels) {
        final bestTime = stats.levelProgress[level.id]?.bestTime;
        if (bestTime != null && bestTime.inMinutes < 3) {
          unlockedArtifacts.add('velocity');
          break;
        }
      }
    }
    
    // Eternal: 连胜5次
    if (!unlockedArtifacts.contains('eternal') && stats.currentStreak >= 5) {
      unlockedArtifacts.add('eternal');
    }
    
    // Precision: 完成所有关卡获得3星
    if (!unlockedArtifacts.contains('precision')) {
      bool allThreeStars = true;
      for (var level in LevelData.levels) {
        final stars = stats.levelProgress[level.id]?.stars ?? 0;
        if (stars < 3) {
          allThreeStars = false;
          break;
        }
      }
      if (allThreeStars && LevelData.levels.isNotEmpty) {
        unlockedArtifacts.add('precision');
      }
    }
    
    // Chaos: 完成困难难度关卡
    if (!unlockedArtifacts.contains('chaos')) {
      for (var level in LevelData.levels) {
        if (level.difficulty == LevelDifficulty.hard || 
            level.difficulty == LevelDifficulty.expert) {
          final completed = stats.levelProgress[level.id]?.completed ?? false;
          if (completed) {
            unlockedArtifacts.add('chaos');
            break;
          }
        }
      }
    }
    
    // Order: 完成所有关卡
    if (!unlockedArtifacts.contains('order')) {
      bool allCompleted = true;
      for (var level in LevelData.levels) {
        final completed = stats.levelProgress[level.id]?.completed ?? false;
        if (!completed) {
          allCompleted = false;
          break;
        }
      }
      if (allCompleted && LevelData.levels.isNotEmpty) {
        unlockedArtifacts.add('order');
      }
    }
    
    await _prefs?.setStringList('unlocked_artifacts', unlockedArtifacts);
  }

  // 获取所有神器
  List<ArtifactModel> getAllArtifacts(List<String> unlockedIds) {
    return [
      ArtifactModel(
        id: 'velocity',
        name: 'Velocity',
        description: 'Complete any level in under 3 minutes',
        type: ArtifactType.velocity,
        isUnlocked: unlockedIds.contains('velocity'),
        icon: Icons.bolt,
        accentColor: const Color(0xFFFFD700),
        unlockConditions: ['Complete a level in < 3 minutes'],
      ),
      ArtifactModel(
        id: 'eternal',
        name: 'Eternal',
        description: 'Achieve a 5-win streak',
        type: ArtifactType.eternal,
        isUnlocked: unlockedIds.contains('eternal'),
        icon: Icons.all_inclusive,
        accentColor: const Color(0xFF00CED1),
        unlockConditions: ['Win 5 levels in a row'],
      ),
      ArtifactModel(
        id: 'precision',
        name: 'Precision',
        description: 'Get 3 stars on all levels',
        type: ArtifactType.precision,
        isUnlocked: unlockedIds.contains('precision'),
        icon: Icons.star,
        accentColor: const Color(0xFFFF69B4),
        unlockConditions: ['Earn 3 stars on every level'],
      ),
      ArtifactModel(
        id: 'chaos',
        name: 'Chaos',
        description: 'Complete a hard or expert level',
        type: ArtifactType.chaos,
        isUnlocked: unlockedIds.contains('chaos'),
        icon: Icons.flash_on,
        accentColor: const Color(0xFFFF4500),
        unlockConditions: ['Beat a Hard/Expert level'],
      ),
      ArtifactModel(
        id: 'order',
        name: 'Order',
        description: 'Complete all levels',
        type: ArtifactType.order,
        isUnlocked: unlockedIds.contains('order'),
        icon: Icons.check_circle,
        accentColor: const Color(0xFF9370DB),
        unlockConditions: ['Complete every level'],
      ),
    ];
  }

  // 清除所有数据（用于测试）
  Future<void> clearAllData() async {
    await init();
    await _prefs?.clear();
    _cachedStats = null;
  }
}
