import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../viewmodels/game_viewmodel.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

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
            
            // Achievements List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildAchievementCard(
                    icon: Icons.emoji_events,
                    title: 'First Victory',
                    description: 'Complete your first level',
                    isUnlocked: playerData.hasAchievement('first_victory'),
                    color: AppColors.antiqueGold,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    icon: Icons.speed,
                    title: 'Speed Demon',
                    description: 'Complete a level in under 2 minutes',
                    isUnlocked: playerData.hasAchievement('speed_demon'),
                    color: AppColors.vermillion,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    icon: Icons.local_fire_department,
                    title: 'Streak Master',
                    description: 'Achieve a 10x streak',
                    isUnlocked: playerData.hasAchievement('streak_master'),
                    color: Color(0xFFFF6F00),
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    icon: Icons.star,
                    title: 'Perfect Score',
                    description: 'Complete a level without using any power-ups',
                    isUnlocked: playerData.hasAchievement('perfect_score'),
                    color: AppColors.jadeGreen,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    icon: Icons.workspace_premium,
                    title: 'Legend',
                    description: 'Complete all 8 levels',
                    isUnlocked: playerData.hasAchievement('legend'),
                    color: Color(0xFF9C27B0),
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    icon: Icons.psychology,
                    title: 'Memory Master',
                    description: 'Complete level 8 without using power-ups',
                    isUnlocked: playerData.hasAchievement('memory_master'),
                    color: AppColors.jadeBlue,
                  ),
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
                    'ACHIEVEMENTS',
                    style: TextStyle(
                      color: AppColors.antiqueGold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
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
            'Unlock Your Greatness',
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

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isUnlocked,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isUnlocked
              ? [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ]
              : [
                  Colors.grey.shade800.withOpacity(0.3),
                  Colors.grey.shade900.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? color.withOpacity(0.5)
              : Colors.grey.shade700.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isUnlocked ? color : Colors.grey.shade700,
              shape: BoxShape.circle,
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: AppColors.ivory,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isUnlocked
                              ? AppColors.ivory
                              : AppColors.ivory.withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isUnlocked)
                      Icon(
                        Icons.check_circle,
                        color: color,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isUnlocked
                        ? AppColors.ivory.withOpacity(0.7)
                        : AppColors.ivory.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
