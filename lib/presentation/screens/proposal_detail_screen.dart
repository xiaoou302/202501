import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/proposal_plan_model.dart';
import 'package:soli/data/repositories/proposal_repository.dart';

/// 方案详情展示页面
class ProposalDetailScreen extends StatefulWidget {
  final ProposalPlanModel proposal;
  final bool showSaveButton;
  final bool showDeleteButton;

  const ProposalDetailScreen({
    super.key,
    required this.proposal,
    this.showSaveButton = false,
    this.showDeleteButton = true,
  });

  @override
  State<ProposalDetailScreen> createState() => _ProposalDetailScreenState();
}

class _ProposalDetailScreenState extends State<ProposalDetailScreen> {
  final ProposalRepository _proposalRepository = ProposalRepository();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        title: const Text('Proposal Details'),
        foregroundColor: AppTheme.moonlight,
        elevation: 0,
        actions: [
          if (widget.showDeleteButton)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _isDeleting
                  ? null
                  : () => _showDeleteConfirmation(context),
              tooltip: 'Delete this proposal',
            ),
        ],
      ),
      body: _isDeleting
          ? _buildDeletingIndicator()
          : SingleChildScrollView(
              child: Animations.fadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题部分
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.champagne,
                            AppTheme.champagne.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.proposal.title,
                                  style: const TextStyle(
                                    color: AppTheme.deepSpace,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.proposal.type,
                                  style: const TextStyle(
                                    color: AppTheme.deepSpace,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.proposal.description,
                            style: TextStyle(
                              color: AppTheme.deepSpace.withOpacity(0.8),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 内容部分
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 步骤
                          _buildSectionTitle('Steps'),
                          const SizedBox(height: 12),
                          ...List.generate(widget.proposal.steps.length, (
                            index,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    margin: const EdgeInsets.only(
                                      right: 12,
                                      top: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.withOpacity(
                                        AppTheme.champagne,
                                        0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: AppTheme.champagne,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.proposal.steps[index],
                                      style: TextStyle(
                                        color: ColorUtils.withOpacity(
                                          AppTheme.moonlight,
                                          0.9,
                                        ),
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 24),

                          // 所需物品
                          _buildSectionTitle('Materials Needed'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.proposal.materials.map((material) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorUtils.withOpacity(
                                    AppTheme.silverstone,
                                    0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: ColorUtils.withOpacity(
                                      AppTheme.champagne,
                                      0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  material,
                                  style: TextStyle(
                                    color: ColorUtils.withOpacity(
                                      AppTheme.moonlight,
                                      0.9,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 24),

                          // 地点和时间
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  'Location',
                                  widget.proposal.location,
                                  Icons.place,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoItem(
                                  'Timing',
                                  widget.proposal.timing,
                                  Icons.access_time,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 预算
                          _buildInfoItem(
                            'Budget',
                            widget.proposal.budget,
                            Icons.account_balance_wallet,
                          ),

                          const SizedBox(height: 32),

                          // 按钮区域
                          if (widget.showSaveButton) _buildSaveButton(context),

                          // 复制按钮
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _copyToClipboard(context),
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy to Clipboard'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.champagne,
                                side: const BorderSide(
                                  color: AppTheme.champagne,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          // 删除按钮 (底部位置)
                          if (widget.showDeleteButton)
                            Column(
                              children: [
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _isDeleting
                                        ? null
                                        : () =>
                                              _showDeleteConfirmation(context),
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    label: const Text('Delete This Plan'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

  // 显示删除确认对话框
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.silverstone,
        title: const Text(
          'Delete Proposal',
          style: TextStyle(color: AppTheme.moonlight),
        ),
        content: const Text(
          'Are you sure you want to delete this proposal plan? This action cannot be undone.',
          style: TextStyle(color: AppTheme.moonlight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.moonlight),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      _deleteProposal();
    }
  }

  // 删除方案
  Future<void> _deleteProposal() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await _proposalRepository.deleteProposalPlan(widget.proposal.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposal plan deleted successfully'),
            backgroundColor: AppTheme.champagne,
          ),
        );

        // 返回上一页，并传递删除成功的信息
        Navigator.pop(context, 'deleted');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 构建删除中指示器
  Widget _buildDeletingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.champagne),
          const SizedBox(height: 20),
          Text(
            'Deleting proposal...',
            style: TextStyle(
              color: ColorUtils.withOpacity(AppTheme.moonlight, 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // 构建保存按钮
  Widget _buildSaveButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proposal plan saved successfully!'),
                  backgroundColor: AppTheme.champagne,
                ),
              );
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.favorite),
            label: const Text('Save This Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.coral,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: AppTheme.coral.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // 复制到剪贴板
  void _copyToClipboard(BuildContext context) {
    final text =
        '''
${widget.proposal.title}

${widget.proposal.description}

Steps:
${widget.proposal.steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

Materials Needed:
${widget.proposal.materials.map((e) => '- $e').join('\n')}

Location: ${widget.proposal.location}
Timing: ${widget.proposal.timing}
Budget: ${widget.proposal.budget}
''';

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proposal plan copied to clipboard!'),
        backgroundColor: AppTheme.champagne,
      ),
    );
  }

  // 构建部分标题
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.champagne,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: ColorUtils.withOpacity(AppTheme.champagne, 0.3),
          ),
        ),
      ],
    );
  }

  // 构建信息项
  Widget _buildInfoItem(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorUtils.withOpacity(AppTheme.champagne, 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.champagne, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.champagne,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
