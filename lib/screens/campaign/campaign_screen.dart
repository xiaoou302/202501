import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/styles.dart';
import '../../models/level.dart';
import '../../services/storage.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/hexagon.dart';
import '../../widgets/common/cyber_button.dart';
import '../game/game_screen.dart';

/// 关卡选择界面
class CampaignScreen extends StatefulWidget {
  const CampaignScreen({Key? key}) : super(key: key);

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  int _selectedLevel = 1;
  List<Level> _levels = [];
  bool _isLoading = true;
  bool _isNavigating = false; // 防止重复导航

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  // 加载关卡数据
  Future<void> _loadLevels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 从存储中加载关卡数据
      final levels = await StorageService.instance.loadLevels();

      // 如果没有存储的关卡数据，使用默认关卡
      if (levels.isEmpty) {
        _levels = _getDefaultLevels();
      } else {
        _levels = levels;
      }

      // 加载当前关卡ID
      final currentLevelId = await StorageService.instance.loadCurrentLevelId();
      _selectedLevel = currentLevelId;
    } catch (e) {
      print('Error loading levels: $e');
      _levels = _getDefaultLevels();
    }

    setState(() {
      _isLoading = false;
    });
  }

  // 默认关卡数据
  List<Level> _getDefaultLevels() {
    // 这里返回经过重新设计的关卡数据，确保每个关卡目标可达成且有趣
    return [
      Level(
        id: 1,
        name: 'Awakening',
        description:
            'Get familiar with basic color or shape matching and accumulate enough points to pass this level.',
        objective: LevelObjective(type: LevelObjectiveType.score, target: 3000),
        initialBoard: [], // 实际游戏中应该有初始棋盘配置
        maxMoves: 30,
        timeLimit: 300, // 5分钟
        boardWidth: 6,
        boardHeight: 6,
        isUnlocked: true,
        starsEarned: 0,
      ),
      Level(
        id: 2,
        name: 'Perfect Combination',
        description:
            'Remove locked units and create perfect matches (same color and shape) to earn transmute abilities.',
        objective: LevelObjective(
          type: LevelObjectiveType.lockedUnits,
          target: 11,
        ),
        initialBoard: [], // 实际游戏中应该有初始棋盘配置
        maxMoves: 25,
        timeLimit: 240, // 4分钟
        boardWidth: 7,
        boardHeight: 7,
        isUnlocked: true,
        starsEarned: 0,
      ),
      Level(
        id: 3,
        name: 'Geometric Maze',
        description:
            'The holes on the board limit unit movement, forcing you to focus on creating high-difficulty perfect matches.',
        objective: LevelObjective(
          type: LevelObjectiveType.plexiMatches,
          target: 5,
        ),
        initialBoard: [], // 实际游戏中应该有初始棋盘配置
        maxMoves: 30,
        timeLimit: 300, // 5分钟
        boardWidth: 8,
        boardHeight: 8,
        isUnlocked: true,
        starsEarned: 0,
      ),
      Level(
        id: 4,
        name: 'Chameleon Hunter',
        description:
            'Remove changing units. You must first complete perfect matches with normal units to earn transmute abilities, then use those abilities to remove changing units. Normal matches cannot remove changing units.',
        objective: LevelObjective(
          type: LevelObjectiveType.changingUnits,
          target: 10,
        ),
        initialBoard: [], // 实际游戏中应该有初始棋盘配置
        maxMoves: 45, // 增加步数，因为需要更多完美匹配来获得嬗变能力
        timeLimit: 360, // 6分钟
        boardWidth: 7,
        boardHeight: 8,
        isUnlocked: false,
        starsEarned: 0,
      ),
      Level(
        id: 5,
        name: 'Purification Master',
        description:
            'Purify polluted tiles. You must first complete perfect matches with normal units to earn transmute abilities, convert polluted tiles into changing units, then use another transmute ability to remove them. Normal matches cannot purify polluted tiles.',
        objective: LevelObjective(
          type: LevelObjectiveType.purifyTiles,
          target: 12,
        ),
        initialBoard: [], // 实际游戏中应该有初始棋盘配置
        maxMoves: 55, // 增加步数，因为需要更多完美匹配来获得嬗变能力，且每个污染格子需要两次嬗变
        timeLimit: 420, // 7分钟
        boardWidth: 8,
        boardHeight: 8,
        isUnlocked: false,
        starsEarned: 0,
      ),
      Level(
        id: 6,
        name: 'Ultimate Challenge',
        description:
            'Remove changing units and purify polluted tiles simultaneously. You must first complete perfect matches with normal units to earn transmute abilities, then use them strategically to complete both objectives.',
        objective: LevelObjective(
          type: LevelObjectiveType.changingUnits,
          target: 10, // 主要目标是消除变色龙单元，但实际上需要同时完成两个目标
        ),
        initialBoard: [], // 实际游戏中应该有初始棋盘配置
        maxMoves: 70, // 大幅增加步数，因为需要完成两个目标，且污染格子需要两次嬗变
        timeLimit: 600, // 10分钟
        boardWidth: 8,
        boardHeight: 9,
        isUnlocked: false,
        starsEarned: 0,
      ),
    ];
  }

  // 选择关卡
  void _selectLevel(int levelId) {
    if (_levels.any((level) => level.id == levelId && level.isUnlocked)) {
      setState(() {
        _selectedLevel = levelId;
      });
    }
  }

  // 开始游戏
  void _startGame() async {
    if (_isNavigating) return; // 防止重复点击

    setState(() {
      _isNavigating = true;
    });

    final selectedLevel = _levels.firstWhere(
      (level) => level.id == _selectedLevel,
    );

    // 使用await等待导航完成
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(level: selectedLevel)),
    );

    // 导航返回后重置状态
    if (mounted) {
      setState(() {
        _isNavigating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前选中的关卡
    final selectedLevel = _isLoading
        ? null
        : _levels.firstWhere(
            (level) => level.id == _selectedLevel,
            orElse: () => _levels.first,
          );

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            )
          : SafeArea(
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
                      child: Text('CAMPAIGN', style: AppStyles.titleLarge),
                    ),

                    const SizedBox(height: 32),

                    // 关卡选择网格
                    Center(
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: _levels.map((level) {
                          return LevelHexagon(
                            level: level.id,
                            stars: level.starsEarned,
                            isUnlocked: level.isUnlocked,
                            isSelected: level.id == _selectedLevel,
                            onTap: () => _selectLevel(level.id),
                          );
                        }).toList(),
                      ),
                    ),

                    const Spacer(),

                    // 关卡详情卡片
                    if (selectedLevel != null)
                      GlassCard(
                        borderColor: AppColors.secondaryAccent,
                        isGlowing: true,
                        glowColor: AppColors.secondaryAccent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedLevel.name,
                              style: AppStyles.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              selectedLevel.description,
                              style: AppStyles.bodyMedium.copyWith(
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Objective:',
                                  style: AppStyles.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getObjectiveText(selectedLevel.objective),
                                  style: TextStyle(
                                    color: AppColors.primaryAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            CyberButton(
                              text: _isNavigating ? 'Loading...' : 'Start',
                              backgroundColor: AppColors.secondaryAccent,
                              textColor: Colors.white,
                              isPrimary: false,
                              onPressed: _isNavigating ? () {} : _startGame,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  // 获取目标文本
  String _getObjectiveText(LevelObjective objective) {
    switch (objective.type) {
      case LevelObjectiveType.score:
        return 'Reach ${objective.target} points';
      case LevelObjectiveType.matches:
        return 'Make ${objective.target} matches';
      case LevelObjectiveType.plexiMatches:
        return 'Make ${objective.target} perfect matches';
      case LevelObjectiveType.lockedUnits:
        // 第二关特殊处理
        if (_selectedLevel == 2) {
          return 'Remove ${objective.target} locked units and make 1 perfect match';
        }
        return 'Remove ${objective.target} locked units';
      case LevelObjectiveType.changingUnits:
        // 第六关特殊处理
        if (_selectedLevel == 6) {
          return 'Remove 10 changing units and purify 16 polluted tiles';
        }
        return 'Remove ${objective.target} changing units';
      case LevelObjectiveType.purifyTiles:
        return 'Purify ${objective.target} polluted tiles';
    }
  }
}
