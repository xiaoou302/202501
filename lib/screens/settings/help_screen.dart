import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: AppColors.cocoaBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.cocoaBrown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildFaqItem(
            'How do I scan a stray?',
            'Go to the Scan tab, tap the camera or gallery icon, select a clear photo of the stray, and tap "Analyze" to get AI insights.',
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            'How do I update a rescue record?',
            'In the Rescue Journey tab, tap on any existing record card to add a new daily entry for that specific pet. Multiple records will be beautifully stacked.',
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            'Can I delete a record?',
            'Yes. Tap the trash bin icon on the top right of a daily record card to permanently delete it.',
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            'Are the AI health tips medically accurate?',
            'No. The AI provides general advice based on visual features. Always consult a real veterinarian for medical issues.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warmGauze.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.peachFuzz,
          collapsedIconColor: AppColors.chestnutGray,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(
            question,
            style: const TextStyle(
              color: AppColors.cocoaBrown,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                answer,
                style: const TextStyle(
                  color: AppColors.chestnutGray,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
