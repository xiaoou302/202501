import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.midnight,
      appBar: AppBar(
        backgroundColor: AppConstants.midnight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.offwhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Disclaimer',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: AppConstants.offwhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFFF9800),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please read carefully',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF9800),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              'General Information',
              'The information provided by MeeMi is for general informational and educational purposes only. All information in the app is provided in good faith, however we make no representation or warranty of any kind regarding the accuracy, adequacy, validity, reliability, or completeness of any information.',
            ),
            _buildSection(
              'Educational Content',
              'The art techniques, tips, and guidance provided through our AI mentor and other features are for educational purposes only. They should not be considered as professional art instruction or substitute for formal art education.',
            ),
            _buildSection(
              'User-Generated Content',
              'MeeMi is not responsible for the content shared by users within the app. We do not endorse, support, represent, or guarantee the completeness, truthfulness, accuracy, or reliability of any user-generated content.',
            ),
            _buildSection(
              'AI-Generated Advice',
              'Our AI mentor provides suggestions based on general art principles and patterns. The advice may not be suitable for all situations or skill levels. Users should exercise their own judgment when applying any suggestions.',
            ),
            _buildSection(
              'No Professional Advice',
              'The content in MeeMi does not constitute professional advice. We are not liable for any losses or damages in connection with the use of our app or reliance on any information provided.',
            ),
            _buildSection(
              'External Links',
              'MeeMi may contain links to external websites that are not provided or maintained by us. We do not guarantee the accuracy, relevance, timeliness, or completeness of any information on these external websites.',
            ),
            _buildSection(
              'Limitation of Liability',
              'In no event shall MeeMi, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the app.',
            ),
            _buildSection(
              'Changes to Disclaimer',
              'We reserve the right to make changes to this disclaimer at any time. Your continued use of the app following any changes indicates your acceptance of the new terms.',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppConstants.gold,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Use at Your Own Risk',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.offwhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By using MeeMi, you acknowledge that you have read and understood this disclaimer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.metalgray.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.gold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.offwhite,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
