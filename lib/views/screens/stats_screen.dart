import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../viewmodels/game_viewmodel.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatScore(int score) {
    if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}K';
    }
    return score.toString();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameViewModel>();
    final playerData = viewModel.playerData;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.inkGreen,
            AppColors.inkGreenLight,
            const Color(0xFF1A4D3E),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, viewModel),
            
            // Stats Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Overall Stats
                  _buildSectionTitle('Overall Statistics'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.sports_esports,
                          label: 'Games Played',
                          value: playerData.gamesPlayed.toString(),
                          color: AppColors.jadeBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.emoji_events,
                          label: 'Victories',
                          value: playerData.victories.toString(),
                          color: AppColors.antiqueGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.percent,
                          label: 'Win Rate',
                          value: '${playerData.winRate.toStringAsFixed(0)}%',
                          color: AppColors.jadeGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.stars,
                          label: 'Total Score',
                          value: _formatScore(playerData.totalScore),
                          color: AppColors.vermillion,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Best Records
                  _buildSectionTitle('Best Records'),
                  const SizedBox(height: 12),
                  _buildRecordCard(
                    icon: Icons.timer,
                    title: 'Fastest Win',
                    value: _formatDuration(playerData.fastestWin),
                    subtitle: playerData.fastestWin != null ? 'Personal Best' : 'Not yet achieved',
                    color: AppColors.jadeBlue,
                  ),
                  const SizedBox(height: 12),
                  _buildRecordCard(
                    icon: Icons.trending_up,
                    title: 'Highest Score',
                    value: playerData.highestScore.toString(),
                    subtitle: playerData.highestScore > 0 ? 'Personal Best' : 'Not yet achieved',
                    color: AppColors.antiqueGold,
                  ),
                  const SizedBox(height: 12),
                  _buildRecordCard(
                    icon: Icons.local_fire_department,
                    title: 'Best Streak',
                    value: 'x${playerData.bestStreak}',
                    subtitle: playerData.bestStreak > 0 ? 'Personal Best' : 'Not yet achieved',
                    color: AppColors.vermillion,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Level Progress
                  _buildSectionTitle('Level Progress'),
                  const SizedBox(height: 12),
                  ...List.generate(8, (index) {
                    final level = GameLevels.levels[index];
                    final stats = playerData.levelStats[level.levelNumber];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildLevelProgress(
                        levelNumber: level.levelNumber,
                        levelName: level.name,
                        completions: stats?.completions ?? 0,
                        bestTime: _formatDuration(stats?.bestTime),
                        color: level.color,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.sandalwood.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.antiqueGold),
                  onPressed: () => viewModel.navigateToHome(),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    'STATISTICS',
                    style: TextStyle(
                      color: AppColors.antiqueGold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 70,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.antiqueGold,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Track Your Progress',
            style: TextStyle(
              color: AppColors.ivory.withOpacity(0.7),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: AppColors.antiqueGold,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.ivory,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.ivory.withOpacity(0.7),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.ivory, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.ivory.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.ivory.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress({
    required int levelNumber,
    required String levelName,
    required int completions,
    required String bestTime,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ivory, width: 2),
            ),
            child: Center(
              child: Text(
                '$levelNumber',
                style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  levelName,
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  completions > 0
                      ? 'Completed $completions ${completions == 1 ? 'time' : 'times'}'
                      : 'Not completed yet',
                  style: TextStyle(
                    color: AppColors.ivory.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.timer,
                color: AppColors.antiqueGold.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(height: 2),
              Text(
                bestTime,
                style: TextStyle(
                  color: AppColors.antiqueGold,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
