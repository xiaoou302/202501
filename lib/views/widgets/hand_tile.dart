import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../../core/constants.dart';
import 'tile_content.dart';

class HandTile extends StatelessWidget {
  const HandTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.handTile == null) {
          return const SizedBox.shrink();
        }

        final tile = viewModel.handTile!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.antiqueGold.withOpacity(0.3),
                    AppColors.antiqueGold.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.antiqueGold.withOpacity(0.3),
                ),
              ),
              child: Text(
                AppStrings.currentHand.toUpperCase(),
                style: TextStyle(
                  color: AppColors.antiqueGold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Glow effect
                Container(
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.antiqueGold.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                ),
                // Main tile
                Container(
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFFDF7),
                        Color(0xFFF9F3E3),
                        Color(0xFFF2EBD9),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.antiqueGold,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative corner patterns
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                              left: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                              right: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                              left: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                              right: BorderSide(color: AppColors.antiqueGold.withOpacity(0.3), width: 2),
                            ),
                          ),
                        ),
                      ),
                      // Number indicator
                      Positioned(
                        top: 6,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: tile.numberColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tile.number.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: tile.numberColor,
                            ),
                          ),
                        ),
                      ),
                      // Centered content
                      Positioned.fill(
                        child: Center(
                          child: TileContent(
                            type: tile.type,
                            number: tile.number,
                            scale: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Streak badge
                if (viewModel.suitStreak > 1)
                  Positioned(
                    top: -12,
                    right: -12,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: viewModel.suitStreak > 1 ? 1.0 : 0.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.vermillion,
                              Color(0xFFD32F2F),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.ivory, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.vermillion.withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'x${viewModel.suitStreak}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
