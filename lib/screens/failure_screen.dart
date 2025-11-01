import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FailureScreen extends StatefulWidget {
  final String failureReason;
  final int failedAtStep;

  const FailureScreen({
    super.key,
    required this.failureReason,
    required this.failedAtStep,
  });

  @override
  State<FailureScreen> createState() => _FailureScreenState();
}

class _FailureScreenState extends State<FailureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: GameConfig.shakeAnimationDuration,
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              AppColors.rubedoRed.withOpacity(0.4),
              AppColors.rubedoRed.withOpacity(0.2),
              AppColors.voidCharcoal,
              Colors.black,
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
                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.rubedoRed.withOpacity(0.4),
                                AppColors.rubedoRed.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.rubedoRed.withOpacity(0.6),
                                blurRadius: 50,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            size: 100,
                            color: AppColors.rubedoRed,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        AppStrings.failureMessage,
                        style: TextStyle(
                          fontFamily: AppTextStyles.serifFont,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.rubedoRed,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: AppColors.rubedoRed.withOpacity(0.8),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.rubedoRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.rubedoRed.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Failed at Step ${widget.failedAtStep}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.rubedoRed,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: AppRadius.mediumRadius,
                          border: Border.all(
                            color: AppColors.rubedoRed.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          widget.failureReason,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.alabasterWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: AppRadius.mediumRadius,
                          border: Border.all(
                            color: AppColors.neutralSteel.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: const [
                            Text(
                              AppStrings.failureDescription,
                              style: TextStyle(
                                fontFamily: AppTextStyles.serifFont,
                                fontSize: 16,
                                color: AppColors.alabasterWhite,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              AppStrings.failureEnd,
                              style: TextStyle(
                                fontFamily: AppTextStyles.serifFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.alabasterWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neutralSteel,
                            foregroundColor: AppColors.alabasterWhite,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md + 4,
                            ),
                            elevation: 8,
                            shadowColor: AppColors.neutralSteel.withOpacity(
                              0.5,
                            ),
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
