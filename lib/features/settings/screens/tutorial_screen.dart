import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

/// 新手引导页面
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  // 当前页面索引
  int _currentPage = 0;

  // 页面控制器
  final PageController _pageController = PageController();

  // 引导页内容
  final List<Map<String, dynamic>> _tutorialPages = [
    {
      'title': '欢迎使用CoinAtlas',
      'description': '专业的金融市场分析工具，为您提供实时行情、市场信号和财经资讯。',
      'icon': Icons.auto_graph,
      'color': AppColors.fieryRed,
    },
    {
      'title': '市场行情',
      'description': '查看实时货币对行情，支持多种筛选和排序方式，轻松掌握市场动态。',
      'icon': Icons.bar_chart,
      'color': AppColors.coolBlue,
    },
    {
      'title': '交易信号',
      'description': '基于市场情绪和技术指标的交易信号，帮助您把握最佳交易时机。',
      'icon': Icons.satellite_alt,
      'color': AppColors.goldenHighlight,
    },
    {
      'title': '市场资讯',
      'description': '实时更新的金融市场资讯，让您第一时间了解影响市场的重要事件。',
      'icon': Icons.bolt,
      'color': Colors.green,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('新手引导'),
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
      body: Column(
        children: [
          // 主要内容区域
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _tutorialPages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildTutorialPage(
                  title: _tutorialPages[index]['title'],
                  description: _tutorialPages[index]['description'],
                  icon: _tutorialPages[index]['icon'],
                  color: _tutorialPages[index]['color'],
                );
              },
            ),
          ),

          // 页面指示器和按钮
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 页面指示器
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _tutorialPages.length,
                    (index) => _buildPageIndicator(index == _currentPage),
                  ),
                ),
                const SizedBox(height: 32),

                // 按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 上一页按钮
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          '上一页',
                          style: TextStyle(
                            color: AppColors.stardustWhite.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 80),

                    // 下一页/完成按钮
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _tutorialPages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tutorialPages[_currentPage]['color'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentPage < _tutorialPages.length - 1 ? '下一页' : '完成',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }

  // 构建单个引导页
  Widget _buildTutorialPage({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 图标
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 80,
              color: color,
            ),
          ),
          const SizedBox(height: 40),

          // 标题
          Text(
            title,
            style: AppStyles.heading1.copyWith(
              fontSize: 28,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 描述
          Text(
            description,
            style: AppStyles.bodyText.copyWith(
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 构建页面指示器
  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? _tutorialPages[_currentPage]['color']
            : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
