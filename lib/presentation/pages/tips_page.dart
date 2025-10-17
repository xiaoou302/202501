import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Tips and Game Information screen
class TipsPage extends StatefulWidget {
  /// Constructor
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/6.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                decoration: BoxDecoration(
                  color: AppColors.xuanPaperWhite.withOpacity(0.85),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.ebonyBrown,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'The Path of Zen',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ebonyBrown,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.carvedJadeGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.xuanPaperWhite,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                color: AppColors.xuanPaperWhite.withOpacity(0.85),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.carvedJadeGreen,
                  unselectedLabelColor: AppColors.ebonyBrown.withOpacity(0.6),
                  indicatorColor: AppColors.carvedJadeGreen,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: 'ABOUT'),
                    Tab(text: 'HOW TO PLAY'),
                    Tab(text: 'RULES'),
                    Tab(text: 'TIPS'),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // About tab
                    _buildAboutTab(),

                    // How to Play tab
                    _buildHowToPlayTab(),

                    // Rules tab
                    _buildRulesTab(),

                    // Tips tab
                    _buildTipsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard(
          title: 'For Entertainment Only',
          content:
              'Jongara is designed purely for entertainment and puzzle-solving enjoyment. This game does not involve any form of gambling, real money transactions, or betting. It is a skill-based puzzle game focused on strategy and pattern recognition.',
          icon: Icons.verified_user,
          isHighlighted: true,
        ),
        _buildSectionCard(
          title: 'Welcome to Jongara',
          content:
              'Jongara is a modern take on the classic tile-matching puzzle inspired by traditional Mahjong Solitaire. Set in a tranquil East Asian aesthetic, the game offers a meditative yet strategic experience as you match tiles to clear the board.',
          icon: Icons.spa,
        ),
        _buildSectionCard(
          title: 'A Journey of Mindfulness',
          content:
              'Each level in Jongara represents a step along the path to mastery. As you progress, the layouts become more complex, challenging your spatial awareness and strategic thinking. The game is designed to be both relaxing and mentally stimulating.',
          icon: Icons.psychology,
        ),
        _buildSectionCard(
          title: 'Traditional Inspiration',
          content:
              'Jongara draws inspiration from traditional Mahjong tiles and aesthetics, reimagined with our unique "Warm Wood, Carved Jade" visual style. The game combines cultural elements with modern gameplay mechanics for an engaging experience.',
          icon: Icons.palette,
        ),
      ],
    );
  }

  Widget _buildHowToPlayTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard(
          title: 'Basic Gameplay',
          content:
              'Tap on available tiles to select them. A tile is available when it is not blocked by other tiles and has at least one side free. Selected tiles move to your hand at the bottom of the screen.',
          icon: Icons.touch_app,
        ),
        _buildSectionCard(
          title: 'Matching Tiles',
          content:
              'When you collect three identical tiles in your hand, they automatically match and are removed. Your goal is to clear all tiles from the board by making matches.',
          icon: Icons.auto_awesome,
        ),
        _buildSectionCard(
          title: 'Hand Management',
          content:
              'Your hand can hold a maximum of 7 tiles. If your hand becomes full and no matches can be made, you lose the level. Plan your moves carefully to avoid filling your hand with unmatchable tiles.',
          icon: Icons.pan_tool,
        ),
        _buildSectionCard(
          title: 'Power-ups',
          content:
              'Use the Shuffle power-up to rearrange all currently available tiles on the board. The Undo power-up allows you to reverse your last move. Each power-up can be used once per level.',
          icon: Icons.bolt,
        ),
        _buildSectionCard(
          title: 'Winning & Progression',
          content:
              'Clear all tiles to complete a level. As you progress through chapters, layouts become more complex and include more tile types. Master each level to unlock new challenges.',
          icon: Icons.emoji_events,
        ),
      ],
    );
  }

  Widget _buildRulesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionCard(
          title: 'Tile Types',
          content:
              'Jongara features traditional Mahjong tile sets:\n\n• Character tiles (Wan): Numbered 1-9\n• Circle tiles (Tong): Numbered 1-9\n• Bamboo tiles (Tiao): Numbered 1-9\n• Honor tiles: Winds (East, South, West, North) and Dragons (Red, Green, White)',
          icon: Icons.grid_view,
        ),
        _buildSectionCard(
          title: 'Level Structure',
          content:
              'The game is divided into three chapters of increasing difficulty:\n\n• Chapter 1 (Levels 1-3): Simple layouts with fewer tile types\n• Chapter 2 (Levels 4-7): Medium complexity with more tile types\n• Chapter 3 (Levels 8-12): Complex layouts with all tile types',
          icon: Icons.layers,
        ),
        _buildSectionCard(
          title: 'Tile Selection Rules',
          content:
              'A tile can only be selected when:\n\n• It is not covered by another tile\n• It has at least one open side (left or right)\n• Your hand is not full (less than 7 tiles)',
          icon: Icons.rule,
        ),
        _buildSectionCard(
          title: 'Victory Conditions',
          content:
              'You win a level when all tiles are cleared from the board. This requires strategic planning to ensure you can match all tiles without getting stuck.',
          icon: Icons.emoji_events,
        ),
        _buildSectionCard(
          title: 'Defeat Conditions',
          content:
              'You lose a level if your hand becomes full (7 tiles) and no matches can be made. Always plan ahead to avoid this situation.',
          icon: Icons.cancel,
        ),
      ],
    );
  }

  Widget _buildTipsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        TipItem(
          title: 'Clear Top Layers First',
          description:
              'Tiles at the top often block multiple tiles beneath them. Prioritize removing these to reveal more of the board quickly.',
        ),
        TipItem(
          title: 'Plan Your Hand Space',
          description:
              'Your hand has only seven slots. Avoid clicking tiles randomly. Think about which tiles you need and reserve space for critical combinations.',
        ),
        TipItem(
          title: 'Anticipate Revealed Tiles',
          description:
              'Before selecting a tile, try to predict what will be revealed underneath. Sometimes waiting is a better strategy than immediate selection.',
        ),
        TipItem(
          title: 'Use Power-ups Strategically',
          description:
              '"Shuffle" and "Undo" are powerful tools. When you reach a difficult situation, these can help you find a new path to victory.',
        ),
        TipItem(
          title: 'Observe Tile Distribution',
          description:
              'Pay attention to the distribution of tile types on the board. This helps determine which tiles are more likely to form complete sets of three.',
        ),
        TipItem(
          title: 'Patience is Key',
          description:
              'Sometimes the best strategy is to wait patiently rather than hastily picking up seemingly useful tiles. Wait for the right moment to make your move.',
        ),
        TipItem(
          title: 'Create Balanced Hand',
          description:
              'Try to maintain a diverse hand with different tile types rather than collecting too many of one type that might not have a third match available.',
        ),
        TipItem(
          title: 'Focus on Blocked Areas',
          description:
              'Areas with many overlapping tiles should be prioritized. Clearing these congested areas opens up more options for subsequent moves.',
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.beeswaxAmber.withOpacity(0.15)
            : AppColors.xuanPaperWhite.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isHighlighted
            ? Border.all(color: AppColors.beeswaxAmber, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? AppColors.beeswaxAmber.withOpacity(0.2)
                  : AppColors.carvedJadeGreen.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? AppColors.beeswaxAmber
                        : AppColors.carvedJadeGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.xuanPaperWhite, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isHighlighted
                          ? AppColors.beeswaxAmber.darker()
                          : AppColors.carvedJadeGreen.darker(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.ebonyBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for a single tip item
class TipItem extends StatelessWidget {
  /// The tip title
  final String title;

  /// The tip description
  final String description;

  /// Constructor
  const TipItem({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.xuanPaperWhite.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tip header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.carvedJadeGreen.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.carvedJadeGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.tips_and_updates,
                    color: AppColors.xuanPaperWhite,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.carvedJadeGreen.darker(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tip content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.ebonyBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Extension to create darker color variations
extension ColorExtension on Color {
  Color darker([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
