import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/glass_panel.dart';

class SimpleContentPage extends StatelessWidget {
  final String title;
  final String content;

  const SimpleContentPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.voidBlack,
                    AppColors.deepTeal.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.starlightWhite,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: GlassPanel(
                      borderRadius: BorderRadius.circular(24),
                      borderColor: AppColors.starlightWhite.withValues(
                        alpha: 0.1,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: MarkdownBody(
                          data: content,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              color: AppColors.mossMuted,
                              fontSize: 15,
                              height: 1.6,
                            ),
                            h1: const TextStyle(
                              color: AppColors.starlightWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 2.0,
                            ),
                            h2: const TextStyle(
                              color: AppColors.aquaCyan,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 2.0,
                              letterSpacing: 0.5,
                            ),
                            h3: const TextStyle(
                              color: AppColors.floraNeon,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.8,
                            ),
                            strong: const TextStyle(
                              color: AppColors.starlightWhite,
                              fontWeight: FontWeight.bold,
                            ),
                            listBullet: const TextStyle(
                              color: AppColors.alienPurple,
                              fontSize: 16,
                            ),
                            blockSpacing: 16,
                          ),
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
