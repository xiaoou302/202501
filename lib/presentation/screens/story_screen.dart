import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Story screen - Game background and lore
class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.parchmentGradient,
          ),
          image: DecorationImage(
            image: NetworkImage(
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
            ),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.parchmentDark.withOpacity(0.3),
                      AppColors.parchmentMedium.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderMedium, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowBrown.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inkBlack.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                        iconSize: 20,
                        onPressed: () => Navigator.pop(context),
                        color: AppColors.inkBrown,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'The Tale of Zenion',
                            style: TextStyle(
                              color: AppColors.inkBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'The Fading Codex',
                            style: TextStyle(
                              color: AppColors.inkFaded,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.auto_stories_rounded,
                      color: AppColors.magicGold,
                      size: 28,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.parchmentLight,
                          AppColors.parchmentMedium.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.borderMedium,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowBrown.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with decoration
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.auto_stories_outlined,
                                color: AppColors.magicGold,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'The Forgotten Tome',
                                style: TextStyle(
                                  color: AppColors.magicGold,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 2,
                                width: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppColors.goldGradient,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Introduction
                        _buildSection(
                          icon: Icons.menu_book_rounded,
                          title: 'The Call of Destiny',
                          content:
                              'In the depths of a forgotten library, there exists an ancient codex that holds the memories of a thousand lifetimes. This magical manuscript, known as the "Fading Codex," is being consumed by an invisible force—its words vanishing into the void of oblivion, one letter at a time.\n\nYou are not an ordinary reader. You have been chosen as a "Story Guardian," one of the rare souls who can perceive the fading text and possess the power to rescue these precious narratives before they dissolve into nothingness forever.',
                        ),

                        const SizedBox(height: 24),

                        // Your Mission
                        _buildSection(
                          icon: Icons.flag_rounded,
                          title: 'Your Sacred Mission',
                          content:
                              'Your task is to race against time itself. As each chapter begins to fade, you must identify and capture the Keywords—the essential words that form the skeleton of each story. These are the names of heroes, the locations of great battles, the actions that changed destinies.\n\nEach keyword you save becomes eternal, preserved in your Memory Gallery. With enough keywords rescued, you can reconstruct the complete story and unlock the secrets hidden within the Codex.',
                        ),

                        const SizedBox(height: 24),

                        // How to Play
                        _buildSection(
                          icon: Icons.touch_app_rounded,
                          title: 'How to Play',
                          content: '',
                          children: [
                            _buildBulletPoint(
                              '📖 Phase 1: Collection',
                              'Watch as keywords glow with magical light. Tap them quickly to save them to your collection!',
                            ),
                            _buildBulletPoint(
                              '🔧 Phase 2: Restoration',
                              'Fill in the blanks by dragging your collected keywords or typing them directly into the gaps.',
                            ),
                            _buildBulletPoint(
                              '⭐ Complete with 100% Accuracy',
                              'Only perfect restoration unlocks the next chapter. Every word matters!',
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Game Rules
                        _buildSection(
                          icon: Icons.gavel_rounded,
                          title: 'The Sacred Rules',
                          content: '',
                          children: [
                            _buildRuleCard(
                              '⏰ Time Pressure',
                              'Each chapter has a time limit. Keywords glow 3 times—capture them while you can!',
                              AppColors.magicBlue,
                            ),
                            _buildRuleCard(
                              '✨ Star Rating',
                              '3 Stars: All keywords saved\n2 Stars: Most keywords saved\n1 Star: Minimum keywords saved',
                              AppColors.magicGold,
                            ),
                            _buildRuleCard(
                              '🔓 Chapter Unlock',
                              'Achieve 100% accuracy to unlock the next chapter. Perfection is the key!',
                              AppColors.magicPurple,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Tips & Strategies
                        _buildSection(
                          icon: Icons.lightbulb_rounded,
                          title: 'Guardian\'s Wisdom',
                          content: '',
                          children: [
                            _buildTipCard(
                              '👀 Stay Focused',
                              'Keywords glow briefly. Keep your eyes on the text and tap quickly!',
                            ),
                            _buildTipCard(
                              '🎯 Prioritize',
                              'Some keywords appear more than others. Collect what you can!',
                            ),
                            _buildTipCard(
                              '✍️ Use Input Wisely',
                              'In Phase 2, you can type keywords directly if you remember them.',
                            ),
                            _buildTipCard(
                              '🔄 Practice Makes Perfect',
                              'Each chapter can be replayed. Learn the patterns and improve!',
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Closing quote
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.magicGold.withOpacity(0.1),
                                AppColors.magicBlue.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.magicGold.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.format_quote_rounded,
                                color: AppColors.magicGold,
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'In the dust of oblivion,\nrescue the fading memories.\nBecome the last guardian\nof the stories that must not be forgotten.',
                                style: TextStyle(
                                  color: AppColors.inkBrown,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '— The Codex of Eternity',
                                style: TextStyle(
                                  color: AppColors.magicGold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.goldGradient),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.magicGold.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.magicGold.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle_rounded, size: 24),
                    label: const Text(
                      'Begin Your Journey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    List<Widget>? children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.magicGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.magicGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: AppColors.magicGold, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.inkBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (content.isNotEmpty)
          Text(
            content,
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 15,
              height: 1.7,
              letterSpacing: 0.2,
            ),
          ),
        if (children != null) ...children,
      ],
    );
  }

  Widget _buildBulletPoint(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.magicBlue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                color: AppColors.inkBrown,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(String title, String content, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.parchmentDark.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.magicGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                color: AppColors.inkBrown,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
