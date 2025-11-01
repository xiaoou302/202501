import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../utils/storage_service.dart';
import '../widgets/custom_app_bar.dart';
import '../models/game_state.dart';
import '../models/attempt_record.dart';

class CraftingLogScreen extends StatefulWidget {
  final GameState gameState;

  const CraftingLogScreen({super.key, required this.gameState});

  @override
  State<CraftingLogScreen> createState() => _CraftingLogScreenState();
}

class _CraftingLogScreenState extends State<CraftingLogScreen> {
  late List<AttemptRecord> _attempts;
  String _filterType = 'all'; // all, success, failure

  @override
  void initState() {
    super.initState();
    _attempts = widget.gameState.craftingLog.reversed.toList();
  }

  List<AttemptRecord> get _filteredAttempts {
    if (_filterType == 'success') {
      return _attempts.where((a) => a.wasSuccessful).toList();
    } else if (_filterType == 'failure') {
      return _attempts.where((a) => !a.wasSuccessful).toList();
    }
    return _attempts;
  }

  int get _totalAttempts => _attempts.length;
  int get _successCount => _attempts.where((a) => a.wasSuccessful).length;
  int get _failureCount => _attempts.where((a) => !a.wasSuccessful).length;
  double get _successRate =>
      _totalAttempts > 0 ? (_successCount / _totalAttempts) * 100 : 0;

  Future<void> _deleteAttempt(AttemptRecord attempt) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDeleteConfirmDialog(attempt),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _attempts.remove(attempt);
      });

      // Update storage
      final updatedLog = widget.gameState.craftingLog
          .where((a) => a.attemptNumber != attempt.attemptNumber)
          .toList();
      final updatedState = widget.gameState.copyWith(craftingLog: updatedLog);
      await StorageService().saveGameState(updatedState);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attempt #${attempt.attemptNumber} deleted'),
            backgroundColor: AppColors.neutralSteel,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _clearAllAttempts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildClearAllDialog(),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _attempts.clear();
      });

      final updatedState = widget.gameState.copyWith(craftingLog: []);
      await StorageService().saveGameState(updatedState);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All attempts cleared'),
            backgroundColor: AppColors.neutralSteel,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidCharcoal,
      appBar: CustomAppBar(
        title: AppStrings.craftingLogTitle,
        onHomePressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          _buildStatisticsPanel(),
          _buildFilterBar(),
          Expanded(
            child: _filteredAttempts.isEmpty
                ? _buildEmptyState()
                : _buildAttemptsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsPanel() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.alchemicalGold.withOpacity(0.15),
            AppColors.rubedoRed.withOpacity(0.1),
          ],
        ),
        borderRadius: AppRadius.largeRadius,
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.alchemicalGold.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: AppColors.alchemicalGold,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'Alchemical Records',
                style: TextStyle(
                  fontFamily: AppTextStyles.serifFont,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.alchemicalGold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.science,
                label: 'Total',
                value: '$_totalAttempts',
                color: AppColors.alabasterWhite,
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                label: 'Success',
                value: '$_successCount',
                color: AppColors.alchemicalGold,
              ),
              _buildStatItem(
                icon: Icons.cancel,
                label: 'Failure',
                value: '$_failureCount',
                color: AppColors.rubedoRed,
              ),
              _buildStatItem(
                icon: Icons.percent,
                label: 'Rate',
                value: '${_successRate.toStringAsFixed(1)}%',
                color: _successRate > 50
                    ? AppColors.alchemicalGold
                    : AppColors.neutralSteel,
              ),
            ],
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
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.xs),
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
          style: TextStyle(fontSize: 12, color: AppColors.neutralSteel),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.neutralSteel.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildFilterButton('all', 'All', Icons.list)),
          Expanded(
            child: _buildFilterButton(
              'success',
              'Success',
              Icons.check_circle_outline,
            ),
          ),
          Expanded(
            child: _buildFilterButton(
              'failure',
              'Failure',
              Icons.cancel_outlined,
            ),
          ),
          if (_attempts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, size: 20),
              color: AppColors.rubedoRed,
              onPressed: _clearAllAttempts,
              tooltip: 'Clear All',
            ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String type, String label, IconData icon) {
    final isSelected = _filterType == type;
    return GestureDetector(
      onTap: () => setState(() => _filterType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.alchemicalGold.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: AppRadius.smallRadius,
          border: isSelected
              ? Border.all(color: AppColors.alchemicalGold, width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? AppColors.alchemicalGold
                  : AppColors.neutralSteel,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.alchemicalGold
                    : AppColors.neutralSteel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    if (_filterType == 'success') {
      message =
          'No successful attempts yet.\nKeep trying to create the Philosopher\'s Stone!';
      icon = Icons.diamond_outlined;
    } else if (_filterType == 'failure') {
      message = 'No failed attempts.\nYou haven\'t started your journey yet.';
      icon = Icons.warning_amber_outlined;
    } else {
      message =
          'No attempts recorded.\nBegin The Work to start your alchemical journey.';
      icon = Icons.science_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.neutralSteel.withOpacity(0.5)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutralSteel,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _filteredAttempts.length,
      itemBuilder: (context, index) {
        final attempt = _filteredAttempts[index];
        return _buildAttemptCard(attempt, index);
      },
    );
  }

  Widget _buildAttemptCard(AttemptRecord attempt, int index) {
    final isSuccess = attempt.wasSuccessful;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: Key('attempt_${attempt.attemptNumber}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.rubedoRed,
            borderRadius: AppRadius.mediumRadius,
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 32),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
            context: context,
            builder: (context) => _buildDeleteConfirmDialog(attempt),
          );
        },
        onDismissed: (direction) {
          _deleteAttempt(attempt);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSuccess
                  ? [
                      AppColors.alchemicalGold.withOpacity(0.15),
                      Colors.black.withOpacity(0.3),
                    ]
                  : [
                      AppColors.rubedoRed.withOpacity(0.15),
                      Colors.black.withOpacity(0.3),
                    ],
            ),
            borderRadius: AppRadius.mediumRadius,
            border: Border.all(
              color: isSuccess
                  ? AppColors.alchemicalGold.withOpacity(0.4)
                  : AppColors.rubedoRed.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    (isSuccess ? AppColors.alchemicalGold : AppColors.rubedoRed)
                        .withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.mediumRadius,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showAttemptDetails(attempt),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAttemptHeader(attempt),
                      const SizedBox(height: AppSpacing.sm),
                      _buildAttemptInfo(attempt),
                      if (!isSuccess) ...[
                        const SizedBox(height: AppSpacing.sm),
                        _buildFailureDetails(attempt),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      _buildAttemptFooter(attempt),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttemptHeader(AttemptRecord attempt) {
    final isSuccess = attempt.wasSuccessful;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color:
                    (isSuccess ? AppColors.alchemicalGold : AppColors.rubedoRed)
                        .withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSuccess
                      ? AppColors.alchemicalGold
                      : AppColors.rubedoRed,
                  width: 2,
                ),
              ),
              child: Icon(
                isSuccess ? Icons.diamond : Icons.warning_amber_rounded,
                color: isSuccess
                    ? AppColors.alchemicalGold
                    : AppColors.rubedoRed,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attempt #${attempt.attemptNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.alabasterWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy • HH:mm').format(attempt.timestamp),
                  style: TextStyle(fontSize: 12, color: AppColors.neutralSteel),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: (isSuccess ? AppColors.alchemicalGold : AppColors.rubedoRed)
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSuccess ? AppColors.alchemicalGold : AppColors.rubedoRed,
              width: 1.5,
            ),
          ),
          child: Text(
            isSuccess ? 'SUCCESS' : 'FAILURE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSuccess ? AppColors.alchemicalGold : AppColors.rubedoRed,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttemptInfo(AttemptRecord attempt) {
    if (attempt.wasSuccessful) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.alchemicalGold.withOpacity(0.1),
          borderRadius: AppRadius.smallRadius,
          border: Border.all(color: AppColors.alchemicalGold.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.celebration, color: AppColors.alchemicalGold, size: 20),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Text(
                'The Philosopher\'s Stone was successfully created!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.alchemicalGold,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFailureDetails(AttemptRecord attempt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.rubedoRed.withOpacity(0.1),
            borderRadius: AppRadius.smallRadius,
            border: Border.all(color: AppColors.rubedoRed.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.rubedoRed,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Failed at Step ${attempt.failedAtStep}/12',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.rubedoRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                attempt.failureReason ?? 'Unknown error',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.alabasterWhite,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttemptFooter(AttemptRecord attempt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => _showAttemptDetails(attempt),
          icon: const Icon(Icons.visibility, size: 16),
          label: const Text('View Recipe'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.alchemicalGold,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          color: AppColors.rubedoRed,
          onPressed: () => _deleteAttempt(attempt),
          tooltip: 'Delete',
        ),
      ],
    );
  }

  void _showAttemptDetails(AttemptRecord attempt) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildRecipeDetailsSheet(attempt),
    );
  }

  Widget _buildRecipeDetailsSheet(AttemptRecord attempt) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.voidCharcoal,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: AppColors.alchemicalGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.alchemicalGold.withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attempt #${attempt.attemptNumber} Recipe',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.alchemicalGold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.alabasterWhite,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: attempt.attemptedRecipe.steps.length,
              itemBuilder: (context, index) {
                final step = attempt.attemptedRecipe.steps[index];
                final isFailed =
                    !attempt.wasSuccessful &&
                    attempt.failedAtStep == step.stepNumber;

                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isFailed
                        ? AppColors.rubedoRed.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                    borderRadius: AppRadius.smallRadius,
                    border: Border.all(
                      color: isFailed
                          ? AppColors.rubedoRed
                          : AppColors.neutralSteel.withOpacity(0.3),
                      width: isFailed ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isFailed
                              ? AppColors.rubedoRed
                              : AppColors.alchemicalGold.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${step.stepNumber}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isFailed
                                  ? Colors.white
                                  : AppColors.alabasterWhite,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              AlchemyData.getActionIcon(step.action),
                              size: 16,
                              color: AppColors.alabasterWhite,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AlchemyData.getActionLabel(step.action),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.alabasterWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        ' + ',
                        style: TextStyle(color: AppColors.neutralSteel),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              AlchemyData.getMaterialIcon(step.material),
                              size: 16,
                              color: AlchemyData.getMaterialColor(
                                step.material,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                AlchemyData.getMaterialLabel(step.material),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AlchemyData.getMaterialColor(
                                    step.material,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isFailed)
                        const Icon(
                          Icons.close,
                          color: AppColors.rubedoRed,
                          size: 20,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteConfirmDialog(AttemptRecord attempt) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.voidCharcoal,
          borderRadius: AppRadius.largeRadius,
          border: Border.all(color: AppColors.rubedoRed, width: 2),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete_forever,
              color: AppColors.rubedoRed,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Delete Attempt?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.alabasterWhite,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Are you sure you want to delete Attempt #${attempt.attemptNumber}?',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.alabasterWhite,
                      side: BorderSide(
                        color: AppColors.neutralSteel.withOpacity(0.5),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rubedoRed,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearAllDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.voidCharcoal,
          borderRadius: AppRadius.largeRadius,
          border: Border.all(color: AppColors.rubedoRed, width: 2),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.rubedoRed,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Clear All Attempts?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.rubedoRed,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This will permanently delete all ${_attempts.length} attempt records. This action cannot be undone.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.alabasterWhite,
                      side: BorderSide(
                        color: AppColors.neutralSteel.withOpacity(0.5),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rubedoRed,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
