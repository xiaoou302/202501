import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/glow_button.dart';
import '../memory_game/memory_difficulty_screen.dart';
import '../rhythm_game/rhythm_difficulty_screen.dart';
import '../number_game/number_difficulty_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../achievements/achievements_screen.dart';
import '../settings/settings_screen.dart';

/// 主页/游戏选择页面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _GamesPage(),
    const LeaderboardScreen(),
    const AchievementsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // 设置状态栏为透明
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFF333333), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Games'),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Achievements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

/// 游戏选择页面
class _GamesPage extends StatelessWidget {
  const _GamesPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 标题
            const Text(
              'Hyquinoxa',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Text(
              'Choose your challenge',
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),

            const SizedBox(height: 30),

            // 数字记忆游戏卡片
            _buildGameCard(
              context: context,
              title: 'Number Memory',
              description: 'Remember and tap numbers in order.',
              icon: Icons.format_list_numbered_rounded,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NumberDifficultyScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 记忆游戏卡片
            _buildGameCard(
              context: context,
              title: 'Memory Match',
              description: 'Find pairs with special powers.',
              icon: Icons.grid_view_rounded,
              color: AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MemoryDifficultyScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 流动游戏卡片
            _buildGameCard(
              context: context,
              title: 'Flow Rush',
              description: 'Tap targets, avoid obstacles, chase high scores.',
              icon: Icons.auto_awesome,
              color: Colors.purpleAccent,
              onTap: () {
                // 使用全局键确保状态一致性
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RhythmDifficultyScreen(
                      key: RhythmDifficultyScreen.globalKey,
                    ),
                  ),
                ).then((_) {
                  // 返回时刷新关卡列表
                  RhythmDifficultyScreen.refreshLevels();
                });
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // 背景
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.2), AppColors.cardBackground],
                  ),
                ),
                child: Opacity(
                  opacity: 0.1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(icon, size: 150, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // 暗色叠加层
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.cardBackground.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // 内容
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 12),
                  GlowButton(
                    text: 'PLAY',
                    onPressed: onTap,
                    width: 120,
                    height: 40,
                    small: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
