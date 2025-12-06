import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../../core/constants.dart';

class DefeatModal extends StatelessWidget {
  const DefeatModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          color: Colors.black.withOpacity(0.9),
          child: Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.vermillion, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer_off,
                    size: 64,
                    color: AppColors.vermillion,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Time\'s Up!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Score: ${viewModel.score}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.vermillion,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF5E7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE6C896)),
                    ),
                    child: const Text(
                      'Don\'t give up! Try again and beat the clock!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.inkGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => viewModel.initializeGame(
                        levelIndex: viewModel.currentLevel.levelNumber - 1,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.jadeGreen,
                        foregroundColor: AppColors.ivory,
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                        'Level Select',
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
