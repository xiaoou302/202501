import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../../models/game_state.dart';
import '../widgets/game_grid.dart';
import '../widgets/hand_tile.dart';
import '../widgets/control_panel.dart';
import '../widgets/status_banner.dart';
import '../widgets/sage_message.dart';
import '../widgets/victory_modal.dart';
import '../widgets/defeat_modal.dart';
import '../widgets/pause_overlay.dart';

class GameScreenView extends StatelessWidget {
  const GameScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/17401765004591_.pic_hd.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    AppColors.inkGreen.withValues(alpha: 0.8),
                    AppColors.inkGreen.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Vignette effect
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            // Main content
            Container(
              child: Column(
                children: [
                  _buildHeader(context, viewModel),
                  Expanded(
                    child: Stack(
                      children: [
                        // Main layout with grid and hand tile
                        Column(
                          children: [
                            // Main game area - grid at top (scrollable if needed)
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 370),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: GameGrid(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Hand tile - always visible at bottom
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 12),
                              child: HandTile(),
                            ),
                          ],
                        ),
                        // Status banner
                        if (viewModel.statusMessage != null)
                          StatusBanner(message: viewModel.statusMessage!),
                        // Sage message
                        if (viewModel.sageMessage != null)
                          SageMessage(
                            message: viewModel.sageMessage!,
                            onDismiss: viewModel.hideSageMessage,
                          ),
                      ],
                    ),
                  ),
                  ControlPanel(),
                ],
              ),
            ),
            const PauseOverlay(),
            if (viewModel.status == GameStatus.victory)
              const VictoryModal(),
            if (viewModel.status == GameStatus.defeat)
              const DefeatModal(),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GameViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.sandalwood.withValues(alpha: 0.95),
            AppColors.sandalwood.withValues(alpha: 0.9),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.antiqueGold.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row with back button and level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: viewModel.showLevelSelect,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.sandalwoodLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.antiqueGold.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: AppColors.antiqueGold,
                        size: 18,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'LEVELS',
                        style: TextStyle(
                          color: AppColors.antiqueGold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      viewModel.currentLevel.color,
                      viewModel.currentLevel.color.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: viewModel.currentLevel.color.withValues(alpha: 0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.ivory,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${viewModel.currentLevel.levelNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: viewModel.currentLevel.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.currentLevel.name.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                icon: Icons.timer,
                label: 'TIME',
                value: _formatTime(viewModel.remainingSeconds),
                valueColor: viewModel.remainingSeconds <= 30
                    ? AppColors.vermillion
                    : AppColors.antiqueGold,
                isWarning: viewModel.remainingSeconds <= 30,
              ),
              _buildStatCard(
                icon: Icons.stars,
                label: 'SCORE',
                value: viewModel.score.toString(),
                valueColor: AppColors.antiqueGold,
              ),
              _buildStatCard(
                icon: Icons.local_fire_department,
                label: 'STREAK',
                value: 'x${viewModel.suitStreak}',
                valueColor: viewModel.suitStreak > 0
                    ? AppColors.vermillion
                    : AppColors.antiqueGold.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    bool isWarning = false,
  }) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.sandalwoodLight.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isWarning
                ? AppColors.vermillion.withValues(alpha: 0.7)
                : AppColors.antiqueGold.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 12,
                  color: valueColor.withValues(alpha: 0.9),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppColors.ivory.withValues(alpha: 0.8),
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
