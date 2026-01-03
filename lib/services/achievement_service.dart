import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement_model.dart';
import '../models/level_config.dart';
import '../models/level_model.dart';
import 'player_data_service.dart';

class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  SharedPreferences? _prefs;
  final PlayerDataService _playerData = PlayerDataService();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 获取所有成就定义
  List<AchievementModel> getAllAchievements() {
    return [
      // 新手成就
      AchievementModel(
        id: 'first_win',
        name: 'First Victory',
        description: 'Complete your first level',
        category: AchievementCategory.beginner,
        rarity: AchievementRarity.common,
        icon: Icons.flag,
        color: const Color(0xFF4CAF50),
        points: 10,
        requirement: 'Win 1 level',
        targetValue: 1,
      ),
      AchievementModel(
        id: 'tutorial_complete',
        name: 'Tutorial Master',
        description: 'Complete the tutorial level',
        category: AchievementCategory.beginner,
        rarity: AchievementRarity.common,
        icon: Icons.school,
        color: const Color(0xFF2196F3),
        points: 10,
        requirement: 'Complete Level 1',
        targetValue: 1,
      ),
      AchievementModel(
        id: 'five_wins',
        name: 'Rising Star',
        description: 'Win 5 levels',
        category: AchievementCategory.beginner,
        rarity: AchievementRarity.common,
        icon: Icons.star_half,
        color: const Color(0xFF03A9F4),
        points: 25,
        requirement: 'Win 5 levels',
        targetValue: 5,
      ),
      
      // 大师成就
      AchievementModel(
        id: 'all_levels',
        name: 'Completionist',
        description: 'Complete all levels',
        category: AchievementCategory.master,
        rarity: AchievementRarity.epic,
        icon: Icons.emoji_events,
        color: const Color(0xFFFF9800),
        points: 100,
        requirement: 'Complete all 6 levels',
        targetValue: 6,
      ),
      AchievementModel(
        id: 'perfect_game',
        name: 'Perfectionist',
        description: 'Get 3 stars on all levels',
        category: AchievementCategory.perfect,
        rarity: AchievementRarity.legendary,
        icon: Icons.stars,
        color: const Color(0xFFFFD700),
        points: 200,
        requirement: 'Earn 3 stars on every level',
        targetValue: 18, // 6 levels * 3 stars
      ),
      AchievementModel(
        id: 'expert_clear',
        name: 'Expert Solver',
        description: 'Complete an expert level',
        category: AchievementCategory.master,
        rarity: AchievementRarity.rare,
        icon: Icons.military_tech,
        color: const Color(0xFF9C27B0),
        points: 50,
        requirement: 'Beat an Expert difficulty level',
        targetValue: 1,
      ),
      
      // 速度成就
      AchievementModel(
        id: 'speed_demon',
        name: 'Speed Demon',
        description: 'Complete a level in under 2 minutes',
        category: AchievementCategory.speed,
        rarity: AchievementRarity.rare,
        icon: Icons.flash_on,
        color: const Color(0xFFFF5722),
        points: 50,
        requirement: 'Finish any level in < 2 minutes',
        targetValue: 120, // seconds
      ),
      AchievementModel(
        id: 'lightning_fast',
        name: 'Lightning Fast',
        description: 'Complete a level in under 1 minute',
        category: AchievementCategory.speed,
        rarity: AchievementRarity.epic,
        icon: Icons.bolt,
        color: const Color(0xFFFFEB3B),
        points: 100,
        requirement: 'Finish any level in < 1 minute',
        targetValue: 60, // seconds
      ),
      
      // 连胜成就
      AchievementModel(
        id: 'win_streak_3',
        name: 'On Fire',
        description: 'Win 3 levels in a row',
        category: AchievementCategory.special,
        rarity: AchievementRarity.common,
        icon: Icons.local_fire_department,
        color: const Color(0xFFFF6B6B),
        points: 30,
        requirement: 'Win streak of 3',
        targetValue: 3,
      ),
      AchievementModel(
        id: 'win_streak_5',
        name: 'Unstoppable',
        description: 'Win 5 levels in a row',
        category: AchievementCategory.special,
        rarity: AchievementRarity.rare,
        icon: Icons.whatshot,
        color: const Color(0xFFFF4500),
        points: 50,
        requirement: 'Win streak of 5',
        targetValue: 5,
      ),
      AchievementModel(
        id: 'win_streak_10',
        name: 'Legendary',
        description: 'Win 10 levels in a row',
        category: AchievementCategory.special,
        rarity: AchievementRarity.legendary,
        icon: Icons.auto_awesome,
        color: const Color(0xFFFF1744),
        points: 150,
        requirement: 'Win streak of 10',
        targetValue: 10,
      ),
      
      // 完美成就
      AchievementModel(
        id: 'three_star_first',
        name: 'Perfect Start',
        description: 'Get 3 stars on your first try',
        category: AchievementCategory.perfect,
        rarity: AchievementRarity.rare,
        icon: Icons.star_rate,
        color: const Color(0xFFFFC107),
        points: 50,
        requirement: 'Earn 3 stars on first attempt',
        targetValue: 1,
      ),
      AchievementModel(
        id: 'no_hints',
        name: 'Self Reliant',
        description: 'Complete 5 levels without using hints',
        category: AchievementCategory.perfect,
        rarity: AchievementRarity.epic,
        icon: Icons.psychology,
        color: const Color(0xFF00BCD4),
        points: 75,
        requirement: 'Win 5 levels without hints',
        targetValue: 5,
      ),
      
      // 特殊成就
      AchievementModel(
        id: 'night_owl',
        name: 'Night Owl',
        description: 'Play between midnight and 6 AM',
        category: AchievementCategory.special,
        rarity: AchievementRarity.rare,
        icon: Icons.nightlight,
        color: const Color(0xFF673AB7),
        points: 25,
        requirement: 'Play during night hours',
        targetValue: 1,
      ),
      AchievementModel(
        id: 'dedicated',
        name: 'Dedicated Player',
        description: 'Play for 3 days in a row',
        category: AchievementCategory.special,
        rarity: AchievementRarity.epic,
        icon: Icons.calendar_today,
        color: const Color(0xFF3F51B5),
        points: 100,
        requirement: 'Play 3 consecutive days',
        targetValue: 3,
      ),
    ];
  }

  // 获取玩家的成就进度
  Future<List<AchievementModel>> getPlayerAchievements() async {
    await init();
    final stats = await _playerData.getPlayerStats();
    final allAchievements = getAllAchievements();
    
    return allAchievements.map((achievement) {
      final isUnlocked = _prefs?.getBool('achievement_${achievement.id}') ?? false;
      final unlockedAtMs = _prefs?.getInt('achievement_${achievement.id}_unlocked_at');
      
      int currentValue = 0;
      double progress = 0.0;
      
      // 根据成就类型计算进度
      switch (achievement.id) {
        case 'first_win':
        case 'five_wins':
        case 'all_levels':
          currentValue = stats.totalWins;
          break;
        case 'tutorial_complete':
          currentValue = (stats.levelProgress['level_01']?.completed ?? false) ? 1 : 0;
          break;
        case 'perfect_game':
          currentValue = stats.levelProgress.values.fold(0, (sum, progress) => sum + progress.stars);
          break;
        case 'expert_clear':
          currentValue = LevelData.levels.where((level) {
            return (level.difficulty == LevelDifficulty.expert) &&
                   (stats.levelProgress[level.id]?.completed ?? false);
          }).length;
          break;
        case 'speed_demon':
        case 'lightning_fast':
          final fastestTime = stats.levelProgress.values
              .where((p) => p.bestTime != null)
              .map((p) => p.bestTime!.inSeconds)
              .fold<int?>(null, (min, time) => min == null || time < min ? time : min);
          currentValue = fastestTime ?? 999;
          progress = fastestTime != null && fastestTime <= achievement.targetValue ? 1.0 : 0.0;
          break;
        case 'win_streak_3':
        case 'win_streak_5':
        case 'win_streak_10':
          currentValue = stats.longestStreak;
          break;
        case 'three_star_first':
          currentValue = stats.levelProgress.values.where((p) => 
            p.attempts == 1 && p.stars == 3
          ).length;
          break;
        case 'no_hints':
          currentValue = _prefs?.getInt('no_hints_count') ?? 0;
          break;
        case 'night_owl':
          currentValue = _prefs?.getBool('played_at_night') == true ? 1 : 0;
          break;
        case 'dedicated':
          currentValue = _prefs?.getInt('consecutive_days') ?? 0;
          break;
      }
      
      // 计算进度（除了特殊情况）
      if (achievement.id != 'speed_demon' && achievement.id != 'lightning_fast') {
        progress = (currentValue / achievement.targetValue).clamp(0.0, 1.0);
      }
      
      return achievement.copyWith(
        isUnlocked: isUnlocked || progress >= 1.0,
        unlockedAt: unlockedAtMs != null 
            ? DateTime.fromMillisecondsSinceEpoch(unlockedAtMs)
            : null,
        progress: progress,
        currentValue: currentValue,
      );
    }).toList();
  }

  // 检查并解锁成就
  Future<List<AchievementModel>> checkAndUnlockAchievements() async {
    final achievements = await getPlayerAchievements();
    final newlyUnlocked = <AchievementModel>[];
    
    for (var achievement in achievements) {
      final wasUnlocked = _prefs?.getBool('achievement_${achievement.id}') ?? false;
      
      if (!wasUnlocked && achievement.progress >= 1.0) {
        await _prefs?.setBool('achievement_${achievement.id}', true);
        await _prefs?.setInt(
          'achievement_${achievement.id}_unlocked_at',
          DateTime.now().millisecondsSinceEpoch,
        );
        newlyUnlocked.add(achievement);
      }
    }
    
    return newlyUnlocked;
  }

  // 获取总成就点数
  Future<int> getTotalPoints() async {
    final achievements = await getPlayerAchievements();
    return achievements
        .where((a) => a.isUnlocked)
        .fold<int>(0, (sum, a) => sum + a.points);
  }

  // 获取成就统计
  Future<Map<String, int>> getAchievementStats() async {
    final achievements = await getPlayerAchievements();
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    final total = achievements.length;
    final points = await getTotalPoints();
    
    return {
      'unlocked': unlocked,
      'total': total,
      'points': points,
      'percentage': ((unlocked / total) * 100).round(),
    };
  }

  // 按稀有度分组
  Map<AchievementRarity, List<AchievementModel>> groupByRarity(
    List<AchievementModel> achievements,
  ) {
    final Map<AchievementRarity, List<AchievementModel>> grouped = {};
    
    for (var rarity in AchievementRarity.values) {
      grouped[rarity] = achievements.where((a) => a.rarity == rarity).toList();
    }
    
    return grouped;
  }

  // 按类别分组
  Map<AchievementCategory, List<AchievementModel>> groupByCategory(
    List<AchievementModel> achievements,
  ) {
    final Map<AchievementCategory, List<AchievementModel>> grouped = {};
    
    for (var category in AchievementCategory.values) {
      grouped[category] = achievements.where((a) => a.category == category).toList();
    }
    
    return grouped;
  }
}
