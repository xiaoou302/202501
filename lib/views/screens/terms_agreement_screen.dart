import 'package:flutter/material.dart';
import '../../core/constants.dart';

class TermsAgreementScreen extends StatefulWidget {
  final VoidCallback onAccept;

  const TermsAgreementScreen({super.key, required this.onAccept});

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen>
    with SingleTickerProviderStateMixin {
  bool _hasScrolledToBottom = false;
  bool _isAgreed = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollPosition);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _checkScrollPosition() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      
      if (currentScroll >= maxScroll - 50 && !_hasScrolledToBottom) {
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.inkGreen,
              AppColors.inkGreenLight,
              const Color(0xFF1A4D3E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.ivory,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.antiqueGold.withValues(alpha: 0.3),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🀄', style: TextStyle(fontSize: 50)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TERMS OF SERVICE',
                      style: TextStyle(
                        color: AppColors.antiqueGold,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please read carefully before playing',
                      style: TextStyle(
                        color: AppColors.ivory.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.sandalwood.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.antiqueGold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(24),
                        children: [
                          _buildImportantNotice(),
                          const SizedBox(height: 24),
                          _buildSection(
                            '1. Entertainment Purpose Only',
                            'PAIKO is a puzzle game that uses Mahjong tiles purely as visual elements for entertainment. This game has ABSOLUTELY NO connection to gambling, betting, or any form of real-money wagering.',
                            Icons.games,
                            AppColors.jadeGreen,
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            '2. Zero Tolerance Policy',
                            'We maintain a STRICT ZERO-TOLERANCE policy against:\n\n• Any form of gambling or betting\n• Illegal activities or misuse\n• Attempts to monetize gameplay\n• Violation of local laws\n\nPAIKO is designed solely as a memory and puzzle challenge.',
                            Icons.block,
                            AppColors.vermillion,
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            '3. No Real Money Involved',
                            'This game does NOT involve:\n\n• Real money transactions\n• Cash prizes or rewards\n• Any form of monetary exchange\n• In-app purchases for gambling\n\nAll gameplay is completely free and for entertainment only.',
                            Icons.money_off,
                            const Color(0xFFD84315),
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            '4. Age Appropriate Content',
                            'PAIKO is suitable for all ages. It is a family-friendly puzzle game focused on memory skills, pattern recognition, and strategic thinking.',
                            Icons.family_restroom,
                            AppColors.jadeBlue,
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            '5. User Responsibilities',
                            'By using PAIKO, you agree to:\n\n• Use the game legally and responsibly\n• Not attempt to modify or reverse engineer\n• Respect the entertainment-only nature\n• Comply with all applicable laws',
                            Icons.assignment_turned_in,
                            AppColors.antiqueGold,
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            '6. Cultural Respect',
                            'Mahjong tiles are used respectfully as a cultural element. We honor the traditional game while creating a completely different gameplay mechanic.',
                            Icons.favorite,
                            const Color(0xFF9C27B0),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.jadeGreen.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.jadeGreen.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.verified_user,
                                  color: AppColors.jadeGreen,
                                  size: 36,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'OUR COMMITMENT',
                                  style: TextStyle(
                                    color: AppColors.jadeGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'We are committed to providing a safe, legal, and enjoyable gaming experience. Any attempt to misuse this game for illegal purposes will not be tolerated.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.ivory.withValues(alpha: 0.9),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                      
                      // Scroll indicator
                      if (!_hasScrolledToBottom)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: 0.5 + (_pulseController.value * 0.5),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.antiqueGold,
                                      size: 32,
                                    ),
                                    Text(
                                      'Scroll to continue',
                                      style: TextStyle(
                                        color: AppColors.antiqueGold,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Agreement checkbox and button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.inkGreen.withValues(alpha: 0.95),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.antiqueGold.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _hasScrolledToBottom
                            ? () {
                                setState(() {
                                  _isAgreed = !_isAgreed;
                                });
                              }
                            : null,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _isAgreed
                                      ? AppColors.jadeGreen
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _hasScrolledToBottom
                                        ? AppColors.antiqueGold
                                        : AppColors.antiqueGold
                                            .withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: _isAgreed
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'I have read and agree to the Terms of Service',
                                  style: TextStyle(
                                    color: _hasScrolledToBottom
                                        ? AppColors.ivory
                                        : AppColors.ivory.withValues(alpha: 0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isAgreed ? widget.onAccept : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.antiqueGold,
                          foregroundColor: AppColors.inkGreen,
                          disabledBackgroundColor:
                              AppColors.sandalwood.withValues(alpha: 0.3),
                          disabledForegroundColor:
                              AppColors.ivory.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'ACCEPT & CONTINUE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
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
    );
  }

  Widget _buildImportantNotice() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.vermillion.withValues(alpha: 0.3),
            AppColors.vermillion.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.vermillion.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.vermillion,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'IMPORTANT NOTICE',
                  style: TextStyle(
                    color: AppColors.vermillion,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This is NOT a gambling game',
                  style: TextStyle(
                    color: AppColors.ivory.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sandalwood.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.antiqueGold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.antiqueGold,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    color: AppColors.ivory.withValues(alpha: 0.9),
                    fontSize: 12,
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
}
