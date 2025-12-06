import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../../core/constants.dart';
import '../../services/gemini_api.dart';

class VictoryModal extends StatefulWidget {
  const VictoryModal({super.key});

  @override
  State<VictoryModal> createState() => _VictoryModalState();
}

class _VictoryModalState extends State<VictoryModal> {
  String? fortune;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFortune();
  }

  Future<void> _loadFortune() async {
    final viewModel = context.read<GameViewModel>();
    final result = await GeminiAPI.generateVictoryFortune(viewModel.score);
    setState(() {
      fortune = result;
      isLoading = false;
    });
  }

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
                border: Border.all(color: AppColors.antiqueGold, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    AppStrings.victory,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.score.toString(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
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
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE6C896)),
                          ),
                          child: Text(
                            AppStrings.zenFortune.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC9A35C),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 60,
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.antiqueGold,
                                    ),
                                  )
                                : Text(
                                    '"${fortune ?? ''}"',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.inkGreen.withOpacity(0.8),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Check if there's a next level
                  if (viewModel.currentLevel.levelNumber < 8) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: viewModel.playNextLevel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.jadeGreen,
                          foregroundColor: AppColors.ivory,
                        ),
                        child: const Text(
                          'Next Level',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
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
