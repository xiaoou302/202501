import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.snowWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.snowWhite,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.charcoal,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.slateGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          FontAwesomeIcons.fileContract,
                          size: 32,
                          color: AppColors.slateGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'User Agreement',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Playfair Display',
                        color: AppColors.charcoal,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Last updated: January 29, 2026',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSection(
                    '1. Acceptance of Terms',
                    'By accessing and using Strida, you accept and agree to be bound by the terms and provision of this agreement.',
                  ),
                  _buildSection(
                    '2. Use of Service',
                    'You agree to use the service only for lawful purposes. You are prohibited from posting or transmitting any unlawful, threatening, libelous, defamatory, obscene, or profane material.',
                  ),
                  _buildSection(
                    '3. Zero Tolerance Policy',
                    'Strida maintains a strict zero-tolerance policy regarding objectionable content and abusive behavior. Users found engaging in harassment, hate speech, sharing of inappropriate content, or any form of abuse will face immediate consequences, including the removal of such content and the permanent banning of their account.',
                  ),
                  _buildSection(
                    '4. Intellectual Property',
                    'All content included on this app, such as text, graphics, logos, images, is the property of Strida or its content suppliers.',
                  ),
                  _buildSection(
                    '5. Termination',
                    'We reserve the right to terminate your access to the site, without any advance notice.',
                  ),
                  _buildSection(
                    '6. Changes to Agreement',
                    'We reserve the right to modify these terms at any time. Your continued use of the service constitutes your agreement to all such terms.',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
