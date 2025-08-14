import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/mission.dart';
import '../models/milestone.dart';
import '../models/action_item.dart';
import '../models/pack_item.dart';
import '../components/milestone_timeline.dart';
import '../components/action_item_card.dart';
import '../components/smart_pack_grid.dart';
import '../components/knowledge_pod.dart';
import '../components/pulse_animation.dart';
import '../services/deepseek_ai_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 任务中枢屏幕，显示用户的任务和进度
class MissionHubScreen extends StatefulWidget {
  const MissionHubScreen({Key? key}) : super(key: key); //sssssss

  @override
  State<MissionHubScreen> createState() => _MissionHubScreenState();
}

class _MissionHubScreenState extends State<MissionHubScreen> {
  final TextEditingController _missionInputController = TextEditingController();
  final DeepseekAIService _deepseekAIService = DeepseekAIService();
  final StorageService _storageService = StorageService();
  final FocusNode _missionInputFocusNode = FocusNode();

  List<Mission> _missions = [];
  bool _isLoading = true;
  bool _isGenerating = false;
  String? _generationError;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _missionInputController.dispose();
    _missionInputFocusNode.dispose();
    _mounted = false;
    super.dispose();
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    // 迁移旧数据（如果有的话）
    await _storageService.migrateOldData();
    // 加载任务
    await _loadMissions();
  }

  /// 加载已保存的任务
  Future<void> _loadMissions() async {
    if (!_mounted) return;

    setState(() {
      _isLoading = true;
    });

    final missions = await _storageService.getMissions(MissionType.plan);

    if (!_mounted) return;

    setState(() {
      _missions = missions;
      _isLoading = false;
    });
  }

  /// 生成新任务
  Future<void> _generateMission() async {
    final input = _missionInputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your goal')));
      return;
    }

    // 收起键盘
    FocusScope.of(context).unfocus();

    if (!_mounted) return;

    setState(() {
      _isGenerating = true;
      _generationError = null;
    });

    try {
      // 使用DeepSeek AI服务生成任务
      final mission = await _deepseekAIService.generateMission(input);

      // 保存任务
      await _storageService.saveMission(mission, MissionType.plan);

      // 重新加载任务
      await _loadMissions();

      // 清空输入框
      _missionInputController.clear();

      if (!_mounted) return;

      // 显示成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mission created: ${mission.title}'),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      // 提供触觉反馈
      HapticFeedback.mediumImpact();
    } catch (e) {
      if (!_mounted) return;

      setState(() {
        _generationError = 'Failed to generate mission: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate mission: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    } finally {
      if (!_mounted) return;

      setState(() {
        _isGenerating = false;
      });
    }
  }

  /// 更新行动项状态
  Future<void> _updateActionItemStatus(
    Mission mission,
    Milestone milestone,
    ActionItem item,
    bool isCompleted,
  ) async {
    // 找到任务中的里程碑和行动项
    final missionIndex = _missions.indexWhere((m) => m.id == mission.id);
    if (missionIndex < 0) return;

    final updatedMilestones = List<Milestone>.from(mission.milestones);
    final milestoneIndex = updatedMilestones.indexWhere(
      (m) => m.id == milestone.id,
    );
    if (milestoneIndex < 0) return;

    final updatedActions = List<ActionItem>.from(milestone.actions);
    final actionIndex = updatedActions.indexWhere((a) => a.id == item.id);
    if (actionIndex < 0) return;

    // 更新行动项
    final updatedAction = updatedActions[actionIndex].copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
    );
    updatedActions[actionIndex] = updatedAction;

    // 更新里程碑状态
    final allCompleted = updatedActions.every((a) => a.isCompleted);
    final anyCompleted = updatedActions.any((a) => a.isCompleted);

    MilestoneStatus newStatus = milestone.status;
    if (allCompleted) {
      newStatus = MilestoneStatus.completed;
    } else if (anyCompleted) {
      newStatus = MilestoneStatus.inProgress;
    }

    final updatedMilestone = updatedMilestones[milestoneIndex].copyWith(
      actions: updatedActions,
      status: newStatus,
    );
    updatedMilestones[milestoneIndex] = updatedMilestone;

    // 更新任务
    final updatedMission = mission.copyWith(milestones: updatedMilestones);

    // 保存更新后的任务
    await _storageService.saveMission(updatedMission, MissionType.plan);

    // 更新状态
    if (!_mounted) return;

    setState(() {
      _missions[missionIndex] = updatedMission;
    });

    // 提供触觉反馈
    HapticFeedback.mediumImpact();

    // 如果完成了行动项，显示祝贺消息
    if (isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Great! You completed "${item.title}"'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }

    // 如果完成了里程碑，显示成就消息
    if (newStatus == MilestoneStatus.completed &&
        milestone.status != MilestoneStatus.completed) {
      _showMilestoneCompletionDialog(milestone);
    }
  }

  /// 显示里程碑完成对话框
  void _showMilestoneCompletionDialog(Milestone milestone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '🎉 Milestone Achieved!',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              color: AppTheme.accentOrange,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Congratulations on completing "${milestone.title}"',
              style: const TextStyle(color: AppTheme.primaryText, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep it up, you\'re making progress toward your goal!',
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: AppTheme.brandBlue),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  /// 更新打包物品状态
  Future<void> _updatePackItemStatus(Mission mission, PackItem item) async {
    // 找到任务中的物品
    final missionIndex = _missions.indexWhere((m) => m.id == mission.id);
    if (missionIndex < 0) return;

    final updatedItems = List<PackItem>.from(mission.packItems);
    final itemIndex = updatedItems.indexWhere((i) => i.id == item.id);
    if (itemIndex < 0) return;

    // 更新物品状态
    final updatedItem = updatedItems[itemIndex].copyWith(
      isPacked: !item.isPacked,
    );
    updatedItems[itemIndex] = updatedItem;

    // 更新任务
    final updatedMission = mission.copyWith(packItems: updatedItems);

    // 保存更新后的任务
    await _storageService.saveMission(updatedMission, MissionType.plan);

    // 更新状态
    if (!_mounted) return;

    setState(() {
      _missions[missionIndex] = updatedMission;
    });

    // 提供触觉反馈
    HapticFeedback.mediumImpact();
  }

  /// 显示知识胶囊详情
  void _showKnowledgePodDetail(KnowledgePod pod) {
    showDialog(
      context: context,
      builder: (context) => KnowledgePodDetailDialog(pod: pod),
    );
  }

  /// 删除任务
  Future<void> _deleteMission(Mission mission) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Mission',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${mission.title}"? This action cannot be undone',
          style: const TextStyle(color: AppTheme.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.deleteMission(mission.id, MissionType.plan);
      await _loadMissions();

      if (!_mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mission deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域收起键盘
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildMissionInput(),
                        const SizedBox(height: 24),
                        if (_missions.isEmpty && !_isGenerating)
                          _buildEmptyState()
                        else if (_missions.isNotEmpty)
                          ..._missions.map(
                            (mission) => _buildMissionDashboard(mission),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Virelia',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// 构建任务输入框
  Widget _buildMissionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PulseGlowAnimation(
          glowColor: AppTheme.accentOrange,
          child: TextField(
            controller: _missionInputController,
            focusNode: _missionInputFocusNode,
            decoration: InputDecoration(
              hintText:
                  'What\'s your mission? e.g., "Learn guitar in 3 months"',
              hintStyle: const TextStyle(color: AppTheme.secondaryText),
              filled: true,
              fillColor: AppTheme.surfaceBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
              enabled: !_isGenerating,
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: AppTheme.accentOrange),
                onPressed: _isGenerating ? null : _generateMission,
              ),
            ),
            style: const TextStyle(color: AppTheme.primaryText),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _generateMission(),
            // 限制输入长度
            maxLength: 50,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            // 隐藏计数器
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) =>
                null,
          ),
        ),
        if (_isGenerating)
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                const SpinKitWave(color: AppTheme.accentOrange, size: 30.0),
                const SizedBox(height: 8),
                const Text(
                  'AI is generating your personalized plan...',
                  style: TextStyle(color: AppTheme.secondaryText, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                if (_generationError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _generationError!,
                      style: const TextStyle(
                        color: AppTheme.errorRed,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.rocket_launch, color: AppTheme.brandBlue, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Start Your First Mission',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Describe your goal in the input box above, and AI will create a detailed plan for you',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _missionInputController.text = 'Learn guitar in 3 months';
              _generateMission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Try Example: Learn guitar in 3 months'),
          ),
        ],
      ),
    );
  }

  /// 构建任务仪表盘
  Widget _buildMissionDashboard(Mission mission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardHeader(mission),
          const SizedBox(height: 8),
          _buildProgressBar(mission),
          const SizedBox(height: 20),
          _buildMilestonesAndActions(mission),
          const Divider(height: 40, color: Colors.white10),
          _buildSmartPackAndKnowledge(mission),
        ],
      ),
    );
  }

  /// 构建仪表盘头部
  Widget _buildDashboardHeader(Mission mission) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mission.title,
                style: const TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (mission.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    mission.description,
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppTheme.secondaryText,
              ),
              onPressed: () => _deleteMission(mission),
              tooltip: 'Delete Mission',
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppTheme.accentOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.rocket_launch, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(Mission mission) {
    final progress = mission.completionProgress;
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Progress: $percentage%',
              style: const TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Start Date: ${_formatDate(mission.startDate)}',
              style: const TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.primaryBackground.withOpacity(0.5),
            color: AppTheme.successGreen,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  /// 构建里程碑和行动项部分
  Widget _buildMilestonesAndActions(Mission mission) {
    // 检查里程碑列表是否为空
    if (mission.milestones.isEmpty) {
      return const Center(
        child: Text(
          'No milestones available',
          style: TextStyle(color: AppTheme.secondaryText),
        ),
      );
    }

    // 获取当前活跃的里程碑
    final activeMilestone = mission.milestones.firstWhere(
      (m) => m.status == MilestoneStatus.inProgress,
      orElse: () => mission.milestones.firstWhere(
        (m) => m.status == MilestoneStatus.notStarted,
        orElse: () => mission.milestones.first,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 里程碑时间线
        Expanded(
          flex: 1,
          child: MilestoneTimeline(
            milestones: mission.milestones,
            onTap: (milestone) {
              // 点击里程碑的处理
              setState(() {
                // 重新构建以显示选中的里程碑的行动项
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        // 行动清单
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activeMilestone.title,
                style: const TextStyle(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (activeMilestone.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    activeMilestone.description,
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                const SizedBox(height: 8),
              ...activeMilestone.actions.map(
                (action) => ActionItemCard(
                  item: action,
                  onToggleComplete: (isCompleted) => _updateActionItemStatus(
                    mission,
                    activeMilestone,
                    action,
                    isCompleted,
                  ),
                  showDueDate: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建智能行囊和知识胶囊部分
  Widget _buildSmartPackAndKnowledge(Mission mission) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 智能行囊
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Smart Pack',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SmartPackGrid(
                    items: mission.packItems.take(6).toList(),
                    onItemTap: (item) => _updatePackItemStatus(mission, item),
                    columns: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 知识胶囊
            Expanded(
              child: KnowledgePodList(
                pods: mission.knowledgePods,
                onTap: _showKnowledgePodDetail,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}
