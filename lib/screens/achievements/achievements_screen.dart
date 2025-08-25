import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../models/achievement.dart';
import '../../services/storage.dart';

/// 成就界面
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    //sssss
    super.initState();
    _loadAchievements();
  }

  // 加载成就
  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load achievements from storage
      List<Achievement> achievements =
          await StorageService.instance.loadAchievements();

      // If no achievements are stored yet, get the default list
      if (achievements.isEmpty) {
        achievements = Achievements.getAll();
      }

      // Load player stats to update achievement progress
      final playerStats = await StorageService.instance.loadPlayerStats();

      // Load levels to check completion status
      final levels = await StorageService.instance.loadLevels();

      // Update achievement progress based on player stats
      for (var achievement in achievements) {
        switch (achievement.id) {
          case 'first_contact':
            if (playerStats.totalPlexiMatches > 0) {
              achievement.isUnlocked = true;
              achievement.progress = 1.0;
            }
            break;

          case 'color_master':
            // Assuming half of eliminated units are from color matches
            int colorMatches = playerStats.totalUnitsEliminated ~/ 2;
            achievement.updateProgress(colorMatches);
            break;

          case 'shape_scholar':
            // Assuming half of eliminated units are from shape matches
            int shapeMatches = playerStats.totalUnitsEliminated ~/ 2;
            achievement.updateProgress(shapeMatches);
            break;

          case 'transmuter':
            // For transmuter achievement, we'll estimate based on perfect matches
            // since each perfect match grants a transmute ability
            achievement.updateProgress(playerStats.totalPlexiMatches);
            break;

          case 'chain_reaction':
            if (playerStats.longestComboChain >= 5) {
              achievement.isUnlocked = true;
              achievement.progress = 1.0;
            } else {
              achievement.progress = playerStats.longestComboChain / 5.0;
            }
            break;

          case 'perfectionist':
            // Check if any level was completed with 5+ moves remaining
            bool hasPerfectLevel = false;
            for (var level in levels) {
              if (level.starsEarned == 3) {
                // 3 stars typically means completed with moves remaining
                hasPerfectLevel = true;
                break;
              }
            }
            if (hasPerfectLevel) {
              achievement.isUnlocked = true;
              achievement.progress = 1.0;
            }
            break;

          case 'final_enlightenment':
            // Count completed levels
            int completedLevels = 0;
            for (var level in levels) {
              if (level.starsEarned > 0) {
                completedLevels++;
              }
            }
            achievement.updateProgress(completedLevels);
            break;
        }
      }

      // Check for newly unlocked achievements
      List<Achievement> newlyUnlocked = [];
      List<Achievement> previousAchievements =
          await StorageService.instance.loadAchievements();

      for (var achievement in achievements) {
        // Find the previous state of this achievement
        var previousState = previousAchievements.firstWhere(
          (a) => a.id == achievement.id,
          orElse: () => Achievement(
            id: achievement.id,
            title: achievement.title,
            description: achievement.description,
            icon: achievement.icon,
            isUnlocked: false,
            targetValue: achievement.targetValue,
          ),
        );

        // If it wasn't unlocked before but is now, add to newly unlocked list
        if (!previousState.isUnlocked && achievement.isUnlocked) {
          newlyUnlocked.add(achievement);
        }
      }

      // Save updated achievements back to storage
      await StorageService.instance.saveAchievements(achievements);

      setState(() {
        _achievements = achievements;
      });

      // Show notification for newly unlocked achievements
      for (var achievement in newlyUnlocked) {
        _showAchievementUnlockedNotification(achievement);
      }
    } catch (e) {
      print('Error loading achievements: $e');
      setState(() {
        _achievements = Achievements.getAll();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 返回按钮
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 16),

              // 标题
              const Center(
                child: Text('ACHIEVEMENTS', style: AppStyles.titleLarge),
              ),

              const SizedBox(height: 32),

              // 成就列表
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAccent,
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              0.7, // Reduced to give more vertical space
                        ),
                        itemCount: _achievements.length,
                        itemBuilder: (context, index) {
                          final achievement = _achievements[index];
                          return _buildAchievementItem(achievement);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建成就项
  Widget _buildAchievementItem(Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    final progress = achievement.progress;

    return Container(
      // Add padding to ensure proper spacing
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        children: [
          // 成就图标
          Container(
            width: 70, // Slightly smaller icon
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? (achievement.id == 'transmuter'
                      ? AppColors.secondaryAccent
                      : AppColors.primaryAccent)
                  : Colors.transparent,
              border: isUnlocked
                  ? null
                  : Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: (achievement.id == 'transmuter'
                                ? AppColors.secondaryAccent
                                : AppColors.primaryAccent)
                            .withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(
                _getIconData(achievement.icon),
                color: isUnlocked
                    ? (achievement.id == 'transmuter'
                        ? Colors.white
                        : AppColors.primaryDark)
                    : Colors.grey.withOpacity(0.5),
                size: 35, // Slightly smaller icon
              ),
            ),
          ),

          const SizedBox(height: 6), // Reduced spacing
          // 成就名称
          Text(
            achievement.title,
            style: TextStyle(
              color: isUnlocked ? Colors.white : Colors.grey.withOpacity(0.7),
              fontSize: 13, // Slightly smaller text
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1, // Limit to one line
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 3), // Reduced spacing
          // 成就描述
          Flexible(
            child: Text(
              achievement.description,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 11,
              ), // Smaller text
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 进度条
          if (!isUnlocked && progress > 0)
            Padding(
              padding: const EdgeInsets.only(top: 5), // Reduced padding
              child: SizedBox(
                height: 4, // Specify height for progress bar
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Show achievement unlocked notification
  void _showAchievementUnlockedNotification(Achievement achievement) {
    // Skip showing notification if the widget is no longer mounted
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: achievement.id == 'transmuter'
                    ? AppColors.secondaryAccent
                    : AppColors.primaryAccent,
                boxShadow: [
                  BoxShadow(
                    color: (achievement.id == 'transmuter'
                            ? AppColors.secondaryAccent
                            : AppColors.primaryAccent)
                        .withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                _getIconData(achievement.icon),
                color: achievement.id == 'transmuter'
                    ? Colors.white
                    : AppColors.primaryDark,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Achievement Unlocked!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    achievement.title,
                    style: TextStyle(
                      color: achievement.id == 'transmuter'
                          ? AppColors.secondaryAccent
                          : AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取图标数据
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'fa-atom':
        return Icons.blur_circular;
      case 'fa-palette':
        return Icons.palette;
      case 'fa-shapes':
        return Icons.category;
      case 'fa-exchange-alt':
        return Icons.swap_horiz;
      case 'fa-infinity':
        return Icons.all_inclusive;
      case 'fa-crown':
        return Icons.emoji_events;
      case 'fa-brain':
        return Icons.psychology;
      default:
        return Icons.star;
    }
  }
}
