import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../widgets/common/neumorphic_card.dart';
import 'rhythm_game_screen.dart';

/// 流动游戏难度选择页面
class RhythmDifficultyScreen extends StatefulWidget {
  const RhythmDifficultyScreen({super.key});

  /// 全局键，用于获取State对象
  static final GlobalKey<_RhythmDifficultyScreenState> globalKey =
      GlobalKey<_RhythmDifficultyScreenState>();

  /// 刷新关卡列表的静态方法
  static void refreshLevels() {
    final state = globalKey.currentState;
    if (state != null && state.mounted) {
      state._loadUnlockedLevels();
    }
  }

  @override
  State<RhythmDifficultyScreen> createState() => _RhythmDifficultyScreenState();
}

class _RhythmDifficultyScreenState extends State<RhythmDifficultyScreen> {
  String _selectedDifficulty = GameConstants.flowNormal;
  bool _isLoading = false;
  List<String> _unlockedLevels = [
    GameConstants.flowEasy,
    GameConstants.flowNormal,
  ];

  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
  }

  /// 加载已解锁关卡
  Future<void> _loadUnlockedLevels() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    // 从 SharedPreferences 加载已解锁的关卡
    try {
      final prefs = await SharedPreferences.getInstance();
      final unlockedLevelsStr = prefs.getString(
        GameConstants.keyUnlockedLevels,
      );

      print('Loading unlocked levels from SharedPreferences');
      print('Raw value: $unlockedLevelsStr');

      if (!mounted) return;

      if (unlockedLevelsStr != null && unlockedLevelsStr.isNotEmpty) {
        // 如果有已保存的解锁关卡，加载它们
        final List<dynamic> decoded = jsonDecode(unlockedLevelsStr);
        print('Decoded levels: $decoded');

        setState(() {
          _unlockedLevels = List<String>.from(decoded);
        });
      } else {
        // 如果没有已保存的解锁关卡，至少解锁第一关和第二关
        setState(() {
          _unlockedLevels = [GameConstants.flowEasy, GameConstants.flowNormal];
        });

        // 保存默认解锁的关卡
        await prefs.setString(
          GameConstants.keyUnlockedLevels,
          jsonEncode([GameConstants.flowEasy, GameConstants.flowNormal]),
        );

        print('No saved levels found. Setting defaults: $_unlockedLevels');
      }
    } catch (e) {
      // 如果出错，至少解锁第一关
      print('Error loading unlocked levels: $e');
      if (mounted) {
        setState(() {
          _unlockedLevels = [GameConstants.flowEasy];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      print('Final unlocked levels: $_unlockedLevels');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Flow Rush'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                      'Tap targets and avoid obstacles to reach high scores',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),

                    const SizedBox(height: 30),

                    // 难度选择卡片
                    Expanded(
                      child: ListView(
                        children: [
                          _buildDifficultyCard(
                            difficulty: GameConstants.flowEasy,
                            title: 'Level 1: Beginner',
                            description: '4 columns, 2 note types, 20 moves',
                            color: Colors.green,
                            icon: Icons.looks_one,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.flowNormal,
                            title: 'Level 2: Regular',
                            description: '4 columns, 3 note types, 25 moves',
                            color: Colors.blue,
                            icon: Icons.looks_two,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.flowHard,
                            title: 'Level 3: Advanced',
                            description: '4 columns, 3 note types, 30 moves',
                            color: Colors.orange,
                            icon: Icons.looks_3,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.flowExpert,
                            title: 'Level 4: Expert',
                            description: '5 columns, 4 note types, 35 moves',
                            color: Colors.red,
                            icon: Icons.looks_4,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.flowMaster,
                            title: 'Level 5: Master',
                            description: '5 columns, 4 note types, 40 moves',
                            color: Colors.purple,
                            icon: Icons.looks_5,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.flowGrandmaster,
                            title: 'Level 6: Grandmaster',
                            description: '6 columns, all note types, 45 moves',
                            color: Colors.deepPurple,
                            icon: Icons.looks_6,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.flowLegend,
                            title: 'Level 7: Legend',
                            description: '6 columns, all note types, 50 moves',
                            color: Colors.amber.shade900,
                            icon: Icons.emoji_events,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 开始游戏按钮
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLevelUnlocked(_selectedDifficulty)
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RhythmGameScreen(
                                      difficulty: _selectedDifficulty,
                                    ),
                                  ),
                                ).then((_) {
                                  // 游戏结束后重新加载已解锁关卡
                                  _loadUnlockedLevels();
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          disabledBackgroundColor: AppColors.primary
                              .withOpacity(0.3),
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

  Widget _buildDifficultyCard({
    required String difficulty,
    required String title,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    final bool isSelected = _selectedDifficulty == difficulty;
    final bool isUnlocked = _isLevelUnlocked(difficulty);

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              setState(() {
                _selectedDifficulty = difficulty;
              });
            }
          : null,
      child: NeumorphicCard(
        padding: const EdgeInsets.all(20),
        glow: isSelected,
        border: isSelected ? Border.all(color: color, width: 2) : null,
        backgroundColor: isUnlocked
            ? (isSelected ? color.withOpacity(0.1) : null)
            : Colors.grey[850],
        child: Row(
          children: [
            // 难度图标
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isUnlocked ? color.withOpacity(0.2) : Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isUnlocked ? color : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // 难度信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? (isSelected ? color : Colors.white)
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
                    description,
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
              Icon(Icons.check_circle, color: color, size: 28),
          ],
        ),
      ),
    );
  }

  /// 检查关卡是否已解锁
  bool _isLevelUnlocked(String difficulty) {
    // 打印当前解锁的关卡列表，用于调试
    print('Current unlocked levels: $_unlockedLevels');
    return _unlockedLevels.contains(difficulty);
  }
}
