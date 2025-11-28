import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AppSecurityScreen extends StatelessWidget {
  const AppSecurityScreen({super.key});

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
                  _buildSecurityCard(
                    'Data Protection',
                    'Your personal data is encrypted using industry-standard AES-256 encryption. We never share your information with third parties without your explicit consent.',
                    Icons.shield_rounded,
                    const Color(0xFF50C878),
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityCard(
                    'Privacy First',
                    'We collect only the minimum data necessary to provide our services. You have full control over your data and can request deletion at any time.',
                    Icons.privacy_tip_rounded,
                    const Color(0xFF4A90E2),
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityCard(
                    'Secure Authentication',
                    'Your account is protected with secure authentication protocols. We recommend enabling two-factor authentication for additional security.',
                    Icons.lock_rounded,
                    const Color(0xFFFFB347),
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityCard(
                    'Data Storage',
                    'All data is stored on secure servers with regular backups. We comply with GDPR and other international data protection regulations.',
                    Icons.storage_rounded,
                    const Color(0xFF9B59B6),
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityCard(
                    'Report Security Issues',
                    'If you discover a security vulnerability, please report it to security@mireya.app. We take all reports seriously and respond promptly.',
                    Icons.bug_report_rounded,
                    const Color(0xFFE74C3C),
                  ),
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
        'App Security',
        style: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSecurityCard(String title, String content, IconData icon, Color iconColor) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppConstants.offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
}
