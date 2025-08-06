import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../services/deepseek_service.dart';
import 'ai_chat_screen.dart';

/// AI Assistant section with introduction and button to open chat
class AIAssistantSection extends StatelessWidget {
  final DeepseekService deepseekService;

  const AIAssistantSection({
    Key? key,
    required this.deepseekService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // AI Assistant introduction
          _buildAIIntroduction(context),
          const SizedBox(height: 32),

          // Chat button
          Center(
            child: _buildChatButton(context),
          ),
          const SizedBox(height: 32),

          // Features section
          _buildSectionHeader('AI助手功能', '了解AI助手可以为您提供的服务'),
          const SizedBox(height: 16),

          // Features list
          _buildFeaturesList(),
          const SizedBox(height: 32),

          // Usage tips
          _buildSectionHeader('使用技巧', '如何更好地使用AI助手'),
          const SizedBox(height: 16),

          // Tips list
          _buildTipsList(),

          // Bottom padding
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAIIntroduction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.midnightBlue.withOpacity(0.8),
            AppColors.goldenHighlight.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenHighlight.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.goldenHighlight.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.smart_toy,
                  color: AppColors.goldenHighlight,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 加密货币助手',
                      style: AppStyles.heading2,
                    ),
                    Text(
                      '您的专业加密货币顾问',
                      style: AppStyles.secondaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '欢迎使用AI加密货币助手！我可以回答您关于加密货币、区块链技术、交易策略等问题。无论您是初学者还是有经验的投资者，都可以向我咨询。请注意，我只能回答加密货币相关问题，不会回答与战争、政治、法律、医疗相关的话题。',
            style: AppStyles.bodyText,
          ),
          const SizedBox(height: 16),
          Text(
            '点击下方按钮开始对话，或浏览下方了解更多功能。',
            style: AppStyles.bodyTextSmall.copyWith(
              color: AppColors.stardustWhite.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AIChatScreen(deepseekService: deepseekService),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.goldenHighlight,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: AppColors.goldenHighlight.withOpacity(0.5),
      ),
      icon: const Icon(Icons.chat_bubble_outline, size: 24),
      label: const Text(
        '开始聊天',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.heading3,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppStyles.secondaryText.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: [
        _buildFeatureItem(
            Icons.school, '加密货币知识', '了解比特币、以太坊等加密货币的基础知识、工作原理和发展历史'),
        _buildFeatureItem(
            Icons.trending_up, '交易策略咨询', '获取关于加密货币交易策略、风险管理和市场分析的专业建议'),
        _buildFeatureItem(
            Icons.security, '安全指导', '学习如何安全存储加密货币、识别常见骗局和保护您的数字资产'),
        _buildFeatureItem(Icons.integration_instructions, '技术解析',
            '深入了解区块链技术、智能合约、DeFi和NFT等前沿概念'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF212121).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.goldenHighlight.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.goldenHighlight,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppStyles.bodyTextSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF212121).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTipItem(
            '提出具体问题',
            '明确的问题能够获得更精准的回答，例如"什么是比特币挖矿？"比"告诉我比特币的事情"更好',
          ),
          Divider(color: AppColors.borderColor),
          _buildTipItem(
            '指定信息需求',
            '如果您需要特定类型的信息，请明确说明，例如"请解释智能合约的安全风险"',
          ),
          Divider(color: AppColors.borderColor),
          _buildTipItem(
            '追问细节',
            '如果回答不够清晰，可以追问更多细节，例如"能否进一步解释闪电网络的工作原理？"',
          ),
          Divider(color: AppColors.borderColor),
          _buildTipItem(
            '使用关键词',
            '在问题中包含关键词有助于获得更相关的回答，例如"DeFi"、"流动性挖矿"等',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.tips_and_updates,
            color: AppColors.goldenHighlight,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppStyles.bodyTextSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
