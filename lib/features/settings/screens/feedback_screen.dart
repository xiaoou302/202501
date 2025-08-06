import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

/// 意见反馈页面
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // 表单控制器
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  // 焦点节点
  final FocusNode _feedbackFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();

  // 反馈类型
  String _selectedFeedbackType = '功能建议';
  final List<String> _feedbackTypes = ['功能建议', '问题报告', '体验优化', '其他'];

  // 是否包含截图
  bool _includeScreenshot = false;

  // 提交状态
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    _feedbackFocus.dispose();
    _contactFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白区域收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.midnightBlue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('意见反馈'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.midnightBlue,
                  AppColors.midnightBlue.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),

              // 反馈类型选择
              _buildFeedbackTypeSelector(),
              const SizedBox(height: 24),

              // 反馈内容输入框
              _buildFeedbackInput(),
              const SizedBox(height: 24),

              // 截图选项
              _buildScreenshotOption(),
              const SizedBox(height: 24),

              // 联系方式输入框
              _buildContactInput(),
              const SizedBox(height: 32),

              // 提交按钮
              _buildSubmitButton(),
              const SizedBox(height: 24),

              // 其他联系方式
              _buildOtherContactMethods(),
            ],
          ),
        ),
      ),
    );
  }

  // 构建页面头部
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '我们重视您的反馈',
          style: AppStyles.heading2,
        ),
        const SizedBox(height: 8),
        Text(
          '您的意见和建议是我们不断改进的动力。请告诉我们您的想法，我们将认真对待每一条反馈。',
          style: AppStyles.bodyText.copyWith(
            color: AppColors.stardustWhite.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // 构建反馈类型选择器
  Widget _buildFeedbackTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '反馈类型',
          style: AppStyles.heading3.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFeedbackType,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.stardustWhite,
              ),
              isExpanded: true,
              dropdownColor: Colors.grey.shade900,
              style: AppStyles.bodyText,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedFeedbackType = newValue;
                  });
                }
              },
              items:
                  _feedbackTypes.map<DropdownMenuItem<String>>((String value) {
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

  // 构建反馈内容输入框
  Widget _buildFeedbackInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '反馈内容',
          style: AppStyles.heading3.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _feedbackFocus.hasFocus
                  ? AppColors.fieryRed.withOpacity(0.5)
                  : AppColors.borderColor,
            ),
          ),
          child: TextField(
            controller: _feedbackController,
            focusNode: _feedbackFocus,
            style: AppStyles.bodyText,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: '请详细描述您的反馈或问题...',
              hintStyle: TextStyle(
                color: AppColors.stardustWhite.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  // 构建截图选项
  Widget _buildScreenshotOption() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.image,
            color: AppColors.stardustWhite.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '包含应用截图',
              style: AppStyles.bodyText,
            ),
          ),
          Switch(
            value: _includeScreenshot,
            onChanged: (value) {
              setState(() {
                _includeScreenshot = value;
              });
            },
            activeColor: AppColors.fieryRed.withOpacity(1.0),
          ),
        ],
      ),
    );
  }

  // 构建联系方式输入框
  Widget _buildContactInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '联系方式（选填）',
          style: AppStyles.heading3.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          '留下您的联系方式，我们可能会就您的反馈进行回复',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.stardustWhite.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _contactFocus.hasFocus
                  ? AppColors.fieryRed.withOpacity(0.5)
                  : AppColors.borderColor,
            ),
          ),
          child: TextField(
            controller: _contactController,
            focusNode: _contactFocus,
            style: AppStyles.bodyText,
            decoration: InputDecoration(
              hintText: '电子邮件或手机号码',
              hintStyle: TextStyle(
                color: AppColors.stardustWhite.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  // 构建提交按钮
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fieryRed.withOpacity(1.0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                '提交反馈',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // 构建其他联系方式
  Widget _buildOtherContactMethods() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '其他联系方式',
            style: AppStyles.heading3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildContactMethod(
            icon: Icons.email,
            title: '电子邮件',
            value: 'support@CoinAtlas-app.com',
          ),
          Divider(
            color: AppColors.borderColor,
            height: 24,
          ),
          _buildContactMethod(
            icon: Icons.support_agent,
            title: '客服电话',
            value: '400-123-4567',
          ),
        ],
      ),
    );
  }

  // 构建联系方式项
  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.coolBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.coolBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.stardustWhite.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.stardustWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 提交反馈
  void _submitFeedback() {
    // 验证输入
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入反馈内容')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // 模拟提交过程
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        // 显示成功提示
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey.shade900,
            title: Text(
              '提交成功',
              style: TextStyle(color: AppColors.stardustWhite),
            ),
            content: Text(
              '感谢您的反馈！我们会认真考虑您的意见和建议。',
              style: TextStyle(color: AppColors.stardustWhite),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 关闭对话框
                  Navigator.pop(context); // 返回上一页
                },
                child: Text('确定'),
              ),
            ],
          ),
        );
      }
    });
  }
}
