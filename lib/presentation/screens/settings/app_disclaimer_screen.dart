import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AppDisclaimerScreen extends StatelessWidget {
  const AppDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWarningCard(),
                  const SizedBox(height: 24),
                  _buildSection(
                    'General Disclaimer',
                    'The information provided by Mireya is for general informational purposes only. All information on the app is provided in good faith, however we make no representation or warranty of any kind, express or implied, regarding the accuracy, adequacy, validity, reliability, availability or completeness of any information on the app.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Health & Safety',
                    'Mireya is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition or physical activity.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Professional Advice',
                    'The content on Mireya should not be considered professional dance instruction. Users should consult with qualified dance instructors before attempting new techniques or movements.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'User Content',
                    'Views and opinions expressed by users are theirs alone and do not represent the views of Mireya. We are not responsible for user-generated content.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'External Links',
                    'Mireya may contain links to external websites. We have no control over the content and nature of these sites and cannot be held responsible for their content.',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Limitation of Liability',
                    'Under no circumstance shall we have any liability to you for any loss or damage of any kind incurred as a result of the use of the app or reliance on any information provided on the app.',
                  ),
                  const SizedBox(height: 24),
                  _buildLastUpdated(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppConstants.ebony.withValues(alpha: 0.95),
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConstants.graphite.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppConstants.offWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'App Disclaimer',
        style: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE74C3C).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE74C3C).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE74C3C).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: Color(0xFFE74C3C),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Please read carefully',
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.graphite.withValues(alpha: 0.5),
            AppConstants.graphite.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.midGray.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppConstants.offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: AppConstants.midGray.withValues(alpha: 0.9),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Center(
      child: Text(
        'Last Updated: November 28, 2024',
        style: TextStyle(
          color: AppConstants.midGray.withValues(alpha: 0.7),
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
