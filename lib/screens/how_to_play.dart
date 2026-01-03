import 'package:flutter/material.dart';
import '../core/app_fonts.dart';
import '../core/app_theme.dart';


class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.5,
              colors: [Color(0xFF2D3748), AppTheme.deepBg, Colors.black],
              stops: [0.0, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
               // const SizedBox(height: 48),
                _buildHeader(context),
                const SizedBox(height: 24),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: [
                      _buildStoryPage(),
                      _buildGameplayPage(),
                      _buildObjectivePage(),
                      _buildTipsPage(),
                    ],
                  ),
                ),
                _buildPageIndicator(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(Icons.chevron_left, size: 14, color: Colors.white),
            ),
          ),
          Column(
            children: [
              Text(
                'HOW TO PLAY',
                style: AppFonts.orbitron(
                  fontSize: 14,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Game Guide',
                style: AppFonts.inter(
                  fontSize: 9,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildStoryPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.deepAccent.withValues(alpha: 0.3),
                    AppTheme.deepAccent.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(color: AppTheme.deepAccent.withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(
                Icons.auto_stories,
                size: 50,
                color: AppTheme.deepAccent,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'THE STORY',
            style: AppFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildStorySection(
            'A Puzzle Adventure',
            'Welcome to Solvion, a strategic puzzle game that challenges your mind and tests your problem-solving skills. This is a pure logic game designed for entertainment and mental exercise.',
          ),
          const SizedBox(height: 16),
          _buildImportantNotice(),
          const SizedBox(height: 16),
          _buildStorySection(
            'Card Elements',
            'The game uses playing cards as design elements to create an elegant and familiar visual experience. These cards are purely decorative tools for the puzzle mechanics.',
          ),
          const SizedBox(height: 16),
          _buildStorySection(
            'Your Mission',
            'Navigate through increasingly challenging levels, each requiring strategic thinking and careful planning. Master the art of card arrangement and become a true puzzle solver.',
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4CAF50).withValues(alpha: 0.2),
            const Color(0xFF4CAF50).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info, size: 20, color: Color(0xFF4CAF50)),
              const SizedBox(width: 8),
              Text(
                'IMPORTANT NOTICE',
                style: AppFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4CAF50),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This is a 100% skill-based puzzle game. There is NO gambling, NO betting, and NO real money involved. Cards are used purely as visual elements for the puzzle mechanics.',
            style: AppFonts.inter(
              fontSize: 12,
              color: Colors.white,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Play for fun, challenge your mind, and enjoy the strategic gameplay!',
            style: AppFonts.inter(
              fontSize: 11,
              color: const Color(0xFF4CAF50),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppFonts.orbitron(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepAccent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppFonts.inter(
            fontSize: 13,
            color: Colors.grey[300],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildGameplayPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.deepBlue.withValues(alpha: 0.3),
                    AppTheme.deepBlue.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(color: AppTheme.deepBlue.withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(
                Icons.sports_esports,
                size: 50,
                color: AppTheme.deepBlue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'GAMEPLAY',
            style: AppFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildGameplayRule(
            Icons.grid_view,
            'Game Layout',
            'The game board consists of 7 tableau columns, 4 foundation piles, a buffer zone, and a stock pile.',
          ),
          const SizedBox(height: 16),
          _buildGameplayRule(
            Icons.swap_vert,
            'Tableau Rules',
            'In tableau columns, cards must be arranged in descending order (K→Q→J→...→A) with alternating colors (red-black-red).',
          ),
          const SizedBox(height: 16),
          _buildGameplayRule(
            Icons.arrow_upward,
            'Foundation Rules',
            'Foundation piles must be built in ascending order (A→2→3→...→K) with the same suit.',
          ),
          const SizedBox(height: 16),
          _buildGameplayRule(
            Icons.storage,
            'Buffer Zone',
            'Use buffer slots to temporarily store cards. The number of available slots varies by level difficulty.',
          ),
          const SizedBox(height: 16),
          _buildGameplayRule(
            Icons.style,
            'Stock Pile',
            'Draw cards from the stock pile when needed. You can cycle through the deck multiple times.',
          ),
          const SizedBox(height: 16),
          _buildGameplayRule(
            Icons.touch_app,
            'Moving Cards',
            'Tap a card to select it, then tap a valid destination. You can move sequences of cards together.',
          ),
        ],
      ),
    );
  }

  Widget _buildGameplayRule(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.deepSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.deepBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.deepBlue.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 20, color: AppTheme.deepBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectivePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD700).withValues(alpha: 0.3),
                    const Color(0xFFFFD700).withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(
                Icons.emoji_events,
                size: 50,
                color: Color(0xFFFFD700),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'OBJECTIVE',
            style: AppFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildObjectiveCard(
            'Win Condition',
            'Move all 52 cards to the four foundation piles, building each suit from Ace to King.',
            const Color(0xFF4CAF50),
            Icons.check_circle,
          ),
          const SizedBox(height: 16),
          _buildObjectiveCard(
            'Star Rating',
            'Complete levels quickly and efficiently to earn up to 3 stars. Better performance = more stars!',
            const Color(0xFFFFD700),
            Icons.star,
          ),
          const SizedBox(height: 16),
          _buildObjectiveCard(
            'Level Progression',
            'Each level increases in difficulty with fewer buffer slots and optional time limits.',
            const Color(0xFFFF9800),
            Icons.trending_up,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.deepAccent.withValues(alpha: 0.2),
                  AppTheme.deepAccent.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.deepAccent.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.lightbulb, size: 32, color: AppTheme.deepAccent),
                const SizedBox(height: 12),
                Text(
                  'STRATEGY TIP',
                  style: AppFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepAccent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Plan your moves carefully! Sometimes the best move isn\'t the obvious one. Think ahead and use the buffer wisely.',
                  style: AppFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[300],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveCard(String title, String description, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[300],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF9C27B0).withValues(alpha: 0.3),
                    const Color(0xFF9C27B0).withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(
                Icons.tips_and_updates,
                size: 50,
                color: Color(0xFF9C27B0),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'PRO TIPS',
            style: AppFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildTipItem(
            '1',
            'Expose Hidden Cards',
            'Always prioritize moves that reveal face-down cards in the tableau.',
            const Color(0xFF2196F3),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            '2',
            'Empty Columns',
            'Try to create empty tableau columns - they can only hold Kings but are very valuable.',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            '3',
            'Buffer Management',
            'Don\'t fill all buffer slots at once. Keep some free for emergency moves.',
            const Color(0xFFFF9800),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            '4',
            'Foundation Timing',
            'Don\'t rush to move cards to foundations. Sometimes keeping them in tableau is more useful.',
            const Color(0xFF9C27B0),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            '5',
            'Think Ahead',
            'Before making a move, consider how it affects your future options.',
            const Color(0xFFFF5722),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            '6',
            'Use Undo Wisely',
            'The undo button is your friend! Don\'t be afraid to try different approaches.',
            const Color(0xFF00BCD4),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFD700).withValues(alpha: 0.2),
                  const Color(0xFFFFD700).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.5), width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.celebration, size: 40, color: Color(0xFFFFD700)),
                const SizedBox(height: 12),
                Text(
                  'READY TO PLAY?',
                  style: AppFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You now have all the knowledge you need to master Solvion. Good luck and have fun!',
                  style: AppFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[300],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String number, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.deepSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: Text(
                number,
                style: AppFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[400],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? AppTheme.deepAccent
                  : Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
