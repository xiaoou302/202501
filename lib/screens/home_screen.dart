import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/game_state.dart';
import '../utils/storage_service.dart';
import 'study_screen.dart';
import 'crafting_log_screen.dart';
import 'revelations_screen.dart';
import 'introduction_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late GameState _gameState;
  bool _isLoading = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadGameState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadGameState() async {
    final state = await StorageService().loadGameState();
    setState(() {
      _gameState = state;
      _isLoading = false;
    });
  }

  void _navigateToStudy() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyScreen(gameState: _gameState),
      ),
    );
    if (result == true) {
      _loadGameState();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.voidCharcoal,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.alchemicalGold),
        ),
      );
    }

    final lastAttempt = _gameState.lastAttempt;
    final unlockedRevelations = _gameState.revelations
        .where((r) => r.isUnlocked)
        .length;
    final totalRevelations = _gameState.revelations.length;

    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              _buildProgressSection(unlockedRevelations, totalRevelations),
              const SizedBox(height: AppSpacing.lg),
              if (lastAttempt != null) ...[
                _buildLastAttemptCard(lastAttempt),
                const SizedBox(height: AppSpacing.lg),
              ],
              _buildPrimaryAction(),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickAccessGrid(),
              const SizedBox(height: AppSpacing.lg),
              _buildQuote(),
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
          center: Alignment.topCenter,
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
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.alchemicalGold.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.alchemicalGold.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    size: 48,
                    color: AppColors.alchemicalGold,
                    shadows: [
                      Shadow(
                        color: AppColors.alchemicalGold.withOpacity(0.8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                AppColors.alchemicalGold,
                AppColors.alabasterWhite,
                AppColors.alchemicalGold,
              ],
            ).createShader(bounds),
            child: const Text(
              AppStrings.appName,
              style: TextStyle(
                fontFamily: AppTextStyles.serifFont,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4.0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.alchemicalGold.withOpacity(0.5),
                ),
                bottom: BorderSide(
                  color: AppColors.alchemicalGold.withOpacity(0.5),
                ),
              ),
            ),
            child: const Text(
              AppStrings.subtitle,
              style: TextStyle(
                fontFamily: AppTextStyles.serifFont,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.neutralSteel,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(int unlocked, int total) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.alchemicalGold.withOpacity(0.15),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.science,
                label: 'Attempts',
                value: '${_gameState.currentAttempt}',
                color: AppColors.alchemicalGold,
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.neutralSteel.withOpacity(0.3),
              ),
              _buildStatItem(
                icon: Icons.lightbulb_outline,
                label: 'Revelations',
                value: '$unlocked/$total',
                color: Colors.purple,
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.neutralSteel.withOpacity(0.3),
              ),
              _buildStatItem(
                icon: Icons.history,
                label: 'Records',
                value: '${_gameState.craftingLog.length}',
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: unlocked / total,
              minHeight: 8,
              backgroundColor: Colors.black.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.alchemicalGold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Knowledge Progress: ${((unlocked / total) * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.neutralSteel,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.neutralSteel),
        ),
      ],
    );
  }

  Widget _buildLastAttemptCard(lastAttempt) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: lastAttempt.wasSuccessful
              ? [
                  AppColors.alchemicalGold.withOpacity(0.2),
                  Colors.black.withOpacity(0.3),
                ]
              : [
                  AppColors.rubedoRed.withOpacity(0.2),
                  Colors.black.withOpacity(0.3),
                ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: lastAttempt.wasSuccessful
              ? AppColors.alchemicalGold.withOpacity(0.5)
              : AppColors.rubedoRed.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color:
                      (lastAttempt.wasSuccessful
                              ? AppColors.alchemicalGold
                              : AppColors.rubedoRed)
                          .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  lastAttempt.wasSuccessful
                      ? Icons.check_circle
                      : Icons.warning_amber_rounded,
                  color: lastAttempt.wasSuccessful
                      ? AppColors.alchemicalGold
                      : AppColors.rubedoRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'LAST ATTEMPT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.alabasterWhite,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      (lastAttempt.wasSuccessful
                              ? AppColors.alchemicalGold
                              : AppColors.rubedoRed)
                          .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lastAttempt.wasSuccessful
                        ? AppColors.alchemicalGold
                        : AppColors.rubedoRed,
                  ),
                ),
                child: Text(
                  lastAttempt.wasSuccessful ? 'SUCCESS' : 'FAILURE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: lastAttempt.wasSuccessful
                        ? AppColors.alchemicalGold
                        : AppColors.rubedoRed,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                'Attempt #${lastAttempt.attemptNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.alabasterWhite,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(lastAttempt.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.neutralSteel,
                ),
              ),
            ],
          ),
          if (!lastAttempt.wasSuccessful) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 16,
                    color: AppColors.rubedoRed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lastAttempt.failureReason ?? 'Unknown error',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.alabasterWhite,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrimaryAction() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.mediumRadius,
              boxShadow: [
                BoxShadow(
                  color: AppColors.rubedoRed.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rubedoRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md + 4,
                  ),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mediumRadius,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.play_arrow, size: 24),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      AppStrings.beginTheWork,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAccessGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            'QUICK ACCESS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.alchemicalGold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildQuickAccessCard(
                icon: Icons.history,
                label: 'Crafting\nLog',
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CraftingLogScreen(gameState: _gameState),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildQuickAccessCard(
                icon: Icons.lightbulb_outline,
                label: 'Revelations',
                color: Colors.purple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RevelationsScreen(gameState: _gameState),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildQuickAccessCard(
                icon: Icons.menu_book,
                label: 'Introduction',
                color: AppColors.alchemicalGold,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntroductionScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildQuickAccessCard(
                icon: Icons.settings,
                label: 'Settings',
                color: AppColors.neutralSteel,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen(gameState: _gameState),
                    ),
                  );
                  _loadGameState();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), Colors.black.withOpacity(0.3)],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mediumRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.sm,
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuote() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.neutralSteel.withOpacity(0.2)),
      ),
      child: const Text(
        '"The Great Work awaits those brave enough to seek it, patient enough to understand it, and wise enough to complete it."',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTextStyles.serifFont,
          fontSize: 13,
          fontStyle: FontStyle.italic,
          color: AppColors.neutralSteel,
          height: 1.6,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
