import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/core/utils/error_handler.dart';
import 'package:soli/data/repositories/proposal_repository.dart';

/// 方案创建页面
class ProposalCreatorScreen extends StatefulWidget {
  const ProposalCreatorScreen({super.key});

  @override
  State<ProposalCreatorScreen> createState() => _ProposalCreatorScreenState();
}

class _ProposalCreatorScreenState extends State<ProposalCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ProposalRepository _proposalRepository = ProposalRepository();

  // 用于管理焦点的FocusNode
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _backgroundFocusNode = FocusNode(); // 用于背景点击
  final List<FocusNode> _stepFocusNodes = [];

  String _selectedType = '餐厅';
  final List<TextEditingController> _stepControllers = [
    TextEditingController(),
  ];
  bool _isLoading = false;

  // 可选的方案类型
  final List<String> _proposalTypes = ['餐厅', '户外', '家庭'];

  @override
  void initState() {
    super.initState();
    // 初始化第一个步骤的FocusNode
    _stepFocusNodes.add(FocusNode());
  }

  @override
  void dispose() {
    // 释放控制器资源
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }

    // 释放焦点节点资源
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _backgroundFocusNode.dispose(); // 释放背景焦点节点
    for (var focusNode in _stepFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  // 添加步骤
  void _addStep() {
    // 隐藏键盘
    FocusScope.of(context).unfocus();

    setState(() {
      // 限制最大步骤数为10个
      if (_stepControllers.length < 10) {
        _stepControllers.add(TextEditingController());
        _stepFocusNodes.add(FocusNode()); // 为新步骤添加FocusNode
      } else {
        // 显示提示
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('最多只能添加10个步骤'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  // 删除步骤
  void _removeStep(int index) {
    // 隐藏键盘
    FocusScope.of(context).unfocus();

    setState(() {
      // 释放资源
      _stepControllers[index].dispose();
      _stepFocusNodes[index].dispose();

      // 移除控制器和焦点节点
      _stepControllers.removeAt(index);
      _stepFocusNodes.removeAt(index);
    });
  }

  // 保存方案
  Future<void> _saveProposal() async {
    // 隐藏键盘
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      // 验证步骤是否为空
      final nonEmptySteps = _stepControllers
          .map((controller) => controller.text.trim())
          .where((step) => step.isNotEmpty)
          .toList();
      if (nonEmptySteps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请至少添加一个步骤'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final plan = await _proposalRepository.generateProposalPlan(
          type: _selectedType,
          preferences: _descriptionController.text.trim(),
        );

        if (mounted) {
          ErrorHandler.showSuccess(context, '方案创建成功！');

          // 导航到社区页面并显示生成的方案
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
            arguments: {
              'initialTab': 1, // 社区页面索引
              'showProposalPlan': true,
              'proposalPlan': plan,
            },
          );
        }
      } catch (e) {
        if (mounted) {
          ErrorHandler.showError(context, '创建失败: ${e.toString()}');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // 使用已经定义的_backgroundFocusNode

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
          title: const Text('创建方案'),
          foregroundColor: AppTheme.moonlight,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.champagne),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题输入
                      _buildTitleInput(),
                      const SizedBox(height: 20),

                      // 类型选择
                      _buildTypeSelector(),
                      const SizedBox(height: 20),

                      // 描述输入
                      _buildDescriptionInput(),
                      const SizedBox(height: 24),

                      // 步骤列表 - 使用单独的StatefulWidget来避免整个页面重建
                      StepListWidget(
                        stepControllers: _stepControllers,
                        stepFocusNodes: _stepFocusNodes,
                        onAddStep: _addStep,
                        onRemoveStep: _removeStep,
                      ),
                      const SizedBox(height: 32),

                      // 保存按钮
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProposal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.champagne,
                            foregroundColor: AppTheme.deepSpace,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '保存方案',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // 构建标题输入
  Widget _buildTitleInput() {
    return TextFormField(
      controller: _titleController,
      focusNode: _titleFocusNode,
      style: const TextStyle(color: AppTheme.moonlight),
      maxLength: 30, // 限制最大输入长度为30个字符
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textCapitalization: TextCapitalization.sentences, // 首字母自动大写
      textInputAction: TextInputAction.next, // 键盘显示下一步按钮
      onEditingComplete: () => FocusScope.of(
        context,
      ).requestFocus(_descriptionFocusNode), // 点击下一步时切换到描述输入框
      // 自定义计数器显示，避免使用setState导致整个页面重建
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            int? maxLength,
          }) {
            return Text(
              '$currentLength/$maxLength',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                fontSize: 12,
              ),
            );
          },
      decoration: InputDecoration(
        labelText: '方案标题',
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
        // 使用buildCounter来处理计数器，不需要在这里设置counterText
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '请输入方案标题';
        }
        if (value.trim().length < 2) {
          return '标题至少需要2个字符';
        }
        return null;
      },
    );
  }

  // 构建描述输入
  Widget _buildDescriptionInput() {
    return TextFormField(
      controller: _descriptionController,
      focusNode: _descriptionFocusNode,
      style: const TextStyle(color: AppTheme.moonlight),
      maxLines: 5, // 增加行数以便输入更多内容
      maxLength: 200, // 限制最大输入长度为200个字符
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textCapitalization: TextCapitalization.sentences, // 首字母自动大写
      textInputAction: TextInputAction.newline, // 键盘显示换行按钮
      // 自定义计数器显示，避免使用setState导致整个页面重建
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            int? maxLength,
          }) {
            return Text(
              '$currentLength/$maxLength',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                fontSize: 12,
              ),
            );
          },
      onTap: () {
        // 确保点击时滚动到可见区域
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_descriptionFocusNode.context != null) {
            Scrollable.ensureVisible(
              _descriptionFocusNode.context!,
              alignment: 0.5,
              duration: const Duration(milliseconds: 300),
            );
          }
        });
      },
      decoration: InputDecoration(
        labelText: '方案描述',
        labelStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
        ),
        hintText: '详细描述您的方案内容和目标...',
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
        // 使用maxLength和buildCounter来自动处理计数器
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '请输入方案描述';
        }
        if (value.trim().length < 10) {
          return '描述至少需要10个字符';
        }
        return null;
      },
    );
  }

  // 构建类型选择器
  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '方案类型',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.silverstone,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              dropdownColor: AppTheme.silverstone,
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppTheme.champagne,
              ),
              style: const TextStyle(color: AppTheme.moonlight, fontSize: 16),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
              items: _proposalTypes.map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // 步骤列表已移至StepListWidget组件
}

/// 步骤列表组件 - 使用单独的StatefulWidget来避免整个页面重建
class StepListWidget extends StatefulWidget {
  final List<TextEditingController> stepControllers;
  final List<FocusNode> stepFocusNodes;
  final VoidCallback onAddStep;
  final Function(int) onRemoveStep;

  const StepListWidget({
    super.key,
    required this.stepControllers,
    required this.stepFocusNodes,
    required this.onAddStep,
    required this.onRemoveStep,
  });

  @override
  State<StepListWidget> createState() => _StepListWidgetState();
}

class _StepListWidgetState extends State<StepListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '方案步骤',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.stepControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 步骤序号
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppTheme.champagne,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppTheme.deepSpace,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 步骤输入框
                  Expanded(
                    child: TextFormField(
                      controller: widget.stepControllers[index],
                      focusNode: widget.stepFocusNodes[index],
                      style: const TextStyle(color: AppTheme.moonlight),
                      maxLength: 100, // 限制最大输入长度为100个字符
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textCapitalization:
                          TextCapitalization.sentences, // 首字母自动大写
                      textInputAction: TextInputAction.done, // 键盘显示完成按钮
                      // 自定义计数器显示，避免使用setState导致整个页面重建
                      buildCounter:
                          (
                            BuildContext context, {
                            required int currentLength,
                            required bool isFocused,
                            int? maxLength,
                          }) {
                            // 只在获得焦点时显示计数器
                            return isFocused
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.withOpacity(
                                        AppTheme.deepSpace,
                                        0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$currentLength/$maxLength',
                                      style: const TextStyle(
                                        color: AppTheme.moonlight,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(); // 未获得焦点时不显示
                          },
                      onTap: () {
                        // 确保点击时滚动到可见区域
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (widget.stepFocusNodes[index].context != null) {
                            Scrollable.ensureVisible(
                              widget.stepFocusNodes[index].context!,
                              alignment: 0.5,
                              duration: const Duration(milliseconds: 300),
                            );
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '输入步骤描述',
                        hintStyle: TextStyle(
                          color: ColorUtils.withOpacity(
                            AppTheme.moonlight,
                            0.5,
                          ),
                        ),
                        filled: true,
                        fillColor: AppTheme.silverstone,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppTheme.champagne,
                          ),
                        ),
                        counterText: '', // 隐藏默认字数计数器
                      ),
                      validator: (value) {
                        if (index == 0 &&
                            (value == null || value.trim().isEmpty)) {
                          return '请至少输入一个步骤';
                        }
                        return null;
                      },
                    ),
                  ),
                  // 删除按钮
                  if (widget.stepControllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onRemoveStep(index),
                    ),
                ],
              ),
            );
          },
        ),
        // 添加步骤按钮
        Center(
          child: TextButton.icon(
            onPressed: widget.onAddStep,
            icon: const Icon(Icons.add, color: AppTheme.champagne),
            label: const Text(
              '添加步骤',
              style: TextStyle(color: AppTheme.champagne),
            ),
          ),
        ),
      ],
    );
  }
}
