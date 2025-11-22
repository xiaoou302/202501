import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/local/local_storage.dart';
import '../widgets/particle_background.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({Key? key}) : super(key: key);

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildLevelGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.midnight, AppColors.midnight.withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticUtils.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2ECC71).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF2ECC71).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF2ECC71),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.mountain,
                      size: 12,
                      color: Color(0xFF2ECC71),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'NATURE JOURNEY',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF2ECC71),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Select Level',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
          // Decorative nature icon
          const FaIcon(
            FontAwesomeIcons.tree,
            size: 24,
            color: Color(0xFF2ECC71),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: GameLevels.levels.length,
      itemBuilder: (context, index) {
        final level = GameLevels.levels[index];
        final isUnlocked = LocalStorage.isLevelUnlocked(level.id);
        final stars = LocalStorage.getLevelStars(level.id);
        final bestScore = LocalStorage.getLevelBestScore(level.id);

        return _buildLevelCard(level, isUnlocked, stars, bestScore);
      },
    );
  }

  Widget _buildLevelCard(level, bool isUnlocked, int stars, int bestScore) {
    // Get nature-themed color for each level
    final levelColor = _getLevelColor(level.id);
    final animalIcon = _getLevelAnimalIcon(level.id);

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          HapticUtils.mediumImpact();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameScreen(levelId: level.id),
            ),
          );
        } else {
          HapticUtils.heavyImpact();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUnlocked
                ? [
                    levelColor.withOpacity(0.15),
                    AppColors.slate.withOpacity(0.9),
                  ]
                : [
                    AppColors.slate.withOpacity(0.2),
                    AppColors.slate.withOpacity(0.3),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? levelColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: levelColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Background animal watermark
            if (isUnlocked)
              Positioned(
                right: -10,
                bottom: -10,
                child: Opacity(
                  opacity: 0.1,
                  child: FaIcon(animalIcon, size: 80, color: levelColor),
                ),
              ),
            // Lock overlay (must be last to appear on top)
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.slate.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.lock,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.slate.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'LOCKED',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Level badge with animal icon
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isUnlocked
                                ? [levelColor, levelColor.withOpacity(0.7)]
                                : [
                                    AppColors.textSecondary,
                                    AppColors.textSecondary.withOpacity(0.7),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isUnlocked
                              ? [
                                  BoxShadow(
                                    color: levelColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            FaIcon(animalIcon, size: 12, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              '${level.id}',
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUnlocked && stars > 0) _buildStars(stars),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    level.name,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked
                          ? AppColors.mica
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  _buildLevelInfo(level, isUnlocked, levelColor),
                  const SizedBox(height: 10),
                  if (isUnlocked && bestScore > 0)
                    _buildBestScore(bestScore, levelColor)
                  else if (isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: levelColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: levelColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'NEW',
                        style: AppTextStyles.label.copyWith(
                          color: levelColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(int levelId) {
    final colors = [
      const Color(0xFF2ECC71), // Green
      const Color(0xFF3498DB), // Blue
      const Color(0xFFE67E22), // Orange
      const Color(0xFF9B59B6), // Purple
      const Color(0xFF1ABC9C), // Turquoise
      const Color(0xFFE74C3C), // Red
      const Color(0xFFF1C40F), // Yellow
      const Color(0xFF16A085), // Teal
      const Color(0xFF27AE60), // Dark Green
      const Color(0xFF2980B9), // Dark Blue
      const Color(0xFFD35400), // Dark Orange
      const Color(0xFF8E44AD), // Dark Purple
    ];
    return colors[(levelId - 1) % colors.length];
  }

  IconData _getLevelAnimalIcon(int levelId) {
    final icons = [
      FontAwesomeIcons.dog,
      FontAwesomeIcons.cat,
      FontAwesomeIcons.crow,
      FontAwesomeIcons.fish,
      FontAwesomeIcons.frog,
      FontAwesomeIcons.dragon,
      FontAwesomeIcons.dove,
      FontAwesomeIcons.horse,
      FontAwesomeIcons.hippo,
      FontAwesomeIcons.otter,
      FontAwesomeIcons.spider,
      FontAwesomeIcons.shrimp,
    ];
    return icons[(levelId - 1) % icons.length];
  }

  Widget _buildStars(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 2),
            child: FaIcon(
              index < count
                  ? FontAwesomeIcons.solidStar
                  : FontAwesomeIcons.star,
              color: index < count
                  ? const Color(0xFFF1C40F)
                  : Colors.grey.shade700,
              size: 13,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLevelInfo(level, bool isUnlocked, Color levelColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isUnlocked
              ? levelColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.clock,
            size: 12,
            color: isUnlocked ? levelColor : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            '${level.time}s',
            style: AppTextStyles.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? levelColor : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          FaIcon(
            FontAwesomeIcons.tableCells,
            size: 12,
            color: isUnlocked ? levelColor : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            '${level.rows}×${level.cols}',
            style: AppTextStyles.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? levelColor : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestScore(int score, Color levelColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [levelColor.withOpacity(0.3), levelColor.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: levelColor.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(FontAwesomeIcons.trophy, size: 12, color: levelColor),
          const SizedBox(width: 6),
          Text(
            'BEST: ',
            style: AppTextStyles.label.copyWith(
              fontSize: 10,
              color: levelColor.withOpacity(0.8),
            ),
          ),
          Text(
            score.toString(),
            style: AppTextStyles.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: levelColor,
            ),
          ),
        ],
      ),
    );
  }
}
