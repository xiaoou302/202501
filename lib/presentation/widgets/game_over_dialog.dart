import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Dialog shown when the game is over (win or loss)
class GameOverDialog extends StatelessWidget {
  /// Whether the player won
  final bool isWin;

  /// The current level number
  final int level;

  /// Callback when the retry button is pressed
  final VoidCallback onRetry;

  /// Callback when the next level button is pressed
  final VoidCallback onNextLevel;

  /// Callback when the back button is pressed
  final VoidCallback onBack;

  /// Constructor
  const GameOverDialog({
    super.key,
    required this.isWin,
    required this.level,
    required this.onRetry,
    required this.onNextLevel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
          image: const DecorationImage(
            image: AssetImage('assets/3.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy or game over icon
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isWin
                          ? AppColors.beeswaxAmber.withOpacity(0.3)
                          : Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isWin
                            ? AppColors.beeswaxAmber
                            : Colors.red.withOpacity(0.7),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isWin ? AppColors.beeswaxAmber : Colors.red)
                              .withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      isWin ? Icons.emoji_events : Icons.cancel_outlined,
                      color: isWin
                          ? AppColors.beeswaxAmber
                          : Colors.red.shade300,
                      size: 40,
                    ),
                  ),

                  // Title
                  Text(
                    isWin ? 'LEVEL COMPLETE!' : 'GAME OVER',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Message
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Text(
                      isWin
                          ? 'Congratulations on completing level $level!'
                          : 'Your hand is full. Try again!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Column(
                    children: [
                      if (!isWin)
                        _buildButton(
                          onPressed: onRetry,
                          label: 'RETRY LEVEL',
                          isPrimary: true,
                          icon: Icons.refresh,
                        ),
                      if (isWin && level < 12) ...[
                        _buildButton(
                          onPressed: onNextLevel,
                          label: 'NEXT LEVEL',
                          isPrimary: true,
                          icon: Icons.arrow_forward,
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 12),
                      _buildButton(
                        onPressed: onBack,
                        label: 'BACK TO LEVEL SELECT',
                        isPrimary: false,
                        icon: Icons.menu,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    required bool isPrimary,
    required IconData icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppColors.carvedJadeGreen
              : Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: isPrimary ? 5 : 0,
          shadowColor: isPrimary
              ? AppColors.carvedJadeGreen.withOpacity(0.5)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: isPrimary ? 1.2 : 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
