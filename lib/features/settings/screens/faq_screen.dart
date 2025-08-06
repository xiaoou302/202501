import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

/// 常见问题与解答页面
class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  // 存储展开状态的列表
  late List<bool> _expandedList;

  // FAQ问题和答案
  final List<Map<String, String>> _faqItems = [
    {
      'question': '如何查看市场行情？',
      'answer':
          '您可以在应用底部导航栏选择"市场"选项卡，查看实时行情数据。市场页面提供了多种货币对的实时价格、涨跌幅等信息，您还可以使用搜索功能快速查找特定货币对。'
    },
    {
      'question': '如何理解信号页面的数据？',
      'answer':
          '信号页面展示了基于市场情绪和技术分析的交易信号。每个信号卡片包含资产名称、情绪评分、波动指数和推荐操作等信息。情绪评分越高表示市场对该资产越看好，您可以点击卡片查看更详细的分析。'
    },
    {
      'question': '应用中的资讯来源于哪里？',
      'answer':
          '我们的资讯来自多个专业金融数据源，包括主流财经媒体和市场分析机构。系统会自动过滤和整合这些信息，为您提供最相关、最及时的市场动态。资讯页面每5分钟自动刷新一次，确保您获取的是最新信息。'
    },
    {
      'question': '如何筛选特定类别的资讯？',
      'answer':
          '在资讯页面顶部，您可以看到不同的资讯类别标签，如"外汇"、"加密货币"、"股票"等。点击这些标签即可筛选对应类别的资讯。您还可以使用搜索框输入关键词，查找特定主题的资讯。'
    },
    {
      'question': '应用是否支持离线使用？',
      'answer':
          '我们的应用会在您联网时缓存部分数据，因此在短时间的网络中断情况下，您仍然可以查看之前加载的信息。但由于金融市场数据实时变化的特性，我们建议在网络连接良好的环境下使用本应用，以确保获取最新、最准确的市场信息。'
    },
    {
      'question': '如何提交功能建议或问题反馈？',
      'answer':
          '您可以在设置页面中找到"意见反馈"选项，通过该功能向我们提交您的建议或问题。我们的团队会认真审阅每一条反馈，并在后续版本中不断优化应用体验。'
    },
  ];

  @override
  void initState() {
    super.initState();
    // 初始化所有问题为折叠状态
    _expandedList = List.generate(_faqItems.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('常见问题与解答'),
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
            Text(
              '常见问题',
              style: AppStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              '以下是用户常见的问题和解答，希望能帮助您更好地使用我们的应用。',
              style: AppStyles.bodyTextSmall,
            ),
            const SizedBox(height: 24),

            // FAQ列表
            ..._buildFAQList(),

            const SizedBox(height: 32),

            // 联系支持
          ],
        ),
      ),
    );
  }

  // 构建FAQ列表
  List<Widget> _buildFAQList() {
    return List.generate(_faqItems.length, (index) {
      return _buildFAQItem(
        question: _faqItems[index]['question']!,
        answer: _faqItems[index]['answer']!,
        isExpanded: _expandedList[index],
        onTap: () {
          setState(() {
            _expandedList[index] = !_expandedList[index];
          });
        },
      );
    });
  }

  // 构建单个FAQ项
  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 问题部分
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: AppStyles.heading3.copyWith(fontSize: 16),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.stardustWhite,
                    ),
                  ],
                ),
              ),
            ),

            // 答案部分
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded ? null : 0,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: isExpanded ? 16.0 : 0,
                ),
                child: Text(
                  answer,
                  style: AppStyles.bodyText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建联系支持部分
}
