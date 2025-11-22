import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../widgets/particle_background.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildObjectiveCard(),
                        const SizedBox(height: 20),
                        Text(
                          'Game Rules',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFFF1C40F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRuleItem(
                          1,
                          'Tap to Flip',
                          'Tap any card to flip it over and reveal the icon underneath.',
                          FontAwesomeIcons.hand,
                          const Color(0xFF3498DB),
                        ),
                        const SizedBox(height: 12),
                        _buildRuleItem(
                          2,
                          'Find Matches',
                          'Tap another card to find its matching pair. Both cards must have the same icon.',
                          FontAwesomeIcons.equals,
                          const Color(0xFF2ECC71),
                        ),
                        const SizedBox(height: 12),
                        _buildRuleItem(
                          3,
                          'Build Combos',
                          'Match cards consecutively without mistakes to build your combo streak for bonus points!',
                          FontAwesomeIcons.fire,
                          const Color(0xFFE67E22),
                        ),
                        const SizedBox(height: 12),
                        _buildRuleItem(
                          4,
                          'Beat the Clock',
                          'Clear all pairs before time runs out to complete the level and earn stars!',
                          FontAwesomeIcons.clock,
                          const Color(0xFFE74C3C),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Star Ratings',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFFF1C40F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildStarRating(),
                        const SizedBox(height: 24),
                        Text(
                          'Pro Tips',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 20,
                            color: const Color(0xFF9B59B6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTipCard(
                          'Memory Pattern',
                          'Try to remember the position of cards you\'ve already flipped to find matches faster.',
                          FontAwesomeIcons.brain,
                          const Color(0xFF9B59B6),
                        ),
                        const SizedBox(height: 12),
                        _buildTipCard(
                          'Observation Phase',
                          'Use the observation phase at the start of each level to memorize card positions before playing.',
                          FontAwesomeIcons.eye,
                          const Color(0xFF1ABC9C),
                        ),
                        const SizedBox(height: 12),
                        _buildTipCard(
                          'Speed Bonus',
                          'Complete levels quickly with more time remaining to earn higher scores and 3-star ratings.',
                          FontAwesomeIcons.gaugeHigh,
                          const Color(0xFFF39C12),
                        ),
                        const SizedBox(height: 32),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.midnight, AppColors.midnight.withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticUtils.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFF1C40F).withOpacity(0.3),
                    AppColors.slate,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFF1C40F).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFFF1C40F),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.gamepad,
                      size: 12,
                      color: Color(0xFFF1C40F),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'GAME GUIDE',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFFF1C40F),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'How to Play',
                  style: AppTextStyles.h2.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF1C40F).withOpacity(0.2),
            AppColors.slate.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF1C40F).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF1C40F).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF1C40F), Color(0xFFF39C12)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF1C40F).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.bullseye,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Objective',
            style: AppTextStyles.h2.copyWith(
              fontSize: 24,
              color: const Color(0xFFF1C40F),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Match all pairs of cards before time runs out to complete each level and advance to the next challenge!',
            style: AppTextStyles.body.copyWith(
              fontSize: 15,
              height: 1.6,
              color: AppColors.mica.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(
    int number,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '$number',
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FaIcon(icon, size: 14, color: Colors.white.withOpacity(0.8)),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 17,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.mica.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF1C40F).withOpacity(0.15),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF1C40F).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildStarRatingRow(3, '>50% Time Remaining', 'Perfect!'),
          const SizedBox(height: 12),
          Divider(color: AppColors.mica.withOpacity(0.1)),
          const SizedBox(height: 12),
          _buildStarRatingRow(2, '20-50% Time Remaining', 'Good Job!'),
          const SizedBox(height: 12),
          Divider(color: AppColors.mica.withOpacity(0.1)),
          const SizedBox(height: 12),
          _buildStarRatingRow(1, '<20% Time Remaining', 'Keep Trying!'),
        ],
      ),
    );
  }

  Widget _buildStarRatingRow(int stars, String condition, String message) {
    return Row(
      children: [
        Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FaIcon(
                index < stars
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                size: 16,
                color: index < stars
                    ? const Color(0xFFF1C40F)
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                condition,
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  color: AppColors.mica.withOpacity(0.9),
                ),
              ),
              Text(
                message,
                style: AppTextStyles.label.copyWith(
                  fontSize: 11,
                  color: const Color(0xFFF1C40F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            AppColors.slate.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.mica.withOpacity(0.8),
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

