import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

/// 版本历史页面
class VersionHistoryScreen extends StatelessWidget {
  const VersionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('版本历史'),
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
            _buildCurrentVersion(),
            const SizedBox(height: 24),
            
            // 版本历史时间线
            ..._buildVersionTimeline(),
          ],
        ),
      ),
    );
  }

  // 构建当前版本信息
  Widget _buildCurrentVersion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.fieryRed.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieryRed.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.fieryRed.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.new_releases,
                  color: AppColors.fieryRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前版本',
                    style: TextStyle(
                      color: AppColors.stardustWhite.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'v1.2.0',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.stardustWhite,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '2023-12-15',
                style: TextStyle(
                  color: AppColors.stardustWhite.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '最新版本特性',
            style: AppStyles.heading3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            icon: Icons.bolt,
            title: '实时市场资讯',
            description: '接入DeepSeek API，提供实时更新的金融市场资讯',
          ),
          _buildFeatureItem(
            icon: Icons.filter_alt,
            title: '资讯分类与筛选',
            description: '新增资讯分类功能，支持按类别筛选和关键词搜索',
          ),
          _buildFeatureItem(
            icon: Icons.auto_graph,
            title: '市场热点趋势',
            description: '新增市场热点趋势展示，帮助用户把握市场焦点',
          ),
          _buildFeatureItem(
            icon: Icons.bug_report,
            title: '问题修复',
            description: '修复了多个已知问题，提升了应用稳定性',
          ),
        ],
      ),
    );
  }

  // 构建版本历史时间线
  List<Widget> _buildVersionTimeline() {
    final versions = [
      {
        'version': 'v1.1.0',
        'date': '2023-11-01',
        'features': [
          '新增信号详情页面，提供更深入的市场分析',
          '优化了市场页面的UI设计，提升用户体验',
          '新增多种技术指标，增强市场分析能力',
          '修复了部分用户反馈的界面显示问题',
        ],
      },
      {
        'version': 'v1.0.5',
        'date': '2023-09-15',
        'features': [
          '优化应用性能，减少内存占用',
          '改进数据加载速度，提升用户体验',
          '新增市场筛选功能，支持多种排序方式',
          '修复了部分已知问题',
        ],
      },
      {
        'version': 'v1.0.0',
        'date': '2023-08-01',
        'features': [
          '应用首次发布',
          '提供实时市场行情数据',
          '基于市场情绪的交易信号功能',
          '金融市场资讯浏览功能',
        ],
      },
    ];

    return List.generate(versions.length, (index) {
      final version = versions[index];
      return _buildVersionItem(
        version: version['version'] as String,
        date: version['date'] as String,
        features: (version['features'] as List<String>),
        isLast: index == versions.length - 1,
      );
    });
  }

  // 构建单个版本项
  Widget _buildVersionItem({
    required String version,
    required String date,
    required List<String> features,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 时间线
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.coolBlue.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.coolBlue,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 120 + features.length * 20.0, // 动态调整高度
                color: AppColors.borderColor,
              ),
          ],
        ),
        const SizedBox(width: 16),
        
        // 版本内容
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    version,
                    style: AppStyles.heading3.copyWith(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: TextStyle(
                      color: AppColors.stardustWhite.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // 版本特性
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '更新内容',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.coolBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...features.map((feature) => _buildFeatureText(feature)).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建特性项
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.fieryRed,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.stardustWhite,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.stardustWhite.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建特性文本
  Widget _buildFeatureText(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.coolBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              feature,
              style: AppStyles.bodyText,
            ),
          ),
        ],
      ),
    );
  }
}