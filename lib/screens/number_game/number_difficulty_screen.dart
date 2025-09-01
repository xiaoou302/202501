import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../widgets/common/neumorphic_card.dart';
import 'number_game_screen.dart';

/// 数字记忆游戏难度选择页面
class NumberDifficultyScreen extends StatefulWidget {
  const NumberDifficultyScreen({super.key});

  @override
  State<NumberDifficultyScreen> createState() => _NumberDifficultyScreenState();
}

class _NumberDifficultyScreenState extends State<NumberDifficultyScreen> {
  String _selectedDifficulty = GameConstants.numberLevel1;
  bool _isLoading = false;
  List<String> _unlockedLevels = [GameConstants.numberLevel1];

  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
  }

  /// 加载已解锁关卡
  Future<void> _loadUnlockedLevels() async {
    setState(() {
      _isLoading = true;
    });

    // 这里可以从SharedPreferences加载已解锁的关卡
    try {
      // 模拟从存储加载解锁关卡
      // 实际应用中，你应该从SharedPreferences加载
      await Future.delayed(const Duration(milliseconds: 500));

      // 解锁前三个关卡用于演示
      setState(() {
        _unlockedLevels = [
          GameConstants.numberLevel1,
          GameConstants.numberLevel2,
          GameConstants.numberLevel3,
        ];
      });
    } catch (e) {
      // 如果出错，至少解锁第一关
      setState(() {
        _unlockedLevels = [GameConstants.numberLevel1];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Number Memory'),
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
                      'Select Difficulty',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Remember the numbers and tap them in ascending order',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),

                    const SizedBox(height: 30),

                    // 难度选择卡片
                    Expanded(
                      child: ListView(
                        children: [
                          _buildDifficultyCard(
                            difficulty: GameConstants.numberLevel1,
                            title: 'Level 1',
                            description:
                                '3 numbers (1-3), 5 seconds to memorize',
                            color: Colors.green,
                            icon: Icons.looks_one,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.numberLevel2,
                            title: 'Level 2',
                            description:
                                '4 numbers (1-4), 5 seconds to memorize',
                            color: Colors.blue,
                            icon: Icons.looks_two,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.numberLevel3,
                            title: 'Level 3',
                            description:
                                '5 numbers (6-10), 4 seconds to memorize',
                            color: Colors.cyan,
                            icon: Icons.looks_3,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.numberLevel4,
                            title: 'Level 4',
                            description:
                                '6 letters (A-F), 4 seconds to memorize',
                            color: Colors.teal,
                            icon: Icons.looks_4,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.numberLevel5,
                            title: 'Level 5',
                            description:
                                '7 numbers (10-16), 3 seconds to memorize',
                            color: Colors.orange,
                            icon: Icons.looks_5,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.numberLevel6,
                            title: 'Level 6',
                            description:
                                '9 letters (A-I), 3 seconds to memorize',
                            color: Colors.deepOrange,
                            icon: Icons.filter_6,
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyCard(
                            difficulty: GameConstants.numberLevel7,
                            title: 'Level 7',
                            description:
                                '12 numbers (15-26), 3 seconds to memorize',
                            color: Colors.red,
                            icon: Icons.filter_7,
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
                                    builder: (_) => NumberGameScreen(
                                      difficulty: _selectedDifficulty,
                                    ),
                                  ),
                                );
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
                          fontSize: 20,
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
    return _unlockedLevels.contains(difficulty);
  }
}
