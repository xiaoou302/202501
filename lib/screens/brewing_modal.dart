import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/recipe.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';

class BrewingModal extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onClose;

  const BrewingModal({super.key, required this.recipe, required this.onClose});

  @override
  State<BrewingModal> createState() => _BrewingModalState();
}

class _BrewingModalState extends State<BrewingModal>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _totalSeconds = 0;
  int _currentStepIndex = 0;
  int _stepSeconds = 0;
  bool _isRunning = true;

  // Animation for "Breathing" effect
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) return;

      setState(() {
        _totalSeconds++;
        _stepSeconds++;

        // Check step progression
        if (_currentStepIndex < widget.recipe.steps.length) {
          if (_stepSeconds >=
              widget.recipe.steps[_currentStepIndex].durationSeconds) {
            if (_currentStepIndex < widget.recipe.steps.length - 1) {
              _currentStepIndex++;
              _stepSeconds = 0;
            } else {
              // Finished
              _isRunning = false;
              _timer?.cancel();
            }
          }
        }
      });
    });
  }

  String _formatDuration(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = widget.recipe.steps[_currentStepIndex];
    final isFinished = !_isRunning && _timer?.isActive == false;
    final nextStep = _currentStepIndex < widget.recipe.steps.length - 1
        ? widget.recipe.steps[_currentStepIndex + 1]
        : null;

    final stepProgress = isFinished
        ? 1.0
        : (_stepSeconds / currentStep.durationSeconds).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: ColorPalette.charcoal,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorPalette.charcoal, ColorPalette.obsidian],
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 55, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: widget.onClose,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        icon: const Icon(
                          FontAwesomeIcons.xmark,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),

                      // Live Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isRunning
                              ? ColorPalette.rustedCopper.withOpacity(0.2)
                              : ColorPalette.matteSteel.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isRunning
                                ? ColorPalette.rustedCopper.withOpacity(0.5)
                                : ColorPalette.matteSteel.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isRunning
                                      ? _pulseAnimation.value
                                      : 1.0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _isRunning
                                          ? ColorPalette.rustedCopper
                                          : ColorPalette.matteSteel,
                                      shape: BoxShape.circle,
                                      boxShadow: _isRunning
                                          ? [
                                              BoxShadow(
                                                color: ColorPalette.rustedCopper
                                                    .withOpacity(0.6),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isRunning ? "BREWING" : "PAUSED",
                              style: AppTheme.monoStyle.copyWith(
                                color: _isRunning
                                    ? ColorPalette.rustedCopper
                                    : ColorPalette.matteSteel,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Placeholder for balance
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Total Time (Small)
                        Column(
                          children: [
                            Text(
                              "TOTAL TIME",
                              style: AppTheme.monoStyle.copyWith(
                                color: ColorPalette.matteSteel,
                                fontSize: 12,
                                letterSpacing: 3.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatDuration(_totalSeconds),
                              style: AppTheme.monoStyle.copyWith(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),

                        // Main Progress Circle
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background Circle
                              SizedBox(
                                width: 280,
                                height: 280,
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.05),
                                  ),
                                ),
                              ),
                              // Progress Circle
                              SizedBox(
                                width: 280,
                                height: 280,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: stepProgress,
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  builder: (context, value, child) {
                                    return CircularProgressIndicator(
                                      value: value,
                                      strokeWidth: 8,
                                      strokeCap: StrokeCap.round,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            ColorPalette.rustedCopper,
                                          ),
                                    );
                                  },
                                ),
                              ),
                              // Inner Content
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currentStep.description.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "${currentStep.targetWeight}g",
                                    style: AppTheme.monoStyle.copyWith(
                                      color: ColorPalette.rustedCopper,
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "TARGET",
                                    style: AppTheme.monoStyle.copyWith(
                                      color: ColorPalette.matteSteel
                                          .withOpacity(0.5),
                                      fontSize: 10,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Next Step Preview
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: nextStep != null
                              ? Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        FontAwesomeIcons.arrowRight,
                                        color: ColorPalette.matteSteel,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "UP NEXT",
                                            style: AppTheme.monoStyle.copyWith(
                                              color: ColorPalette.matteSteel,
                                              fontSize: 10,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            nextStep.description,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${nextStep.targetWeight}g",
                                      style: AppTheme.monoStyle.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    "ALMOST DONE",
                                    style: AppTheme.monoStyle.copyWith(
                                      color: ColorPalette.extractionGreen,
                                      fontSize: 14,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFinished
                            ? ColorPalette.extractionGreen
                            : Colors.white.withOpacity(0.1),
                        foregroundColor: isFinished
                            ? Colors.white
                            : ColorPalette.matteSteel,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        elevation: isFinished ? 8 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: isFinished
                            ? BorderSide.none
                            : BorderSide(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                      ),
                      child: Text(
                        isFinished ? "FINISH BREWING" : "STOP",
                        style: AppTheme.monoStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
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
