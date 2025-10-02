import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Home screen of the app
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFEAE5E1)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.defaultPadding),
            child: Column(
              children: [
                // Status bar info (time, battery, etc.)
                const SizedBox(height: 40),

                // App title
                const Text(
                  'Glyphion',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGraphite,
                  ),
                ),

                const Text(
                  'A Mindful Sequence Art',
                  style: TextStyle(fontSize: 18, color: AppColors.textGraphite),
                ),

                // Arrow tiles example
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildColorBox(AppColors.arrowBlue),
                            _buildColorBox(
                              AppColors.arrowTerracotta,
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            _buildColorBox(AppColors.arrowGreen),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Tap arrows to clear their flight paths. When the last tile disappears, you\'ll find perfect tranquility and satisfaction.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF8A8A8E),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      // Start Game Button
                      ElevatedButton(
                        onPressed: () {
                          // 导航到主导航界面，默认显示关卡选择标签
                          Navigator.pushNamed(context, AppRoutes.main);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentCoral,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Start Game',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // How to Play Button
                      TextButton(
                        onPressed: () {
                          // 仍然直接导航到详情界面
                          Navigator.pushNamed(context, AppRoutes.details);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textGraphite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          'How to Play',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color, {Widget? child}) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
