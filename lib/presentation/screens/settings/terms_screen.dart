import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Terms of Service screen
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.parchmentGradient,
          ),
          image: DecorationImage(
            image: NetworkImage(
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
            ),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.parchmentLight,
                          AppColors.parchmentMedium.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderMedium, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          'Acceptance of Terms',
                          'By accessing and using Zenion: The Fading Codex ("the Game"), you accept and agree to be bound by the terms and provision of this agreement.',
                        ),
                        _buildSection(
                          'License',
                          'We grant you a personal, non-transferable, non-exclusive license to use the Game for your personal, non-commercial use only.',
                        ),
                        _buildSection(
                          'User Conduct',
                          'You agree not to use the Game for any unlawful purpose or in any way that interrupts, damages, or impairs the service.',
                        ),
                        _buildSection(
                          'Game Content',
                          'All content included in the Game, such as text, graphics, logos, and software, is the property of Zenion Team and protected by copyright laws.',
                        ),
                        _buildSection(
                          'Modifications',
                          'We reserve the right to modify or discontinue the Game at any time without prior notice.',
                        ),
                        _buildSection(
                          'Disclaimer',
                          'The Game is provided "as is" without warranties of any kind. We do not guarantee that the Game will be error-free or uninterrupted.',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Last Updated: January 2025',
                          style: TextStyle(
                            color: AppColors.inkFaded,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentDark.withOpacity(0.3),
            AppColors.parchmentMedium.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.inkBlack.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              iconSize: 20,
              onPressed: () => Navigator.pop(context),
              color: AppColors.inkBrown,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: AppColors.inkBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'User Agreement',
                  style: TextStyle(
                    color: AppColors.inkFaded,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.description_rounded, color: AppColors.magicPurple, size: 28),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.magicPurple,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: AppColors.inkBrown,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
