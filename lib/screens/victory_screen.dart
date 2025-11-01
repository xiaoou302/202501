import 'package:flutter/material.dart';
import '../utils/constants.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              AppColors.rubedoRed.withOpacity(0.3),
              AppColors.alchemicalGold.withOpacity(0.1),
              AppColors.voidCharcoal,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - AppSpacing.xl * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Transform.rotate(
                        angle: (1 - value) * 3.14 * 2,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.rubedoRed.withOpacity(0.3),
                                AppColors.alchemicalGold.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.rubedoRed.withOpacity(0.6),
                                blurRadius: 40 * value,
                                spreadRadius: 10 * value,
                              ),
                              BoxShadow(
                                color: AppColors.alchemicalGold.withOpacity(0.4),
                                blurRadius: 60 * value,
                                spreadRadius: 15 * value,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.diamond,
                            size: 120,
                            color: AppColors.rubedoRed,
                            shadows: [
                              Shadow(
                                color: AppColors.alchemicalGold,
                                blurRadius: 30 * value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        AppStrings.victoryMessage,
                        style: TextStyle(
                          fontFamily: AppTextStyles.serifFont,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.alchemicalGold,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: AppColors.alchemicalGold.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: AppRadius.mediumRadius,
                          border: Border.all(
                            color: AppColors.alchemicalGold.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          AppStrings.victoryDescription,
                          style: AppTextStyles.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.rubedoRed.withOpacity(0.2),
                              AppColors.alchemicalGold.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: AppRadius.mediumRadius,
                          border: Border.all(
                            color: AppColors.rubedoRed.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          AppStrings.victorySuccess,
                          style: TextStyle(
                            fontFamily: AppTextStyles.serifFont,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.alabasterWhite,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.alchemicalGold,
                      foregroundColor: AppColors.voidCharcoal,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md + 4,
                      ),
                      elevation: 12,
                      shadowColor: AppColors.alchemicalGold.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mediumRadius,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.refresh, size: 24),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          AppStrings.beginAnew,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
