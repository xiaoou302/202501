import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/game_logic.dart';
import '../utils/storage_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/confirmation_modal.dart';
import '../models/game_state.dart';
import '../models/recipe.dart';
import '../models/alchemy_step.dart';
import 'laboratory_screen.dart';

class StudyScreen extends StatefulWidget {
  final GameState gameState;

  const StudyScreen({super.key, required this.gameState});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<AlchemyStep> _steps;
  final GameLogic _gameLogic = GameLogic();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late ScrollController _logScrollController;
  late ScrollController _slateScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _logScrollController = ScrollController();
    _slateScrollController = ScrollController();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    // Set or select recipe variant
    if (widget.gameState.currentRecipeVariantId != null) {
      _gameLogic.setVariant(widget.gameState.currentRecipeVariantId!);
    } else {
      _gameLogic.selectRandomVariant();
    }

    // Initialize with empty steps or current recipe
    if (widget.gameState.currentRecipe != null) {
      _steps = List.from(widget.gameState.currentRecipe!.steps);
    } else {
      _steps = List.generate(
        GameConfig.totalSteps,
        (index) => AlchemyStep(stepNumber: index + 1, action: '', material: ''),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _logScrollController.dispose();
    _slateScrollController.dispose();
    super.dispose();
  }

  bool _isRecipeComplete() {
    return _steps.every((step) => step.isNotEmpty);
  }

  Future<void> _lockRecipe() async {
    if (!_isRecipeComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all 12 steps before locking the recipe.'),
          backgroundColor: AppColors.rubedoRed,
        ),
      );
      return;
    }

    final confirmed = await ConfirmationModal.show(context);
    if (confirmed == true && mounted) {
      final recipe = Recipe(
        steps: _steps,
        isLocked: true,
        creationDate: DateTime.now(),
        attemptNumber: widget.gameState.currentAttempt,
      );

      // Save the current variant ID to game state so Laboratory uses the same recipe
      final updatedState = widget.gameState.copyWith(
        currentRecipeVariantId: _gameLogic.getCurrentVariant().id,
      );

      await StorageService().saveGameState(updatedState);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LaboratoryScreen(recipe: recipe, gameState: updatedState),
        ),
      );
    }
  }

  void _updateStep(int index, {String? action, String? material}) {
    print('DEBUG: Updating step $index - action: $action, material: $material');
    setState(() {
      _steps[index] = _steps[index].copyWith(
        action: action,
        material: material,
      );
    });
    print('DEBUG: Step $index updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: StudyScreen build called');
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: AppStrings.studyTitle,
        onHomePressed: () => Navigator.pop(context),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Container(
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.menu_book, size: 24),
                    text: AppStrings.encryptedLog,
                  ),
                  Tab(
                    icon: Icon(Icons.dashboard, size: 24),
                    text: AppStrings.recipeSlate,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildEncryptedLog(), _buildRecipeSlate()],
              ),
            ),
            _buildLockButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEncryptedLog() {
    final clues = _gameLogic.getEncryptedLogClues();

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 2.0,
          colors: [
            AppColors.alchemicalGold.withOpacity(0.03),
            AppColors.voidCharcoal,
          ],
        ),
      ),
      child: Scrollbar(
        controller: _logScrollController,
        thumbVisibility: true,
        thickness: 4,
        radius: const Radius.circular(2),
        child: SingleChildScrollView(
          controller: _logScrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.alchemicalGold.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: AppRadius.mediumRadius,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.alchemicalGold.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: AppColors.alchemicalGold,
                      size: 28,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Mentor\'s Notes: The Great Work',
                        style: AppTextStyles.header3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...clues.map((clue) {
                if (clue.isEmpty) {
                  return const SizedBox(height: AppSpacing.md);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildClueText(clue),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClueText(String text) {
    // Highlight words in brackets with gold color
    final parts = text.split(RegExp(r'(\[.*?\])'));
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyLarge,
        children: parts.map((part) {
          if (part.startsWith('[') && part.endsWith(']')) {
            return TextSpan(text: part, style: AppTextStyles.clue);
          }
          return TextSpan(text: part);
        }).toList(),
      ),
    );
  }

  Widget _buildRecipeSlate() {
    print('DEBUG: Building recipe slate');
    final completedSteps = _steps.where((s) => s.isNotEmpty).length;
    final progress = completedSteps / GameConfig.totalSteps;
    print('DEBUG: Completed steps: $completedSteps/${GameConfig.totalSteps}');

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            AppColors.rubedoRed.withOpacity(0.03),
            AppColors.voidCharcoal,
          ],
        ),
      ),
      child: Scrollbar(
        controller: _slateScrollController,
        thumbVisibility: true,
        thickness: 4,
        radius: const Radius.circular(2),
        child: SingleChildScrollView(
          controller: _slateScrollController,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: AppRadius.mediumRadius,
                  border: Border.all(
                    color: AppColors.alchemicalGold.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Arrange the 12 steps in their only true order.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.alabasterWhite,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Progress: $completedSteps / ${GameConfig.totalSteps}',
                          style: TextStyle(
                            fontSize: 12,
                            color: progress == 1.0
                                ? AppColors.alchemicalGold
                                : AppColors.neutralSteel,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.neutralSteel
                                  .withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress == 1.0
                                    ? AppColors.alchemicalGold
                                    : AppColors.rubedoRed,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(GameConfig.totalSteps, (index) {
                return _buildStepRow(index);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(int index) {
    final step = _steps[index];
    final isComplete = step.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        decoration: BoxDecoration(
          color: isComplete
              ? AppColors.alchemicalGold.withOpacity(0.05)
              : Colors.black.withOpacity(0.2),
          borderRadius: AppRadius.smallRadius,
          border: Border.all(
            color: isComplete
                ? AppColors.alchemicalGold.withOpacity(0.3)
                : AppColors.neutralSteel.withOpacity(0.2),
            width: isComplete ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isComplete
                    ? AppColors.alchemicalGold
                    : AppColors.neutralSteel.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: isComplete
                    ? [
                        BoxShadow(
                          color: AppColors.alchemicalGold.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isComplete
                        ? AppColors.voidCharcoal
                        : AppColors.neutralSteel,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildDropdown(
                value: step.action.isEmpty ? null : step.action,
                items: AlchemyData.actions,
                hint: AppStrings.selectAction,
                onChanged: (value) => _updateStep(index, action: value ?? ''),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildDropdown(
                value: step.material.isEmpty ? null : step.material,
                items: AlchemyData.materials,
                hint: AppStrings.selectMaterial,
                onChanged: (value) => _updateStep(index, material: value ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    final hasValue = value != null && value.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: hasValue
            ? AppColors.alchemicalGold.withOpacity(0.1)
            : Colors.black.withOpacity(0.2),
        border: Border.all(
          color: hasValue
              ? AppColors.alchemicalGold
              : AppColors.neutralSteel.withOpacity(0.5),
          width: 1.5,
        ),
        borderRadius: AppRadius.smallRadius,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.voidCharcoal,
          style: TextStyle(
            color: hasValue ? AppColors.alchemicalGold : AppColors.neutralSteel,
            fontSize: 13,
            fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: hasValue ? AppColors.alchemicalGold : AppColors.neutralSteel,
            size: 20,
          ),
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.neutralSteel, fontSize: 12),
          ),
          items: items.map((item) {
            final label = items == AlchemyData.actions
                ? AlchemyData.getActionLabel(item)
                : AlchemyData.getMaterialLabel(item);
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    items == AlchemyData.actions
                        ? AlchemyData.getActionIcon(item)
                        : AlchemyData.getMaterialIcon(item),
                    size: 16,
                    color: items == AlchemyData.materials
                        ? AlchemyData.getMaterialColor(item)
                        : AppColors.alabasterWhite,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLockButton() {
    final isComplete = _isRecipeComplete();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.3), AppColors.voidCharcoal],
        ),
        border: Border(
          top: BorderSide(
            color: isComplete
                ? AppColors.rubedoRed.withOpacity(0.5)
                : AppColors.neutralSteel.withOpacity(0.3),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isComplete
                ? AppColors.rubedoRed.withOpacity(0.2)
                : Colors.transparent,
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isComplete ? _lockRecipe : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rubedoRed,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.neutralSteel.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              elevation: isComplete ? 8 : 0,
              shadowColor: isComplete
                  ? AppColors.rubedoRed.withOpacity(0.5)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.mediumRadius,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isComplete ? Icons.lock_open : Icons.lock, size: 22),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  AppStrings.lockRecipe,
                  style: AppTextStyles.buttonText,
                ),
                if (isComplete) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
