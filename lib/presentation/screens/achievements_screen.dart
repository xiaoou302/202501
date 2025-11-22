import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/achievement_model.dart';
import '../../data/local/local_storage.dart';
import '../widgets/particle_background.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late List<AchievementModel> _achievements;
  int _totalGames = 0;
  int _totalWins = 0;
  int _totalFails = 0;
  int _totalStars = 0;
  int _completedLevels = 0;

  @override
  void initState() {
    super.initState();
    _loadGameData();
    _loadAchievements();
  }

  void _loadGameData() {
    _totalGames = LocalStorage.getTotalGames();
    _totalWins = LocalStorage.getTotalWins();
    _totalFails = LocalStorage.getTotalFails();

    // Calculate total stars and completed levels
    _totalStars = 0;
    _completedLevels = 0;
    for (var level in GameLevels.levels) {
      final stars = LocalStorage.getLevelStars(level.id);
      if (stars > 0) {
        _totalStars += stars;
        _completedLevels++;
      }
    }
  }

  void _loadAchievements() {
    _achievements = AchievementModel.allAchievements;
    for (var achievement in _achievements) {
      final achievementId = achievement.type.toString().split('.').last;
      achievement.isUnlocked = LocalStorage.isAchievementUnlocked(
        achievementId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(unlockedCount),
                Expanded(child: _buildAchievementsList()),
                _buildStats(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int unlockedCount) {
    final progress = unlockedCount / _achievements.length;
    final progressPercent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.midnight, AppColors.midnight.withOpacity(0)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Row(
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
                        const Color(0xFFF1C40F).withOpacity(0.3),
                        AppColors.slate,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFF1C40F).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFFF1C40F),
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
                          FontAwesomeIcons.trophy,
                          size: 12,
                          color: Color(0xFFF1C40F),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'HALL OF FAME',
                          style: AppTextStyles.label.copyWith(
                            color: const Color(0xFFF1C40F),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Achievements',
                      style: AppTextStyles.h2.copyWith(fontSize: 28),
                    ),
                  ],
                ),
              ),
              // Animal decoration
              const FaIcon(
                FontAwesomeIcons.crown,
                size: 28,
                color: Color(0xFFF1C40F),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF1C40F).withOpacity(0.15),
                  AppColors.slate.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFF1C40F).withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF1C40F).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1C40F).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.medal,
                                size: 16,
                                color: Color(0xFFF1C40F),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'UNLOCKED',
                              style: AppTextStyles.label.copyWith(
                                color: const Color(0xFFF1C40F),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$unlockedCount/${_achievements.length}',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 36,
                            color: const Color(0xFFF1C40F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$progressPercent% Complete',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColors.mica.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    // Circular progress
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.midnight.withOpacity(
                                0.5,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFF1C40F),
                              ),
                              strokeWidth: 8,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                unlockedCount == _achievements.length
                                    ? FontAwesomeIcons.crown
                                    : FontAwesomeIcons.trophy,
                                size: 24,
                                color: const Color(0xFFF1C40F),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$progressPercent%',
                                style: AppTextStyles.stat.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFFF1C40F),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(AchievementModel achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: achievement.isUnlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  achievement.color.withOpacity(0.15),
                  AppColors.slate.withOpacity(0.9),
                ],
              )
            : LinearGradient(
                colors: [
                  AppColors.slate.withOpacity(0.3),
                  AppColors.slate.withOpacity(0.2),
                ],
              ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: achievement.isUnlocked
              ? achievement.color.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: 2,
        ),
        boxShadow: achievement.isUnlocked
            ? [
                BoxShadow(
                  color: achievement.color.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Icon container
          Stack(
            alignment: Alignment.center,
            children: [
              // Background glow
              if (achievement.isUnlocked)
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: achievement.color.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              // Icon circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: achievement.isUnlocked
                      ? LinearGradient(
                          colors: [
                            achievement.color,
                            achievement.color.withOpacity(0.7),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            AppColors.midnight.withOpacity(0.6),
                            AppColors.midnight.withOpacity(0.4),
                          ],
                        ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: achievement.isUnlocked
                        ? achievement.color
                        : AppColors.textSecondary.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    achievement.isUnlocked
                        ? achievement.icon
                        : FontAwesomeIcons.lock,
                    color: achievement.isUnlocked
                        ? Colors.white
                        : AppColors.textSecondary,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.name,
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: achievement.isUnlocked
                              ? achievement.color
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    if (achievement.isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: achievement.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: achievement.color.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.check,
                              size: 10,
                              color: achievement.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'UNLOCKED',
                              style: AppTextStyles.label.copyWith(
                                fontSize: 9,
                                color: achievement.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  achievement.description,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    color: AppColors.mica.withOpacity(
                      achievement.isUnlocked ? 0.85 : 0.5,
                    ),
                    height: 1.4,
                  ),
                ),
                if (!achievement.isUnlocked) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.lock,
                        size: 10,
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Keep playing to unlock',
                        style: AppTextStyles.label.copyWith(
                          fontSize: 10,
                          color: AppColors.textSecondary.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final winRate = _totalGames > 0
        ? (_totalWins / _totalGames * 100).toInt()
        : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColors.midnight, AppColors.midnight.withOpacity(0)],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF2ECC71).withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.chartSimple,
                size: 14,
                color: Color(0xFF2ECC71),
              ),
              const SizedBox(width: 8),
              Text(
                'YOUR JOURNEY STATISTICS',
                style: AppTextStyles.label.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF2ECC71),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Games',
                  _totalGames.toString(),
                  FontAwesomeIcons.gamepad,
                  const Color(0xFF3498DB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Wins',
                  _totalWins.toString(),
                  FontAwesomeIcons.trophy,
                  const Color(0xFFF1C40F),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Win Rate',
                  '$winRate%',
                  FontAwesomeIcons.chartLine,
                  const Color(0xFF2ECC71),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Completed',
                  '$_completedLevels/${GameLevels.levels.length}',
                  FontAwesomeIcons.checkDouble,
                  const Color(0xFF9B59B6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Total Stars',
                  '$_totalStars/${GameLevels.levels.length * 3}',
                  FontAwesomeIcons.star,
                  const Color(0xFFE67E22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Fails',
                  _totalFails.toString(),
                  FontAwesomeIcons.xmark,
                  const Color(0xFFE74C3C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.slate.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
            child: Center(child: FaIcon(icon, color: color, size: 16)),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.stat.copyWith(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 9,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
