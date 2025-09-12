import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 帮助界面
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDeepSpaceGray,
              AppColors.bgDeepSpaceGray.withBlue(70),
            ],
            stops: const [0.2, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header bar
              _buildHeader(context),

              // Help content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction card
                      _buildIntroductionCard(),
                      const SizedBox(height: 24),

                      // Game objective
                      _buildHelpSection(
                        'Game Objective',
                        'Clear all blocks from the board by matching them with templates before running out of possible moves.',
                        icon: Icons.flag_rounded,
                      ),
                      const SizedBox(height: 24),

                      // Core gameplay
                      _buildHelpSection(
                        'How to Play',
                        null,
                        icon: Icons.sports_esports_rounded,
                        steps: [
                          _buildHelpStep(
                            1,
                            'Select two adjacent blocks (horizontally or vertically) on the board.',
                            highlight: 'adjacent',
                          ),
                          _buildHelpStep(
                            2,
                            'Check the templates at the bottom. The blocks must match a template exactly in color, order, and orientation.',
                            highlight: 'match exactly',
                          ),
                          _buildHelpStep(
                            3,
                            'Tap the matching template to remove the blocks from the board.',
                            highlight: 'remove',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Important rules
                      _buildHelpSection(
                        'Important Rules',
                        'Blocks are permanently removed and will not refill. Plan each move carefully!',
                        icon: Icons.warning_amber_rounded,
                        highlightText: 'not refill',
                        highlightColor: AppColors.blockCoralPink,
                      ),
                      const SizedBox(height: 24),

                      // Game modes
                      _buildHelpSection(
                        'Game Modes',
                        null,
                        icon: Icons.grid_view_rounded,
                        steps: [
                          _buildHelpStep(
                            null,
                            '6x6 Classic: Smaller board, perfect for beginners.',
                            iconData: Icons.grid_3x3_rounded,
                            iconColor: AppColors.blockSkyBlue,
                          ),
                          _buildHelpStep(
                            null,
                            '8x8 Challenge: Larger board with increased difficulty.',
                            iconData: Icons.grid_4x4_rounded,
                            iconColor: AppColors.blockCoralPink,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Game tips
                      _buildHelpSection(
                        'Pro Tips',
                        null,
                        icon: Icons.lightbulb_rounded,
                        steps: [
                          _buildHelpStep(
                            null,
                            'Prioritize areas that might create isolated blocks.',
                            iconData: Icons.priority_high_rounded,
                            iconColor: AppColors.blockSunnyYellow,
                          ),
                          _buildHelpStep(
                            null,
                            'Always check all four templates for the best possible match.',
                            iconData: Icons.visibility_rounded,
                            iconColor: AppColors.blockGrapePurple,
                          ),
                          _buildHelpStep(
                            null,
                            'Use the refresh button when you can\'t find any matches.',
                            iconData: Icons.refresh_rounded,
                            iconColor: AppColors.blockJadeGreen,
                          ),
                          _buildHelpStep(
                            null,
                            'Isolated blocks can match with any other block, not just adjacent ones.',
                            iconData: Icons.extension_rounded,
                            iconColor: AppColors.blockTerracottaOrange,
                          ),
                        ],
                      ),

                      // Controls section
                      const SizedBox(height: 24),
                      _buildHelpSection(
                        'Controls',
                        null,
                        icon: Icons.touch_app_rounded,
                        steps: [
                          _buildHelpStep(
                            null,
                            'Tap a block to select it.',
                            iconData: Icons.radio_button_unchecked_rounded,
                            iconColor: AppColors.accentMintGreen,
                          ),
                          _buildHelpStep(
                            null,
                            'Tap another block to create a pair.',
                            iconData: Icons.radio_button_checked_rounded,
                            iconColor: AppColors.accentMintGreen,
                          ),
                          _buildHelpStep(
                            null,
                            'Tap a template at the bottom to match.',
                            iconData: Icons.check_circle_outline_rounded,
                            iconColor: AppColors.accentMintGreen,
                          ),
                          _buildHelpStep(
                            null,
                            'Tap the refresh button to get new templates.',
                            iconData: Icons.refresh_rounded,
                            iconColor: AppColors.accentMintGreen,
                          ),
                        ],
                      ),

                      // Bottom spacing
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textMoonWhite,
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.accentMintGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Game Help',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Placeholder for layout balance
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildIntroductionCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentMintGreen.withOpacity(0.2),
            AppColors.accentMintGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.accentMintGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentMintGreen.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.accentMintGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'WELCOME TO BLOKKO',
                style: TextStyle(
                  color: AppColors.accentMintGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Blokko is a strategic puzzle game where you match and clear blocks using pattern templates. This guide will help you understand the game mechanics and strategies to master the game.',
            style: TextStyle(
              color: AppColors.textMoonWhite,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(
    String title,
    String? description, {
    List<Widget>? steps,
    String? highlightText,
    Color highlightColor = AppColors.accentMintGreen,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with icon
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: highlightColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: highlightColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: TextStyle(
                  color: highlightColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          // Description text
          if (description != null && highlightText == null) ...[
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                color: AppColors.textMoonWhite.withOpacity(0.9),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],

          // Description with highlighted text
          if (highlightText != null && description != null) ...[
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: _buildHighlightedText(
                    description, highlightText, highlightColor),
              ),
              style: TextStyle(
                color: AppColors.textMoonWhite.withOpacity(0.9),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],

          // Steps list
          if (steps != null) ...[
            const SizedBox(height: 16),
            ...steps,
          ],
        ],
      ),
    );
  }

  Widget _buildHelpStep(
    int? number,
    String text, {
    String? highlight,
    IconData? iconData,
    Color iconColor = AppColors.accentMintGreen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numbered step or icon
          if (number != null) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accentMintGreen.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentMintGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: AppColors.accentMintGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ] else if (iconData != null) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Step text content
          Expanded(
            child: highlight != null
                ? Text.rich(
                    TextSpan(
                      children: _buildHighlightedText(
                          text, highlight, AppColors.accentMintGreen),
                    ),
                    style: TextStyle(
                      color: AppColors.textMoonWhite.withOpacity(0.9),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: AppColors.textMoonWhite.withOpacity(0.9),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(String text, String highlight,
      [Color highlightColor = AppColors.accentMintGreen]) {
    final parts = text.split(highlight);
    final result = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      result.add(TextSpan(text: parts[i]));
      if (i < parts.length - 1) {
        result.add(TextSpan(
          text: highlight,
          style: TextStyle(
            color: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ));
      }
    }

    return result;
  }
}
