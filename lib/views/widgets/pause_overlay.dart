import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../../core/constants.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, _) {
        if (!viewModel.isPaused) return const SizedBox.shrink();

        return Container(
          color: Colors.black.withOpacity(0.85),
          child: Center(
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.antiqueGold, width: 3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.pause_circle_filled,
                    size: 64,
                    color: AppColors.antiqueGold,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PAUSED',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkGreen,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: viewModel.togglePause,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.jadeGreen,
                        foregroundColor: AppColors.ivory,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow),
                          SizedBox(width: 8),
                          Text(
                            'Resume',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: viewModel.showLevelSelect,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.inkGreen,
                        side: const BorderSide(color: AppColors.inkGreen, width: 2),
                      ),
                      child: const Text(
                        'Quit to Levels',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
