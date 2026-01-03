import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/app_fonts.dart';
import '../core/app_theme.dart';
import '../core/routes.dart';
import '../models/level_model.dart';
import '../models/level_config.dart';


class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen>
    with SingleTickerProviderStateMixin {
  final List<LevelModel> _levels = LevelData.levels;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.5,
              colors: [
                const Color(0xFF1a1f3a),
                AppTheme.deepBg,
                Colors.black,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 24),
                Expanded(
                  child: _buildLevelGrid(),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          // 标题
          Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppTheme.deepBlue,
                    AppTheme.deepAccent,
                  ],
                ).createShader(bounds),
                child: Text(
                  'MISSIONS',
                  style: AppFonts.orbitron(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose Your Challenge',
                style: AppFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildLevelGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _levels.length,
      itemBuilder: (context, index) {
        final level = _levels[index];
        final config = LevelConfigs.getConfig(level.id);
        final delay = index * 0.1;
        
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(delay, delay + 0.3, curve: Curves.easeOut),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(delay, delay + 0.3, curve: Curves.easeOut),
              ),
            ),
            child: _buildLevelCard(level, config),
          ),
        );
      },
    );
  }

  Widget _buildLevelCard(LevelModel level, LevelGameConfig? config) {
    final isUnlocked = level.isUnlocked || level.levelNumber == 1;
    final difficultyColor = _getDifficultyColor(level.difficulty);
    final hasTimeLimit = config?.timeLimit != null;

    return GestureDetector(
      onTap: isUnlocked
          ? () => Navigator.pushNamed(
                context,
                AppRoutes.gameBoard,
                arguments: level.id,
              )
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            // 主卡片
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isUnlocked
                      ? [
                          difficultyColor.withOpacity(0.15),
                          AppTheme.deepSurface.withOpacity(0.8),
                        ]
                      : [
                          Colors.grey.withOpacity(0.1),
                          Colors.grey.withOpacity(0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isUnlocked
                      ? difficultyColor.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: difficultyColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // 背景装饰
                    if (isUnlocked)
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Transform.rotate(
                          angle: math.pi / 4,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  difficultyColor.withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    // 内容
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 关卡编号
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isUnlocked
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            difficultyColor,
                                            difficultyColor.withOpacity(0.6),
                                          ],
                                        )
                                      : null,
                                  color: isUnlocked
                                      ? null
                                      : Colors.grey.withOpacity(0.2),
                                  boxShadow: isUnlocked
                                      ? [
                                          BoxShadow(
                                            color:
                                                difficultyColor.withOpacity(0.5),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: isUnlocked
                                      ? Text(
                                          '${level.levelNumber}',
                                          style: AppFonts.orbitron(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(
                                          Icons.lock_rounded,
                                          color: Colors.grey.withOpacity(0.5),
                                          size: 28,
                                        ),
                                ),
                              ),
                              // 星级
                              if (isUnlocked && level.isCompleted)
                                Column(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        3,
                                        (i) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          child: Icon(
                                            Icons.star_rounded,
                                            size: 14,
                                            color: i < level.starsEarned
                                                ? AppTheme.deepAccent
                                                : Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const Spacer(),
                          // 关卡名称
                          Text(
                            level.name,
                            style: AppFonts.orbitron(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // 难度标签
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: difficultyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: difficultyColor.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getDifficultyText(level.difficulty),
                              style: AppFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: difficultyColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 配置信息
                          if (config != null && isUnlocked)
                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.storage_rounded,
                                  '${config.bufferSlots}',
                                  AppTheme.deepBlue,
                                ),
                                if (hasTimeLimit) ...[
                                  const SizedBox(width: 6),
                                  _buildInfoChip(
                                    Icons.timer_rounded,
                                    '${config.timeLimit!.inMinutes}m',
                                    AppTheme.deepRed,
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 解锁状态指示器
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(LevelDifficulty difficulty) {
    switch (difficulty) {
      case LevelDifficulty.tutorial:
        return const Color(0xFF4ade80);
      case LevelDifficulty.easy:
        return AppTheme.deepBlue;
      case LevelDifficulty.normal:
        return AppTheme.deepAccent;
      case LevelDifficulty.hard:
        return const Color(0xFFfb923c);
      case LevelDifficulty.expert:
        return AppTheme.deepRed;
    }
  }

  String _getDifficultyText(LevelDifficulty difficulty) {
    switch (difficulty) {
      case LevelDifficulty.tutorial:
        return 'TUTORIAL';
      case LevelDifficulty.easy:
        return 'EASY';
      case LevelDifficulty.normal:
        return 'NORMAL';
      case LevelDifficulty.hard:
        return 'HARD';
      case LevelDifficulty.expert:
        return 'EXPERT';
    }
  }
}
