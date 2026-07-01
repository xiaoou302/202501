import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.cocoaBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'End User License Agreement',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + 24,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    icon: Icons.gavel_rounded,
                    title: 'Community Guidelines & Zero Tolerance',
                    contentWidget: _buildZeroTolerancePolicy(),
                    iconColor: Colors.redAccent,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    icon: Icons.psychology_alt_rounded,
                    title: 'AI Services & Data Sharing',
                    contentWidget: _buildAIDataPolicy(),
                    iconColor: AppColors.seafoam,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget contentWidget,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.cocoaBrown,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          contentWidget,
        ],
      ),
    );
  }

  Widget _buildZeroTolerancePolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'We are committed to building a warm and pure community for stray animal rescue.',
          style: TextStyle(
            color: AppColors.chestnutGray,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
          ),
          child: const Text(
            'We have zero tolerance for objectionable content and abusive users.',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Consequences of Violation: Any content involving violence, pornography, fake medical fundraising, or animal abuse will be immediately deleted upon discovery. For users who post such content, we will take severe measures including permanent account bans, without exception. Users can also provide feedback on objectionable content at any time using the long-press report feature on the interface.',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAIDataPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQnA(
          question: 'Please specify which AI service your application uses.',
          answer:
              'This application uses the "Doubao" large model provided by Volcengine to analyze the breed, age, and health condition recommendations of stray animals.',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(color: AppColors.mistyFoam, height: 1),
        ),
        _buildQnA(
          question:
              'Does your application share data with third-party AI services?',
          answer:
              'Yes. In order to implement the "AI Scan" feature, we need to transmit the pictures and related text descriptions of stray animals you capture or upload to the Volcengine "Doubao" large model for inference and analysis.',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(color: AppColors.mistyFoam, height: 1),
        ),
        _buildQnA(
          question:
              'Where can we view the user authorization confirmation before information sharing?',
          answer:
              'User authorization confirmation is reflected in two places:\n1. Startup Confirmation: When launching the App for the first time, you must check and agree to this End User License Agreement (EULA) on the splash screen before entering the main interface;\n2. Feature Prompt: Before you actually use the "AI Scan" feature, the interface will provide a clear AI privacy authorization prompt, and data transmission and analysis will only proceed after your confirmation.',
        ),
      ],
    );
  }

  Widget _buildQnA({required String question, required String answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Q: ',
              style: TextStyle(
                color: AppColors.seafoam,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  color: AppColors.cocoaBrown,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A: ',
              style: TextStyle(
                color: AppColors.peachFuzz,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Text(
                answer,
                style: const TextStyle(
                  color: AppColors.chestnutGray,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
