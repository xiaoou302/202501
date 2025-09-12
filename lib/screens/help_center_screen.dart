import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Help center screen with FAQs and support information
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  // Track expanded FAQ items
  final Map<int, bool> _expandedItems = {};

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
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction
                      _buildIntroSection(),

                      const SizedBox(height: 32),

                      // FAQs
                      _buildSectionHeader('Frequently Asked Questions',
                          Icons.question_answer_outlined),

                      const SizedBox(height: 16),

                      _buildFAQItem(
                        0,
                        'How do I play Blokko?',
                        'Select two adjacent blocks (horizontally or vertically) on the board, then match them with one of the templates shown at the bottom. Blocks are permanently removed when matched. Win by clearing all blocks from the board.',
                      ),

                      _buildFAQItem(
                        1,
                        'What happens when I can\'t find any matches?',
                        'If you can\'t find any matches with the current templates, use the refresh button at the bottom of the screen to get new templates. Note that isolated blocks (those with no adjacent unremoved blocks) can match with any other block, not just adjacent ones.',
                      ),

                      _buildFAQItem(
                        2,
                        'How do I unlock new levels?',
                        'Complete the current level to unlock the next one in the same mode. There are two modes: 6x6 Classic and 8x8 Challenge, each with their own progression track.',
                      ),

                      _buildFAQItem(
                        3,
                        'How are stars awarded?',
                        'Stars are awarded based on how quickly you complete a level. Complete levels faster to earn more stars!',
                      ),

                      _buildFAQItem(
                        4,
                        'How do I earn achievements?',
                        'Achievements are unlocked by reaching specific milestones in the game, such as winning your first game, maintaining a high win rate, or completing levels within a certain time limit.',
                      ),

                      const SizedBox(height: 32),

                      // Contact support

                      const SizedBox(height: 16),

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
                    'Help Center',
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

  Widget _buildIntroSection() {
    return Container(
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
        borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentMintGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.accentMintGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'How Can We Help You?',
                style: TextStyle(
                  color: AppColors.accentMintGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Find answers to common questions below or contact our support team for more assistance.',
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.accentMintGreen,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMoonWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    final isExpanded = _expandedItems[index] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedItems[index] = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            question,
            style: TextStyle(
              color: isExpanded
                  ? AppColors.accentMintGreen
                  : AppColors.textMoonWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
            color: isExpanded
                ? AppColors.accentMintGreen
                : AppColors.textMoonWhite.withOpacity(0.7),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: AppColors.textMoonWhite.withOpacity(0.9),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
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
          const Text(
            'Contact Support',
            style: TextStyle(
              color: AppColors.textMoonWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'If you couldn\'t find the answer to your question, our support team is here to help.',
            style: TextStyle(
              color: AppColors.textMoonWhite.withOpacity(0.9),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, navigate to contact form or support page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentMintGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email_outlined, size: 18),
                SizedBox(width: 8),
                Text(
                  'CONTACT SUPPORT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
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
