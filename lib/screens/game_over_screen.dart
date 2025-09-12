import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level.dart';
import '../services/storage.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// 游戏结束界面
class GameOverScreen extends StatefulWidget {
  final Duration time;
  final String levelId;

  const GameOverScreen({
    super.key,
    required this.time,
    required this.levelId,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  Level? _level;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLevelData();
  }

  Future<void> _loadLevelData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);
      final levels = await storageService.getLevels();

      setState(() {
        _level = levels.firstWhere((level) => level.id == widget.levelId);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgDeepSpaceGray,
              AppColors.bgDeepSpaceGray.withBlue(50),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentMintGreen,
                  ),
                )
              : _buildGameOverContent(),
        ),
      ),
    );
  }

  Widget _buildGameOverContent() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 胜利图标
          const Icon(
            Icons.emoji_events,
            size: 80,
            color: AppColors.gold,
          ),
          const SizedBox(height: 24),

          // 胜利标题
          Text(
            'Congratulations!',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 32),

          // 游戏统计信息
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildStatRow('Time', formatDuration(widget.time)),
                if (_level != null) ...[
                  const Divider(color: Colors.white10),
                  _buildStatRow('Stars', _buildStars()),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 按钮
          ElevatedButton(
            onPressed: () {
              // 再玩一局
              if (_level != null) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.game,
                  arguments: _level,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
            ),
            child: const Text('Play Again'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 返回主菜单
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              foregroundColor: AppColors.textMoonWhite,
              minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
            ),
            child: const Text('Back to Main Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMoonWhite.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          if (value is String)
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textMoonWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            value,
        ],
      ),
    );
  }

  Widget _buildStars() {
    int stars = 0;

    // Calculate stars based on time
    if (widget.time.inSeconds < 60) {
      stars = 3; // 3 stars if completed within 1 minute
    } else if (widget.time.inSeconds < 120) {
      stars = 2; // 2 stars if completed within 2 minutes
    } else {
      stars = 1; // 1 star otherwise
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(GameConstants.maxStars, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: AppColors.gold,
          size: 20,
        );
      }),
    );
  }
}
