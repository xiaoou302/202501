import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

/// 关于我们页面
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('关于我们'),
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
        child: Column(
          children: [
            // 应用信息部分
            _buildAppInfo(),

            // 公司介绍部分
            _buildCompanyInfo(),

            // 我们的使命部分
            _buildMission(),

            // 团队成员部分
            _buildTeam(),

            // 联系我们部分
            _buildContactInfo(),

            // 底部版权信息
            _buildFooter(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 构建应用信息部分
  Widget _buildAppInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          // 应用图标
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.fieryRed,
                  AppColors.coolBlue,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.fieryRed.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_graph,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 应用名称
          const Text(
            'CoinAtlas',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.stardustWhite,
            ),
          ),
          const SizedBox(height: 8),

          // 应用描述
          Text(
            '专业的金融市场分析工具',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.stardustWhite.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),

          // 版本信息
          Text(
            'v1.2.0 (Build 2023121501)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.stardustWhite.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // 构建公司介绍部分
  Widget _buildCompanyInfo() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '公司介绍',
            style: AppStyles.heading2,
          ),
          const SizedBox(height: 16),
          Text(
            'CoinAtlas由一群热爱金融科技的专业人士创立于2023年，总部位于中国深圳。我们致力于将先进的数据分析技术与金融市场洞察相结合，为用户提供专业、直观的市场分析工具。',
            style: AppStyles.bodyText.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            '我们的团队拥有丰富的金融市场经验和技术背景，包括来自顶级投资银行、科技公司和研究机构的专业人才。我们相信，通过技术创新和专业分析，可以帮助每个人更好地理解和参与金融市场。',
            style: AppStyles.bodyText.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  // 构建使命部分
  Widget _buildMission() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.fieryRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline,
              size: 40,
              color: AppColors.fieryRed.withOpacity(1.0),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '我们的使命',
            style: AppStyles.heading2,
          ),
          const SizedBox(height: 16),
          Text(
            '让金融市场分析变得简单、专业、可靠',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.stardustWhite,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '我们致力于打破金融信息不对称，通过技术创新和数据分析，为每个用户提供专业的市场洞察，帮助他们做出更明智的投资决策。',
            style: AppStyles.bodyText.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 构建团队部分
  Widget _buildTeam() {
    final teamMembers = [
      {
        'name': '张明',
        'role': '创始人 & CEO',
        'description': '前摩根大通量化分析师，拥有10年金融市场经验',
        'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
      },
      {
        'name': '李婷',
        'role': '首席技术官',
        'description': '前谷歌高级工程师，人工智能和数据分析专家',
        'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
      },
      {
        'name': '王浩',
        'role': '首席产品官',
        'description': '前腾讯产品经理，专注用户体验和产品设计',
        'avatar': 'https://randomuser.me/api/portraits/men/62.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '核心团队',
            style: AppStyles.heading2,
          ),
          const SizedBox(height: 24),
          ...teamMembers.map((member) => _buildTeamMember(member)).toList(),
        ],
      ),
    );
  }

  // 构建团队成员卡片
  Widget _buildTeamMember(Map<String, String> member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          // 头像
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              member['avatar']!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade800,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey.shade400,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.stardustWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member['role']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.coolBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member['description']!,
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

  // 构建联系信息部分
  Widget _buildContactInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Text(
            '联系我们',
            style: AppStyles.heading2,
          ),
          const SizedBox(height: 24),
          _buildContactItem(
            icon: Icons.email,
            title: '电子邮件',
            value: 'contact@CoinAtlas-app.com',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.phone,
            title: '电话',
            value: '400-123-4567',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.location_on,
            title: '地址',
            value: '中国深圳市南山区科技园科技中路1号',
          ),
          const SizedBox(height: 24),

          // 社交媒体图标
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.public),
              _buildSocialIcon(Icons.facebook),
              _buildSocialIcon(Icons.chat),
              _buildSocialIcon(Icons.tiktok),
            ],
          ),
        ],
      ),
    );
  }

  // 构建联系方式项
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.coolBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.coolBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
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

  // 构建社交媒体图标
  Widget _buildSocialIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.fieryRed.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.fieryRed.withOpacity(0.3),
        ),
      ),
      child: Icon(
        icon,
        color: AppColors.fieryRed.withOpacity(1.0),
        size: 24,
      ),
    );
  }

  // 构建页脚
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Divider(
            color: AppColors.borderColor,
          ),
          const SizedBox(height: 16),
          Text(
            '© 2023 CoinAtlasTech. 保留所有权利。',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.stardustWhite.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
