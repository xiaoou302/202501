import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/repositories/proposal_repository.dart';
import 'package:soli/presentation/screens/proposal_detail_screen.dart';

/// 求婚方案生成页面
class ProposalGeneratorScreen extends StatefulWidget {
  const ProposalGeneratorScreen({super.key});

  @override
  State<ProposalGeneratorScreen> createState() =>
      _ProposalGeneratorScreenState();
}

class _ProposalGeneratorScreenState extends State<ProposalGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProposalRepository _proposalRepository = ProposalRepository();

  // 表单控制器
  final TextEditingController _preferencesController = TextEditingController();
  final TextEditingController _partnerNameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  // Focus nodes
  final FocusNode _preferencesFocusNode = FocusNode();
  final FocusNode _partnerNameFocusNode = FocusNode();
  final FocusNode _relationshipFocusNode = FocusNode();
  final FocusNode _budgetFocusNode = FocusNode();
  final FocusNode _backgroundFocusNode = FocusNode(); // 用于背景点击

  // 状态变量
  bool _isLoading = false;
  String _selectedType = 'Romantic'; // 默认选择浪漫类型

  // 用于取消生成操作
  bool _isGenerating = false;

  // 可选的方案类型
  final List<Map<String, dynamic>> _proposalTypes = [
    {
      'type': 'Romantic',
      'icon': Icons.favorite,
      'description': 'Classic and heartfelt',
      'color': Colors.red[400]!,
    },
    {
      'type': 'Intimate',
      'icon': Icons.home,
      'description': 'Private and personal',
      'color': Colors.purple[300]!,
    },
    {
      'type': 'Adventurous',
      'icon': Icons.landscape,
      'description': 'Exciting and unique',
      'color': Colors.green[500]!,
    },
    {
      'type': 'Elaborate',
      'icon': Icons.celebration,
      'description': 'Grand and memorable',
      'color': Colors.amber[600]!,
    },
    {
      'type': 'Creative',
      'icon': Icons.lightbulb,
      'description': 'Unique and personalized',
      'color': Colors.blue[400]!,
    },
  ];

  @override
  void dispose() {
    // Dispose controllers
    _preferencesController.dispose();
    _partnerNameController.dispose();
    _relationshipController.dispose();
    _budgetController.dispose();

    // Dispose focus nodes
    _preferencesFocusNode.dispose();
    _partnerNameFocusNode.dispose();
    _relationshipFocusNode.dispose();
    _budgetFocusNode.dispose();
    _backgroundFocusNode.dispose();

    // Mark as not generating to prevent setState after dispose
    _isGenerating = false;

    super.dispose();
  }

  // 生成求婚方案
  Future<void> _generateProposal() async {
    if (_formKey.currentState!.validate()) {
      // 隐藏键盘，使用背景焦点节点
      FocusScope.of(context).requestFocus(_backgroundFocusNode);

      // 防止重复点击
      if (_isGenerating) return;

      // 标记正在生成，并更新UI
      _isGenerating = true;
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      try {
        // 调用仓库生成方案
        final plan = await _proposalRepository.generateProposalPlan(
          type: _selectedType,
          preferences: _preferencesController.text.trim(),
          partnerName: _partnerNameController.text.trim(),
          relationship: _relationshipController.text.trim(),
          budget: _budgetController.text.trim(),
        );

        // 检查组件是否还在树中
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        // 再次检查组件是否还在树中
        if (!mounted) return;

        // 导航到方案详情页面
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProposalDetailScreen(proposal: plan, showSaveButton: true),
          ),
        );

        // 如果用户保存了方案，返回true
        if (result == true && mounted) {
          // 保存方案
          await _proposalRepository.saveProposalPlan(plan);
          // 返回上一页，并传递保存成功的信息
          Navigator.pop(context, true);
        }
      } catch (e) {
        print('生成求婚方案错误: $e');

        // 检查组件是否还在树中
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to generate proposal plan. Please try again.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        // 无论成功还是失败，都重置生成状态
        _isGenerating = false;
      }
    }
  }

  // 此方法不再需要，已移动到ProposalDetailScreen

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 使用behavior属性确保GestureDetector能够接收到所有事件
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 点击空白区域时，将焦点转移到背景FocusNode，而不是直接unfocus
        FocusScope.of(context).requestFocus(_backgroundFocusNode);
      },
      child: Scaffold(
        backgroundColor: AppTheme.deepSpace,
        appBar: AppBar(
          backgroundColor: AppTheme.deepSpace,
          title: const Text('Proposal Generator'),
          foregroundColor: AppTheme.moonlight,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部介绍
                _buildIntroSection(),
                const SizedBox(height: 24),

                // 方案类型选择
                _buildTypeSelector(),
                const SizedBox(height: 30),

                // 表单输入 - 使用单独的StatefulWidget来避免整个页面重建
                PreferencesInputWidget(
                  controller: _preferencesController,
                  focusNode: _preferencesFocusNode,
                  nextFocusNode: _partnerNameFocusNode,
                ),
                const SizedBox(height: 20),

                PartnerNameInputWidget(
                  controller: _partnerNameController,
                  focusNode: _partnerNameFocusNode,
                  nextFocusNode: _relationshipFocusNode,
                ),
                const SizedBox(height: 20),

                RelationshipInputWidget(
                  controller: _relationshipController,
                  focusNode: _relationshipFocusNode,
                  nextFocusNode: _budgetFocusNode,
                ),
                const SizedBox(height: 20),

                BudgetInputWidget(
                  controller: _budgetController,
                  focusNode: _budgetFocusNode,
                  backgroundFocusNode: _backgroundFocusNode,
                ),
                const SizedBox(height: 30),

                // 生成按钮
                _buildGenerateButton(),
                const SizedBox(height: 30),

                // 加载指示器
                if (_isLoading) _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建介绍部分
  Widget _buildIntroSection() {
    return Animations.fadeSlideIn(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorUtils.withOpacity(AppTheme.silverstone, 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorUtils.withOpacity(AppTheme.champagne, 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorUtils.withOpacity(AppTheme.champagne, 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb,
                    color: AppTheme.champagne,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Create Your Perfect Proposal',
                    style: TextStyle(
                      color: AppTheme.champagne,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Our AI will generate a personalized proposal plan based on your preferences. Fill out the form below to get started.',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建类型选择器
  Widget _buildTypeSelector() {
    return Animations.fadeSlideIn(
      delay: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proposal Type',
            style: TextStyle(
              color: AppTheme.champagne,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _proposalTypes.length,
              itemBuilder: (context, index) {
                final type = _proposalTypes[index];
                final isSelected = type['type'] == _selectedType;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type['type'];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 16),
                    width: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSelected
                            ? [type['color'], type['color'].withOpacity(0.7)]
                            : [
                                ColorUtils.withOpacity(
                                  AppTheme.silverstone,
                                  0.7,
                                ),
                                ColorUtils.withOpacity(
                                  AppTheme.silverstone,
                                  0.4,
                                ),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: type['color'].withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                      border: Border.all(
                        color: isSelected
                            ? type['color'].withOpacity(0.7)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.3)
                                : ColorUtils.withOpacity(
                                    AppTheme.deepSpace,
                                    0.3,
                                  ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            type['icon'],
                            color: isSelected
                                ? Colors.white
                                : AppTheme.moonlight,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          type['type'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.moonlight,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          type['description'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : AppTheme.moonlight.withOpacity(0.7),
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 原始的输入字段构建方法已移至单独的StatefulWidget组件中

  // 构建生成按钮
  Widget _buildGenerateButton() {
    return Animations.fadeSlideIn(
      delay: 600,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _generateProposal,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.champagne,
            foregroundColor: AppTheme.deepSpace,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: AppTheme.champagne.withOpacity(0.5),
          ),
          child: const Text(
            'Generate Proposal Plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 构建加载指示器
  Widget _buildLoadingIndicator() {
    return Animations.fadeIn(
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: AppTheme.champagne,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Creating your perfect proposal plan...',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 此方法不再需要，已移动到ProposalDetailScreen

  // 此方法不再需要，已移动到ProposalDetailScreen

  // 此方法不再需要，已移动到ProposalDetailScreen
}

/// 偏好输入组件
class PreferencesInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const PreferencesInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  @override
  State<PreferencesInputWidget> createState() => _PreferencesInputWidgetState();
}

class _PreferencesInputWidgetState extends State<PreferencesInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Animations.fadeSlideIn(
      delay: 200,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: const TextStyle(color: AppTheme.moonlight),
        maxLines: 3,
        textInputAction: TextInputAction.next,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(widget.nextFocusNode),
        decoration: InputDecoration(
          labelText: 'Your Preferences',
          labelStyle: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
          ),
          hintText:
              'Describe what you want in your proposal (location, style, etc.)',
          hintStyle: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.5),
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppTheme.silverstone,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.champagne),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your preferences';
          }
          return null;
        },
      ),
    );
  }
}

/// 伴侣姓名输入组件
class PartnerNameInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const PartnerNameInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  @override
  State<PartnerNameInputWidget> createState() => _PartnerNameInputWidgetState();
}

class _PartnerNameInputWidgetState extends State<PartnerNameInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Animations.fadeSlideIn(
      delay: 300,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: const TextStyle(color: AppTheme.moonlight),
        textInputAction: TextInputAction.next,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(widget.nextFocusNode),
        decoration: InputDecoration(
          labelText: 'Partner\'s Name (Optional)',
          labelStyle: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
          ),
          filled: true,
          fillColor: AppTheme.silverstone,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.champagne),
          ),
        ),
      ),
    );
  }
}

/// 关系描述输入组件
class RelationshipInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const RelationshipInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
  });

  @override
  State<RelationshipInputWidget> createState() =>
      _RelationshipInputWidgetState();
}

class _RelationshipInputWidgetState extends State<RelationshipInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Animations.fadeSlideIn(
      delay: 400,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: const TextStyle(color: AppTheme.moonlight),
        textInputAction: TextInputAction.next,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(widget.nextFocusNode),
        decoration: InputDecoration(
          labelText: 'Relationship Details (Optional)',
          labelStyle: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
          ),
          hintText: 'How long you\'ve been together, shared interests, etc.',
          hintStyle: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.5),
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppTheme.silverstone,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.champagne),
          ),
        ),
      ),
    );
  }
}

/// 预算输入组件
class BudgetInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode backgroundFocusNode;

  const BudgetInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.backgroundFocusNode,
  });

  @override
  State<BudgetInputWidget> createState() => _BudgetInputWidgetState();
}

class _BudgetInputWidgetState extends State<BudgetInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Animations.fadeSlideIn(
      delay: 500,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: const TextStyle(color: AppTheme.moonlight),
        textInputAction: TextInputAction.done,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(widget.backgroundFocusNode),
        decoration: InputDecoration(
          labelText: 'Budget (Optional)',
          labelStyle: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
          ),
          hintText: 'e.g. \$500-\$1000, Low budget, No limit, etc.',
          hintStyle: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.5),
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppTheme.silverstone,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.champagne),
          ),
        ),
      ),
    );
  }
}
