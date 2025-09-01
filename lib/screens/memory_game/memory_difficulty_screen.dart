import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../widgets/common/neumorphic_card.dart';
import '../../services/level_service.dart';
import 'memory_game_screen.dart';

/// 记忆游戏难度选择页面
class MemoryDifficultyScreen extends StatefulWidget {
  const MemoryDifficultyScreen({super.key});

  @override
  State<MemoryDifficultyScreen> createState() => _MemoryDifficultyScreenState();
}

class _MemoryDifficultyScreenState extends State<MemoryDifficultyScreen> {
  String _selectedLevel = GameConstants.memoryLevel1;
  final LevelService _levelService = LevelService();
  List<String> _unlockedLevels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
  }

  /// 加载已解锁关卡
  Future<void> _loadUnlockedLevels() async {
    final unlockedLevels = await _levelService.getUnlockedLevels();
    final currentLevel = await _levelService.getCurrentLevel();

    setState(() {
      _unlockedLevels = unlockedLevels;
      _selectedLevel = currentLevel;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Memory Match'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // 仅用于测试：重置所有进度
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _levelService.resetAllProgress();
              _loadUnlockedLevels();
            },
            tooltip: 'Reset Progress (Debug)',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Level',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Complete each level to unlock the next one',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),

                    const SizedBox(height: 30),

                    // 关卡列表
                    Expanded(
                      child: ListView(
                        children: [
                          _buildLevelCard(GameConstants.memoryLevel1),
                          _buildLevelCard(GameConstants.memoryLevel2),
                          _buildLevelCard(GameConstants.memoryLevel3),
                          _buildLevelCard(GameConstants.memoryLevel4),
                          _buildLevelCard(GameConstants.memoryLevel5),
                          _buildLevelCard(GameConstants.memoryLevel6),
                          _buildLevelCard(GameConstants.memoryLevel7),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 开始游戏按钮
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // 保存当前选择的关卡
                          _levelService.setCurrentLevel(_selectedLevel);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MemoryGameScreen(difficulty: _selectedLevel),
                            ),
                          ).then((_) {
                            // 返回时重新加载关卡状态
                            _loadUnlockedLevels();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Start Game',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLevelCard(String level) {
    final bool isSelected = _selectedLevel == level;
    final bool isUnlocked = _unlockedLevels.contains(level);
    final String levelName = _levelService.getLevelName(level);
    final String levelDescription = _levelService.getLevelDescription(level);

    // 确定关卡颜色和图标
    Color levelColor;
    IconData levelIcon;

    switch (level) {
      case GameConstants.memoryLevel1:
        levelColor = Colors.green;
        levelIcon = Icons.eco;
        break;
      case GameConstants.memoryLevel2:
        levelColor = Colors.orange;
        levelIcon = Icons.pets;
        break;
      case GameConstants.memoryLevel3:
        levelColor = Colors.red;
        levelIcon = Icons.restaurant;
        break;
      case GameConstants.memoryLevel4:
        levelColor = Colors.blue;
        levelIcon = Icons.flight;
        break;
      case GameConstants.memoryLevel5:
        levelColor = Colors.purple;
        levelIcon = Icons.rocket;
        break;
      case GameConstants.memoryLevel6:
        levelColor = Colors.teal;
        levelIcon = Icons.devices;
        break;
      case GameConstants.memoryLevel7:
        levelColor = Colors.amber;
        levelIcon = Icons.auto_fix_high;
        break;
      default:
        levelColor = AppColors.primary;
        levelIcon = Icons.extension;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: isUnlocked
            ? () {
                setState(() {
                  _selectedLevel = level;
                });
              }
            : null,
        child: NeumorphicCard(
          padding: const EdgeInsets.all(20),
          glow: isSelected,
          border: isSelected ? Border.all(color: levelColor, width: 2) : null,
          backgroundColor: isUnlocked
              ? (isSelected ? levelColor.withOpacity(0.1) : null)
              : Colors.grey[850],
          child: Row(
            children: [
              // 关卡图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? levelColor.withOpacity(0.2)
                      : Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  levelIcon,
                  color: isUnlocked ? levelColor : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // 关卡信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          levelName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked
                                ? (isSelected ? levelColor : Colors.white)
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isUnlocked)
                          const Icon(Icons.lock, color: Colors.grey, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      levelDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: isUnlocked ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // 选中标记
              if (isSelected && isUnlocked)
                Icon(Icons.check_circle, color: levelColor, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
