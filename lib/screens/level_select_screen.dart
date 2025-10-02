import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/level_cache.dart';
import '../utils/level_generator.dart';
import '../utils/preferences_manager.dart';
import '../widgets/level_grid_widget.dart';

/// Screen for selecting a level directly
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({Key? key}) : super(key: key);

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  List<GameLevelMetadata> _levelMetadata = [];
  List<int> _completedLevelIds = [];
  // 移除选中标签索引，因为不再需要底部导航栏
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    setState(() {
      _isLoading = true;
    });

    // Get all levels metadata
    _levelMetadata = LevelGenerator.getAllLevelMetadata();

    // Load completed levels
    final completedLevels = await PreferencesManager.getCompletedLevels();
    _completedLevelIds = completedLevels;

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              Color(0xFFEAE5E1),
              Color(0xFFF0E9E5),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.pop(context),
                      color: AppColors.textGraphite,
                    ),
                    const Expanded(
                      child: SizedBox(), // 留出空间
                    ),
                  ],
                ),
              ),

              // Premium Header with advanced animation effects
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0, // 减少上部填充，因为现在有了返回按钮
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    // Title with 3D effect and multi-color gradient
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppColors.arrowBlue,
                          AppColors.accentCoral,
                          AppColors.arrowGreen,
                          AppColors.arrowPink,
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Glyphion Levels',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Animated subtitle with glass effect
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.accentCoral.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: AppColors.accentCoral,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Select a level to play',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGraphite,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Progress indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Text(
                            'Progress: ${_completedLevelIds.length}/${_levelMetadata.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGraphite,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _levelMetadata.isEmpty
                                    ? 0
                                    : _completedLevelIds.length /
                                          _levelMetadata.length,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.accentCoral,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Levels grid
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildLevelsGrid(),
              ),

              // 底部填充，为主导航栏留出空间
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelsGrid() {
    final List<GameLevelMetadata> processedMetadata = [];

    // Unlock all levels
    for (int i = 0; i < _levelMetadata.length; i++) {
      // Set isLocked to false for all levels
      processedMetadata.add(_levelMetadata[i].copyWith(isLocked: false));
    }

    return LevelGridWidget(
      levelMetadata: processedMetadata,
      completedLevelIds: _completedLevelIds,
      onLevelTap: (levelId) {
        // Only load the full level when the user taps on it
        Navigator.pushNamed(
          context,
          AppRoutes.gameScreen,
          arguments: levelId,
        ).then((_) {
          // Refresh level progress when returning from the game
          _loadLevels();
        });
      },
    );
  }

  // 移除底部导航栏项目构建方法
}
