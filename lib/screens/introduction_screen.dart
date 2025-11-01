import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: AppStrings.introductionTitle,
        onHomePressed: () => Navigator.pop(context),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              _buildStorySection(),
              const SizedBox(height: AppSpacing.xl),
              _buildMentorSection(),
              const SizedBox(height: AppSpacing.xl),
              _buildChallengeSection(),
              const SizedBox(height: AppSpacing.xl),
              _buildGameplaySection(),
              const SizedBox(height: AppSpacing.xl),
              _buildWarningSection(),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            AppColors.alchemicalGold.withOpacity(0.2),
            AppColors.rubedoRed.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: AppRadius.largeRadius,
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_stories,
            size: 56,
            color: AppColors.alchemicalGold,
            shadows: [
              Shadow(
                color: AppColors.alchemicalGold.withOpacity(0.6),
                blurRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'THE ALCHEMIST\'S PARADOX',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.rubedoRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.rubedoRed.withOpacity(0.3)),
            ),
            child: const Text(
              'A Tale of Obsession and Legacy',
              style: TextStyle(
                fontFamily: AppTextStyles.serifFont,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.alabasterWhite,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorySection() {
    return _buildSection(
      icon: Icons.history_edu,
      iconColor: AppColors.alchemicalGold,
      title: 'The Inheritance',
      children: [
        _buildStoryCard(
          'The winter of 1753 was merciless. In a forgotten tower on the outskirts of Prague, Master Aurelius—the last of the great alchemists—lay dying. His life\'s work, forty-seven years of obsessive pursuit, had yielded nothing but ash and regret.',
        ),
        _buildStoryCard(
          'You arrived at midnight, summoned by his final letter. The study was in chaos—burned manuscripts, shattered glassware, the acrid smell of failed experiments. But on his desk, illuminated by a single candle, lay a leather-bound journal.',
        ),
        _buildQuoteCard(
          text:
              '"My dearest apprentice," his voice was barely a whisper, "I have failed. Forty-seven times I entered that laboratory. Forty-seven times I emerged in defeat. But I have learned... oh, how I have learned."',
          author: 'Master Aurelius, final words',
        ),
        _buildStoryCard(
          'With trembling hands, he pressed the journal into yours. Its pages were filled with cryptic symbols, encrypted notes, and desperate annotations. The Great Work—the creation of the Philosopher\'s Stone—lay within, but the sequence was deliberately obscured.',
        ),
        _buildStoryCard(
          '"The knowledge is too dangerous for the unworthy," he gasped. "I have hidden the true path within riddles and metaphors. Only one with a sharp mind and patient heart can decipher it. You are my last hope. Complete what I could not."',
        ),
      ],
    );
  }

  Widget _buildMentorSection() {
    return _buildSection(
      icon: Icons.person,
      iconColor: AppColors.neutralSteel,
      title: 'The Mentor\'s Legacy',
      children: [
        _buildStoryCard(
          'Master Aurelius was not always a broken man. In his youth, he was celebrated—a prodigy who decoded ancient texts, a scholar who bridged science and mysticism. But the Philosopher\'s Stone became his obsession, his curse.',
        ),
        _buildHighlightCard(
          icon: Icons.warning_amber,
          title: 'The Forty-Seven Failures',
          description:
              'Each attempt cost him dearly. The first ten were mere setbacks. By the twentieth, he had lost his fortune. By the thirtieth, his reputation. By the fortieth, his health. The final seven attempts nearly killed him.',
          color: AppColors.rubedoRed,
        ),
        _buildStoryCard(
          'Yet with each failure, he learned. He discovered that the Great Work has not one path, but three—the Phoenix, the Serpent, and the Dragon. He learned that the materials themselves held symbolic meaning. He understood that the sequence was everything.',
        ),
        _buildStoryCard(
          'But understanding and execution are different beasts. The laboratory is unforgiving. One wrong step, one misplaced material, and the mixture becomes volatile. Explosive. Fatal.',
        ),
        _buildQuoteCard(
          text:
              '"The Study is where wisdom is born. The Laboratory is where fools die. Know the difference, my apprentice. Know it well."',
          author: 'Journal of the Great Work, Page 1',
        ),
      ],
    );
  }

  Widget _buildChallengeSection() {
    return _buildSection(
      icon: Icons.psychology,
      iconColor: AppColors.rubedoRed,
      title: 'Your Challenge',
      children: [
        _buildStoryCard(
          'Now the burden falls to you. The journal is yours. The laboratory is prepared. The materials are assembled. But the path forward is shrouded in mystery.',
        ),
        _buildHighlightCard(
          icon: Icons.menu_book,
          title: 'The Encrypted Journal',
          description:
              'Master Aurelius\'s notes are intentionally cryptic. He speaks of "Red Kings" and "White Queens," of "Lions" that must be "tamed," of "Eagles" that must "ascend." Some clues are direct. Others are metaphorical. Some may even be false.',
          color: AppColors.alchemicalGold,
        ),
        _buildHighlightCard(
          icon: Icons.science,
          title: 'The Twelve Steps',
          description:
              'The Great Work requires exactly twelve steps, performed in perfect sequence. Each step combines an Action (Dissolve, Combine, Calcify, Sublimate) with a Material (seven sacred substances). There are 336 possible combinations per step. The correct sequence is one in billions.',
          color: AppColors.alchemicalGold,
        ),
        _buildHighlightCard(
          icon: Icons.local_fire_department,
          title: 'The Laboratory\'s Judgment',
          description:
              'Once you lock your recipe and enter the laboratory, there is no mercy. You must execute all twelve steps flawlessly. The mixture is volatile—one error triggers a catastrophic chain reaction. Your mentor survived his failures through luck and quick reflexes. You may not be so fortunate.',
          color: AppColors.rubedoRed,
        ),
      ],
    );
  }

  Widget _buildGameplaySection() {
    return _buildSection(
      icon: Icons.explore,
      iconColor: AppColors.alchemicalGold,
      title: 'The Path Forward',
      children: [
        _buildStoryCard(
          'Your journey begins in the Study—a sanctuary of contemplation. Here, you are safe to experiment, to hypothesize, to fail without consequence. Read the journal carefully. Look for patterns. Connect the clues.',
        ),
        _buildStepCard(
          number: 1,
          title: 'Decipher the Journal',
          description:
              'Study the Encrypted Log. Master Aurelius has left you everything you need, but nothing is straightforward. Words in [brackets] are particularly significant. Pay attention to step numbers, material frequencies, and action patterns.',
        ),
        _buildStepCard(
          number: 2,
          title: 'Arrange the Recipe',
          description:
              'Use the Recipe Slate to organize your hypothesis. Twelve steps, twelve chances to get it right. Each step requires an action and a material. Take your time—the Study judges not.',
        ),
        _buildStepCard(
          number: 3,
          title: 'Lock Your Recipe',
          description:
              'When you are certain—truly certain—lock your recipe. This is the point of no return. The laboratory doors will open, and your theory will face the ultimate test.',
        ),
        _buildStepCard(
          number: 4,
          title: 'Execute with Precision',
          description:
              'In the laboratory, you must manually perform each step. Select the action, select the material, execute. If your recipe is correct, the mixture will remain stable. If not... well, Master Aurelius can tell you about that.',
        ),
        _buildStoryCard(
          'But here is the paradox: failure is not the end. Each failed attempt unlocks a Revelation—a fragment of truth drawn from your mistakes. These revelations accumulate, gradually illuminating the path. Your mentor failed forty-seven times before he gave up. How many will it take you?',
        ),
      ],
    );
  }

  Widget _buildWarningSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.rubedoRed.withOpacity(0.3),
            AppColors.rubedoRed.withOpacity(0.1),
            Colors.black.withOpacity(0.5),
          ],
        ),
        borderRadius: AppRadius.largeRadius,
        border: Border.all(
          color: AppColors.rubedoRed.withOpacity(0.5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.rubedoRed.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: AppColors.rubedoRed,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'A Final Warning',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.rubedoRed,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'The Philosopher\'s Stone is not a toy. It is the culmination of centuries of alchemical wisdom, the key to transmutation, the secret of eternal life. Those who seek it lightly pay dearly.',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 16,
              color: AppColors.alabasterWhite,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: AppRadius.mediumRadius,
            ),
            child: const Text(
              '"Patience in the Study. Precision in the Laboratory. Wisdom in failure. These are the three virtues of the true alchemist."',
              style: TextStyle(
                fontFamily: AppTextStyles.serifFont,
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: AppColors.alchemicalGold,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Master Aurelius believed in you. He chose you above all others. Will you honor his faith? Or will you join the countless alchemists who reached too far, too fast?',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 16,
              color: AppColors.alabasterWhite,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'The choice is yours. The Work awaits.',
            style: TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withOpacity(0.4), width: 2),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppTextStyles.serifFont,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }

  Widget _buildStoryCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.neutralSteel.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTextStyles.serifFont,
          fontSize: 16,
          color: AppColors.alabasterWhite,
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildQuoteCard({required String text, required String author}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.alchemicalGold.withOpacity(0.15),
            AppColors.alchemicalGold.withOpacity(0.05),
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote,
            color: AppColors.alchemicalGold,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            text,
            style: const TextStyle(
              fontFamily: AppTextStyles.serifFont,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.alabasterWhite,
              height: 1.7,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— $author',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.alchemicalGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 15,
                    color: AppColors.alabasterWhite,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required int number,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.alchemicalGold.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.alchemicalGold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.alchemicalGold.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.voidCharcoal,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.alchemicalGold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 15,
                    color: AppColors.alabasterWhite,
                    height: 1.6,
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
