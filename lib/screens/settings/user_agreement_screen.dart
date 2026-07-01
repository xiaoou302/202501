import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'User Agreement',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.creamWhite,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.warmGauze.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.chestnutGray.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Service',
                style: TextStyle(
                  color: AppColors.cocoaBrown,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 24),
              Text(
                '1. Purpose of the App\n'
                'This application is designed to assist in tracking and managing the care of stray animals. It does NOT provide professional medical diagnosis.\n\n'
                '2. AI Analysis Limitations\n'
                'The AI analysis provided by this app is for reference only. Always consult a qualified veterinarian for actual health concerns.\n\n'
                '3. Data Privacy\n'
                'All photos and records you create are stored locally on your device to protect your privacy. We do not collect or share your personal rescue data.\n\n'
                '4. User Conduct\n'
                'Users are expected to treat animals with respect and care. Any form of animal abuse is strictly condemned.\n\n'
                'By using this application, you agree to these terms and commit to being a responsible guardian for animals in need.',
                style: TextStyle(
                  color: AppColors.chestnutGray,
                  fontSize: 14,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
