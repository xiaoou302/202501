import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/game_logic.dart';
import '../utils/storage_service.dart';
import '../widgets/custom_app_bar.dart';
import '../models/recipe.dart';
import '../models/game_state.dart';
import '../models/attempt_record.dart';
import '../models/revelation.dart';
import 'victory_screen.dart';
import 'failure_screen.dart';

class LaboratoryScreen extends StatefulWidget {
  final Recipe recipe;
  final GameState gameState;

  const LaboratoryScreen({
    super.key,
    required this.recipe,
    required this.gameState,
  });

  @override
  State<LaboratoryScreen> createState() => _LaboratoryScreenState();
}

class _LaboratoryScreenState extends State<LaboratoryScreen>
    with TickerProviderStateMixin {
  final GameLogic _gameLogic = GameLogic();
  int _currentStepIndex = 0;
  String? _selectedAction;
  String? _selectedMaterial;
  String _narrativeText = 'Select an action and material to begin...';
  bool _isExecuting = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Set the variant ID from game state so we validate against the correct recipe
    if (widget.gameState.currentRecipeVariantId != null) {
      _gameLogic.setVariant(widget.gameState.currentRecipeVariantId!);
    }

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

  bool get _canExecute =>
      _selectedAction != null && _selectedMaterial != null && !_isExecuting;

  String get _currentStepDisplay =>
      '${_currentStepIndex + 1} / ${GameConfig.totalSteps}';

  @override
  Widget build(BuildContext context) {
    final currentStep = widget.recipe.steps[_currentStepIndex];

    return WillPopScope(
      onWillPop: () async {
        // Prevent going back once in laboratory
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.voidCharcoal,
        appBar: CustomAppBar(
          title: AppStrings.laboratoryTitle,
          onHomePressed: null, // Disable home button in laboratory
        ),
        body: Column(
          children: [
            _buildRecipeHeader(currentStep),
            Expanded(child: _buildAlchemyBench()),
            _buildExecuteSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeHeader(currentStep) {
    final progress = (_currentStepIndex + 1) / GameConfig.totalSteps;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.rubedoRed.withOpacity(0.2),
            Colors.black.withOpacity(0.3),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.rubedoRed.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.alchemicalGold,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.alchemicalGold.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  'Step $_currentStepDisplay',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.voidCharcoal,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.neutralSteel.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.rubedoRed,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: AppRadius.mediumRadius,
              border: Border.all(
                color: AppColors.alchemicalGold.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.alabasterWhite.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    AlchemyData.getActionIcon(currentStep.action),
                    color: AppColors.alabasterWhite,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '[ ${AlchemyData.getActionLabel(currentStep.action)} ]',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.alchemicalGold,
                    letterSpacing: 0.5,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.neutralSteel,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AlchemyData.getMaterialColor(
                      currentStep.material,
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    AlchemyData.getMaterialIcon(currentStep.material),
                    color: AlchemyData.getMaterialColor(currentStep.material),
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '[ ${AlchemyData.getMaterialLabel(currentStep.material)} ]',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AlchemyData.getMaterialColor(currentStep.material),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlchemyBench() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.alabasterWhite,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            children: AlchemyData.actions.map((action) {
              final isSelected = _selectedAction == action;
              return _buildButton(
                icon: AlchemyData.getActionIcon(action),
                label: AlchemyData.getActionLabel(action),
                isSelected: isSelected,
                onTap: () => setState(() => _selectedAction = action),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Materials',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.alabasterWhite,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            children: AlchemyData.materials.map((material) {
              final isSelected = _selectedMaterial == material;
              return _buildButton(
                icon: AlchemyData.getMaterialIcon(material),
                label: AlchemyData.getMaterialLabel(material),
                iconColor: AlchemyData.getMaterialColor(material),
                isSelected: isSelected,
                onTap: () => setState(() => _selectedMaterial = material),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    AppColors.rubedoRed.withOpacity(0.3),
                    AppColors.rubedoRed.withOpacity(0.1),
                  ]
                : [
                    AppColors.neutralSteel.withOpacity(0.8),
                    AppColors.neutralSteel.withOpacity(0.6),
                  ],
          ),
          borderRadius: AppRadius.mediumRadius,
          border: Border.all(
            color: isSelected
                ? AppColors.rubedoRed
                : AppColors.neutralSteel.withOpacity(0.5),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.rubedoRed.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (iconColor ?? AppColors.alabasterWhite)
                  : (iconColor ?? AppColors.alabasterWhite).withOpacity(0.7),
              size: isSelected ? 36 : 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: isSelected ? 11 : 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.alabasterWhite
                    : AppColors.alabasterWhite.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExecuteSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.5), AppColors.voidCharcoal],
        ),
        border: Border(
          top: BorderSide(
            color: _canExecute
                ? AppColors.rubedoRed.withOpacity(0.6)
                : AppColors.neutralSteel.withOpacity(0.3),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: _canExecute
                ? AppColors.rubedoRed.withOpacity(0.3)
                : Colors.transparent,
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: AppRadius.mediumRadius,
                border: Border.all(
                  color: AppColors.alchemicalGold.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isExecuting
                        ? Icons.hourglass_empty
                        : _canExecute
                        ? Icons.science
                        : Icons.info_outline,
                    color: _isExecuting
                        ? AppColors.rubedoRed
                        : _canExecute
                        ? AppColors.alchemicalGold
                        : AppColors.neutralSteel,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _narrativeText,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: _isExecuting
                            ? AppColors.rubedoRed
                            : AppColors.alabasterWhite,
                        fontWeight: _isExecuting
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _canExecute ? _pulseAnimation.value : 1.0,
                    child: child,
                  );
                },
                child: ElevatedButton(
                  onPressed: _canExecute ? _executeStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rubedoRed,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.neutralSteel.withOpacity(
                      0.3,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md + 4,
                    ),
                    elevation: _canExecute ? 12 : 0,
                    shadowColor: _canExecute
                        ? AppColors.rubedoRed.withOpacity(0.6)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mediumRadius,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _canExecute ? Icons.flash_on : Icons.flash_off,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Text(
                        AppStrings.execute,
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
          ],
        ),
      ),
    );
  }

  Future<void> _executeStep() async {
    if (!_canExecute) return;

    setState(() {
      _isExecuting = true;
      _narrativeText = 'Executing step ${_currentStepIndex + 1}...';
    });

    // Dramatic pause before execution
    await Future.delayed(const Duration(milliseconds: 800));

    final userStep = widget.recipe.steps[_currentStepIndex].copyWith(
      action: _selectedAction,
      material: _selectedMaterial,
    );

    final isCorrect = _gameLogic.validateStep(userStep, _currentStepIndex);

    if (!isCorrect) {
      // FAILURE! Show immediate warning
      setState(() {
        _narrativeText =
            '⚠️ CRITICAL ERROR! Incorrect ${userStep.action != _gameLogic.getCorrectStep(_currentStepIndex).action ? "action" : "material"} detected!';
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      await _handleFailure(userStep);
    } else if (_currentStepIndex == GameConfig.totalSteps - 1) {
      // VICTORY! Final step
      setState(() {
        _narrativeText =
            '✨ Step 12 complete! The mixture glows with ruby light...';
      });
      await Future.delayed(const Duration(milliseconds: 2000));
      await _handleVictory();
    } else {
      // SUCCESS, continue to next step
      final stepNumber = _currentStepIndex + 1;
      setState(() {
        _currentStepIndex++;
        _selectedAction = null;
        _selectedMaterial = null;
        _narrativeText = _getNarrativeForStep(stepNumber);
        _isExecuting = false;
      });
    }
  }

  String _getNarrativeForStep(int completedStep) {
    switch (completedStep) {
      case 1:
        return '✓ The Green Lion dissolves. The volatile essence is captured.';
      case 2:
        return '✓ The Red King is combined. A crimson glow emanates.';
      case 3:
        return '✓ The White Queen joins. The royal marriage is sealed.';
      case 4:
        return '✓ Sulfur calcifies. Yellow crystals form in the crucible.';
      case 5:
        return '✓ Mercury dissolves. Liquid silver flows through the mixture.';
      case 6:
        return '✓ The White Eagle sublimes. Purifying vapors rise.';
      case 7:
        return '✓ The Red Lion calcifies. The mixture hardens momentarily.';
      case 8:
        return '✓ Sulfur combines again. The compound stabilizes.';
      case 9:
        return '✓ The Queen returns, dissolved. Her essence permeates all.';
      case 10:
        return '✓ Mercury sublimes. The messenger ascends as white smoke.';
      case 11:
        return '✓ The Green Lion calcifies. The circle nears completion.';
      default:
        return '✓ Step $completedStep complete. The mixture remains stable.';
    }
  }

  Future<void> _handleFailure(userStep) async {
    final failureReason = _gameLogic.getFailureReason(
      userStep,
      _currentStepIndex,
    );

    // Save attempt record
    final attemptRecord = AttemptRecord(
      attemptNumber: widget.gameState.currentAttempt,
      timestamp: DateTime.now(),
      attemptedRecipe: widget.recipe,
      wasSuccessful: false,
      failedAtStep: _currentStepIndex + 1,
      failureReason: failureReason,
    );

    // Update game state
    final newLog = List<AttemptRecord>.from(widget.gameState.craftingLog)
      ..add(attemptRecord);

    // Check for revelation unlocks
    final unlockedIndices = _gameLogic.checkRevelationUnlocks(
      widget.gameState.copyWith(craftingLog: newLog),
    );

    final updatedRevelations = List<Revelation>.from(
      widget.gameState.revelations,
    );
    for (final index in unlockedIndices) {
      updatedRevelations[index] = updatedRevelations[index].copyWith(
        isUnlocked: true,
      );
    }

    final updatedState = widget.gameState.copyWith(
      currentAttempt: widget.gameState.currentAttempt + 1,
      craftingLog: newLog,
      revelations: updatedRevelations,
      currentRecipe: null,
    );

    await StorageService().saveGameState(updatedState);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FailureScreen(
            failureReason: failureReason,
            failedAtStep: _currentStepIndex + 1,
          ),
        ),
      );
    }
  }

  Future<void> _handleVictory() async {
    // Save attempt record
    final attemptRecord = AttemptRecord(
      attemptNumber: widget.gameState.currentAttempt,
      timestamp: DateTime.now(),
      attemptedRecipe: widget.recipe,
      wasSuccessful: true,
    );

    final newLog = List<AttemptRecord>.from(widget.gameState.craftingLog)
      ..add(attemptRecord);

    final updatedState = widget.gameState.copyWith(
      currentAttempt: widget.gameState.currentAttempt + 1,
      craftingLog: newLog,
      currentRecipe: null,
    );

    await StorageService().saveGameState(updatedState);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VictoryScreen()),
      );
    }
  }
}
