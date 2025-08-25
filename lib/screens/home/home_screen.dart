import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/cyber_button.dart';
import '../../services/audio.dart';
import '../campaign/campaign_screen.dart';
import '../records/records_screen.dart';
import '../achievements/achievements_screen.dart';
import '../settings/settings_screen.dart';

/// 主屏幕
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _titleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);

    // 播放菜单音乐
    AudioService.instance.playMenuMusic();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
              'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?q=80&w=2071&auto=format&fit=crop',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.primaryDark.withOpacity(0.8),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // 标题
                AnimatedBuilder(
                  animation: _titleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _titleAnimation.value,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'ChroPlexiGnosis',
                        style: TextStyle(
                          fontFamily: 'System',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryAccent,
                          shadows: [
                            Shadow(
                              color: AppColors.primaryAccent.withOpacity(0.7),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'A Cerebral Matching Game',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 主菜单按钮
                Column(
                  children: [
                    CyberButton(
                      text: 'CAMPAIGN',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CampaignScreen(),
                          ),
                        );
                      },
                      backgroundColor: AppColors.primaryAccent,
                      textColor: AppColors.primaryDark,
                      isPrimary: true,
                      isGlowing: true,
                      height: 64,
                    ),

                    const SizedBox(height: 16),
                    CyberButton(
                      text: 'CHRONOS RECORDS',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordsScreen(),
                          ),
                        );
                      },
                      backgroundColor: Colors.transparent,
                      textColor: AppColors.textColor,
                      isPrimary: true,
                      isGlowing: true,
                      height: 64,
                    ),
                    const SizedBox(height: 16),
                    CyberButton(
                      text: 'GNOSTIC SEALS',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AchievementsScreen(),
                          ),
                        );
                      },
                      backgroundColor: Colors.transparent,
                      textColor: AppColors.textColor,
                      isPrimary: true,
                      isGlowing: true,
                      height: 64,
                    ),
                  ],
                ),

                const Spacer(),

                // 设置按钮
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    size: 32,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
