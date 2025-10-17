import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/mahjong_constants.dart';
import 'game_board_page.dart';

/// Level selection screen
class LevelSelectionPage extends StatefulWidget {
  /// Constructor
  const LevelSelectionPage({super.key});

  @override
  State<LevelSelectionPage> createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHighestLevel();
  }

  Future<void> _loadHighestLevel() async {
    // 不需要加载最高关卡，直接设置加载完成
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.carvedJadeGreen,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with back button and title
                      _buildHeader(context),
                      const SizedBox(height: 24),

                      // Game description
                      _buildGameDescription(),
                      const SizedBox(height: 24),

                      // Chapters and levels
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Chapter 1
                                    _buildChapterSection(
                                      context: context,
                                      title: 'Chapter 1: Beginner',
                                      subtitle: 'The Journey Begins',
                                      description:
                                          'Start your Mahjong journey with simple layouts and fewer tile types. Perfect for learning the basics of matching and strategy.',
                                      levels: MahjongConstants
                                          .chapters['Chapter 1: 入门']!,
                                      icon: Icons.emoji_events_outlined,
                                      color: AppColors.beeswaxAmber,
                                    ),
                                    const SizedBox(height: 24),

                                    // Chapter 2
                                    _buildChapterSection(
                                      context: context,
                                      title: 'Chapter 2: Intermediate',
                                      subtitle: 'Expanding Horizons',
                                      description:
                                          'Face more complex layouts with additional tile types. Test your growing skills with challenging arrangements.',
                                      levels: MahjongConstants
                                          .chapters['Chapter 2: 进阶']!,
                                      icon: Icons.auto_awesome,
                                      color: AppColors.carvedJadeGreen,
                                    ),
                                    const SizedBox(height: 24),

                                    // Chapter 3
                                    _buildChapterSection(
                                      context: context,
                                      title: 'Chapter 3: Advanced',
                                      subtitle: 'Master\'s Challenge',
                                      description:
                                          'The ultimate test of your Mahjong skills. Complex layouts with all tile types will challenge even the most experienced players.',
                                      levels: MahjongConstants
                                          .chapters['Chapter 3: 终局']!,
                                      icon: Icons.psychology,
                                      color: Colors.purple.shade300,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // 构建页面头部
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Back button with glass effect
          Container(
            decoration: BoxDecoration(
              color: AppColors.carvedJadeGreen.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 8),

          // Title with decorative elements
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 根据可用宽度调整标题样式
                // 增大小屏幕的检测阈值
                final bool isSmallScreen = constraints.maxWidth < 220;
                final bool isVerySmallScreen = constraints.maxWidth < 180;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // 防止Row超出范围
                  children: [
                    // 在小屏幕上完全移除装饰线
                    if (!isSmallScreen)
                      Container(
                        height: 2,
                        width: 15,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    SizedBox(width: isSmallScreen ? 2 : 5),
                    Text(
                      isVerySmallScreen ? 'LEVELS' : 'SELECT LEVEL',
                      style: TextStyle(
                        fontSize: isVerySmallScreen
                            ? 16
                            : (isSmallScreen ? 17 : 19),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: isSmallScreen ? 0.5 : 1,
                        shadows: const [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 2 : 5),
                    // 在小屏幕上移除右侧装饰线
                    if (!isSmallScreen)
                      Container(
                        height: 2,
                        width: 15,
                        color: Colors.white.withOpacity(0.7),
                      ),
                  ],
                );
              },
            ),
          ),

          // 减小平衡空间
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // 构建游戏描述部分
  Widget _buildGameDescription() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.carvedJadeGreen.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.carvedJadeGreen.withOpacity(0.7),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(Icons.spa, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jongara',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Strategy in Every Tile',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Experience the ancient art of Mahjong in a modern, zen-like atmosphere. Match tiles, clear the board, and challenge yourself with increasingly complex layouts.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(0.5, 0.5),
                      blurRadius: 1.0,
                      color: Color.fromARGB(180, 0, 0, 0),
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

  // 构建章节部分
  Widget _buildChapterSection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required List<int> levels,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter header with icon and title
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.7), width: 1.5),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 检测是否为小屏幕
                  final bool isSmallScreen = constraints.maxWidth < 220;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // 如果是小屏幕，简化标题
                        isSmallScreen ? _simplifyTitle(title) : title,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2.0,
                              color: Color.fromARGB(180, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),

        // Chapter description
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 8, bottom: 12),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
              fontWeight: FontWeight.w400,
              shadows: [
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 1.0,
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),

        // Level grid
        LayoutBuilder(
          builder: (context, constraints) {
            // 根据可用宽度决定每行显示的关卡数
            final int crossAxisCount = constraints.maxWidth < 300 ? 3 : 4;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: constraints.maxWidth < 300 ? 8 : 12,
              crossAxisSpacing: constraints.maxWidth < 300 ? 8 : 12,
              childAspectRatio: 1.0,
              children: levels.map((level) {
                return _buildLevelButton(context, level, color);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // 构建关卡按钮
  Widget _buildLevelButton(BuildContext context, int level, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _navigateToLevel(context, level),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.4),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: accentColor.withOpacity(0.5), width: 1.5),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Level number
            Text(
              '$level',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 300 ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2.0,
                    color: Color.fromARGB(180, 0, 0, 0),
                  ),
                ],
              ),
            ),

            // Decorative corner
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLevel(BuildContext context, int level) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameBoardPage(level: level)),
    ).then((_) {
      // Refresh the highest level when returning from the game
      _loadHighestLevel();
    });
  }

  /// 简化标题，为小屏幕优化
  String _simplifyTitle(String title) {
    // 处理章节标题
    if (title.startsWith('Chapter 1')) {
      return 'Ch 1: Beginner';
    } else if (title.startsWith('Chapter 2')) {
      return 'Ch 2: Intermediate';
    } else if (title.startsWith('Chapter 3')) {
      return 'Ch 3: Advanced';
    }
    return title;
  }
}
