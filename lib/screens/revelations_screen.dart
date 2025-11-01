import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../models/game_state.dart';

class RevelationsScreen extends StatefulWidget {
  final GameState gameState;

  const RevelationsScreen({super.key, required this.gameState});

  @override
  State<RevelationsScreen> createState() => _RevelationsScreenState();
}

class _RevelationsScreenState extends State<RevelationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: AppStrings.revelationsTitle,
        onHomePressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGameRulesTab(),
                _buildGameplayGuideTab(),
                _buildRevelationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.alchemicalGold.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.alchemicalGold,
        indicatorWeight: 3,
        labelColor: AppColors.alchemicalGold,
        unselectedLabelColor: AppColors.neutralSteel,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.auto_stories, size: 20), text: 'Game Rules'),
          Tab(icon: Icon(Icons.psychology, size: 20), text: 'Gameplay Guide'),
          Tab(
            icon: Icon(Icons.lightbulb_outline, size: 20),
            text: 'Revelations',
          ),
        ],
      ),
    );
  }

  // ========== TAB 1: GAME RULES ==========
  Widget _buildGameRulesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.menu_book,
            title: 'The Alchemist\'s Paradox',
            subtitle: 'Understanding the Great Work',
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildRuleCard(
            icon: Icons.psychology,
            title: 'The Two-Stage Law',
            description:
                'The Great Work unfolds in two distinct phases, each governed by its own principles. The Study offers mercy—a sanctuary for contemplation and experimentation. The Laboratory demands perfection—a crucible where error means annihilation.',
            highlights: [
              'Stage 1: The Study - Unlimited attempts, no consequences',
              'Stage 2: The Laboratory - One chance, absolute precision required',
            ],
          ),
          _buildRuleCard(
            icon: Icons.lock_open,
            title: 'The Mercy of the Study',
            description:
                'Within the Study\'s walls, you are safe to explore, hypothesize, and revise. Here, the mentor\'s encrypted journal awaits your interpretation. Arrange the twelve steps in what you believe to be their true order. Change your mind as often as needed—the Study judges not.',
            highlights: [
              'Read the encrypted journal for cryptic clues',
              'Arrange 12 alchemical steps in sequence',
              'Modify your recipe freely until satisfied',
              'Lock your recipe when ready to proceed',
            ],
          ),
          _buildRuleCard(
            icon: Icons.warning_amber_rounded,
            title: 'The Laboratory\'s Judgment',
            description:
                'Once you cross the threshold into the Laboratory, there is no return. Your recipe is sealed. Now comes the execution—step by step, action by action. The slightest deviation from the true path will trigger catastrophic failure. The mixture is volatile; the margin for error is zero.',
            highlights: [
              'Execute each step manually with precision',
              'Any incorrect action or material causes immediate failure',
              'No second chances—perfection or destruction',
              'Success requires flawless execution of all 12 steps',
            ],
          ),
          _buildRuleCard(
            icon: Icons.casino,
            title: 'The Three Paths',
            description:
                'The Great Work is not singular—it manifests in three distinct forms, each time you begin anew. The Path of the Phoenix, the Serpent\'s Coil, or the Dragon\'s Breath. Each path has its own correct sequence, its own encrypted wisdom. Study the journal carefully to discern which path lies before you.',
            highlights: [
              'Three different recipe variants exist',
              'Each attempt randomly selects one path',
              'Identify your path from the journal\'s title',
              'Each path requires a unique 12-step sequence',
            ],
          ),
          _buildRuleCard(
            icon: Icons.science,
            title: 'The Four Actions',
            description:
                'Alchemy recognizes four fundamental transformations, each with its own symbolic meaning and practical application. Master these actions, for they are the verbs of the Great Work.',
            highlights: [
              'Dissolve - Breaking down into essence',
              'Combine - Uniting separate elements',
              'Calcify - Hardening through fire',
              'Sublimate - Ascending to higher form',
            ],
          ),
          _buildRuleCard(
            icon: Icons.diamond,
            title: 'The Seven Materials',
            description:
                'Seven sacred substances form the vocabulary of transformation. Each carries symbolic weight and appears in specific moments of the Work. Some appear once, others twice—their frequency is itself a clue.',
            highlights: [
              'Green Lion - The volatile beginning',
              'Red Lion - Strength and solidification',
              'Red King - Masculine principle',
              'White Queen - Feminine principle',
              'White Eagle - Purification and ascent',
              'Sulfur - The solar principle',
              'Mercury - The lunar principle',
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ========== TAB 2: GAMEPLAY GUIDE ==========
  Widget _buildGameplayGuideTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.explore,
            title: 'Mastering the Great Work',
            subtitle: 'Strategies and Insights',
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGuideCard(
            icon: Icons.search,
            title: 'Reading the Encrypted Journal',
            description:
                'The mentor\'s journal is your primary source of truth, but it speaks in riddles and metaphors. Learn to distinguish genuine clues from poetic flourish.',
            tips: [
              'Look for bracketed keywords—they highlight crucial information',
              'Pay attention to explicit step numbers and positions',
              'Note which materials are described as "first" or "last"',
              'Observe patterns in action frequency (how often each action appears)',
              'The title reveals which of the three paths you\'re on',
            ],
          ),
          _buildGuideCard(
            icon: Icons.psychology_alt,
            title: 'Deductive Reasoning',
            description:
                'The puzzle rewards logical thinking. Use the clues to eliminate impossible arrangements and narrow down the possibilities.',
            tips: [
              'Start with the most explicit clues (e.g., "Step 1 must be...")',
              'Build a framework of certainties before filling in gaps',
              'Track material frequency—some appear once, others twice',
              'Look for sequential dependencies ("immediately after...")',
              'Cross-reference multiple clues to confirm hypotheses',
            ],
          ),
          _buildGuideCard(
            icon: Icons.edit_note,
            title: 'Crafting Your Recipe',
            description:
                'In the Study, take your time. The recipe slate is forgiving—experiment, revise, and refine until you\'re confident.',
            tips: [
              'Fill in the steps you\'re certain about first',
              'Use process of elimination for ambiguous positions',
              'Double-check that all 12 steps are filled before locking',
              'Verify your recipe matches the journal\'s pattern descriptions',
              'Remember: once locked, no changes are possible',
            ],
          ),
          _buildGuideCard(
            icon: Icons.science_outlined,
            title: 'Laboratory Execution',
            description:
                'Precision is paramount. In the Laboratory, you must manually execute each step exactly as planned. One mistake ends everything.',
            tips: [
              'Read the displayed step carefully before selecting',
              'Click the action button first, then the material button',
              'Wait for both buttons to highlight before executing',
              'Take your time—there\'s no time limit, only accuracy matters',
              'If you fail, study the error message to learn what went wrong',
            ],
          ),
          _buildGuideCard(
            icon: Icons.auto_graph,
            title: 'Learning from Failure',
            description:
                'Each failed attempt teaches you something. The Crafting Log records your mistakes, and Revelations unlock to guide you.',
            tips: [
              'Review your failed attempts in the Crafting Log',
              'Note which step caused failure and why',
              'Revelations unlock progressively—they provide direct hints',
              'After several attempts, you\'ll unlock more explicit guidance',
              'Persistence is rewarded—the game wants you to succeed',
            ],
          ),
          _buildGuideCard(
            icon: Icons.lightbulb,
            title: 'Advanced Strategies',
            description:
                'For those seeking mastery, here are deeper insights into the puzzle\'s structure.',
            tips: [
              'Each path has a unique action pattern (frequency and distribution)',
              'Material pairings often have symbolic significance',
              'The beginning and end of sequences often mirror each other',
              'Pay attention to which materials never appear together',
              'The journal\'s structure often mirrors the recipe\'s structure',
            ],
          ),
          _buildGuideCard(
            icon: Icons.celebration,
            title: 'The Path to Victory',
            description:
                'Success requires patience, observation, and logical deduction. Trust in the process, and the Philosopher\'s Stone will be yours.',
            tips: [
              'Don\'t rush—the Study phase is where victory is won',
              'Use all available information: journal, revelations, past attempts',
              'When in doubt, return to the most explicit clues',
              'The correct recipe will feel internally consistent',
              'In the Laboratory, focus and precision are your allies',
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ========== TAB 3: REVELATIONS ==========
  Widget _buildRevelationsTab() {
    final unlockedCount = widget.gameState.revelations
        .where((r) => r.isUnlocked)
        .length;
    final totalCount = widget.gameState.revelations.length;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(AppSpacing.lg),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.alchemicalGold.withOpacity(0.2),
                AppColors.alchemicalGold.withOpacity(0.05),
              ],
            ),
            borderRadius: AppRadius.mediumRadius,
            border: Border.all(
              color: AppColors.alchemicalGold.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.alchemicalGold.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.alchemicalGold,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Revelations Unlocked',
                      style: TextStyle(
                        fontFamily: AppTextStyles.serifFont,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.alchemicalGold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$unlockedCount of $totalCount truths revealed',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.alabasterWhite,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${((unlockedCount / totalCount) * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.alchemicalGold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: widget.gameState.revelations.length,
            itemBuilder: (context, index) {
              final revelation = widget.gameState.revelations[index];
              return _buildRevelationCard(revelation, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRevelationCard(revelation, int number) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: revelation.isUnlocked
              ? [
                  AppColors.alchemicalGold.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                ]
              : [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.3)],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: revelation.isUnlocked
              ? AppColors.alchemicalGold.withOpacity(0.4)
              : AppColors.neutralSteel.withOpacity(0.2),
          width: revelation.isUnlocked ? 2 : 1,
        ),
        boxShadow: revelation.isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.alchemicalGold.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: revelation.isUnlocked
                        ? AppColors.alchemicalGold.withOpacity(0.2)
                        : AppColors.neutralSteel.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: revelation.isUnlocked
                          ? AppColors.alchemicalGold
                          : AppColors.neutralSteel,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: revelation.isUnlocked
                        ? Icon(
                            Icons.lightbulb,
                            color: AppColors.alchemicalGold,
                            size: 20,
                          )
                        : Icon(
                            Icons.lock,
                            color: AppColors.neutralSteel,
                            size: 18,
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revelation $number',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: revelation.isUnlocked
                              ? AppColors.alchemicalGold.withOpacity(0.7)
                              : AppColors.neutralSteel,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        revelation.title,
                        style: TextStyle(
                          fontFamily: AppTextStyles.serifFont,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: revelation.isUnlocked
                              ? AppColors.alchemicalGold
                              : AppColors.neutralSteel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: AppRadius.smallRadius,
              ),
              child: Text(
                revelation.isUnlocked
                    ? revelation.description
                    : 'This revelation remains sealed. Continue your attempts to unlock this truth...\n\nUnlocks after: ${revelation.unlockRequirement} ${revelation.unlockRequirement == 1 ? 'attempt' : 'attempts'}',
                style: TextStyle(
                  fontFamily: AppTextStyles.serifFont,
                  fontSize: 15,
                  color: revelation.isUnlocked
                      ? AppColors.alabasterWhite
                      : AppColors.neutralSteel,
                  height: 1.6,
                  fontStyle: revelation.isUnlocked
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== HELPER WIDGETS ==========
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.alchemicalGold.withOpacity(0.2),
            AppColors.alchemicalGold.withOpacity(0.05),
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.alchemicalGold.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.alchemicalGold, size: 32),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.alchemicalGold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.serifFont,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.alabasterWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> highlights,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.2),
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.alchemicalGold.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.alchemicalGold, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.serifFont,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.alchemicalGold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: const TextStyle(
                fontFamily: AppTextStyles.serifFont,
                fontSize: 15,
                color: AppColors.alabasterWhite,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...highlights.map(
              (highlight) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.fiber_manual_record,
                        size: 8,
                        color: AppColors.alchemicalGold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        highlight,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.alabasterWhite,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> tips,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.rubedoRed.withOpacity(0.1),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.rubedoRed.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.rubedoRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.rubedoRed, size: 24),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.serifFont,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.rubedoRed,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: const TextStyle(
                fontFamily: AppTextStyles.serifFont,
                fontSize: 14,
                color: AppColors.alabasterWhite,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.arrow_right,
                        size: 20,
                        color: AppColors.rubedoRed,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.alabasterWhite,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
