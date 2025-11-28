import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
                  _buildAppLogo(),
                  const SizedBox(height: 32),
                  _buildInfoCard(
                    'What is Mireya?',
                    'Mireya is your personal dance companion, designed to help dancers of all levels track their progress, discover new techniques, and connect with a vibrant community of dance enthusiasts.',
                    Icons.info_rounded,
                    const Color(0xFF4A90E2),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Our Mission',
                    'To empower dancers worldwide by providing innovative tools for learning, tracking, and sharing their dance journey. We believe everyone has the potential to express themselves through movement.',
                    Icons.flag_rounded,
                    const Color(0xFFFF6B6B),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Features',
                    '• AI-powered dance analysis\n• Personalized training plans\n• Community insights & tips\n• Progress tracking & logging\n• Professional & amateur content',
                    Icons.star_rounded,
                    const Color(0xFFFFB347),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Contact Us',
                    'Email: support@mireya.app\nWebsite: www.mireya.app\nFollow us on social media for updates!',
                    Icons.email_rounded,
                    const Color(0xFF50C878),
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
        'About App',
        style: TextStyle(
          color: AppConstants.offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppConstants.theatreRed, AppConstants.balletPink],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppConstants.theatreRed.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.music_note_rounded,
          size: 64,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color iconColor) {
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
