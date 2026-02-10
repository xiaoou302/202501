import 'package:flutter/material.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.padding_large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(AppValues.radius_large),
                    ),
                    child: const Icon(
                      Icons.flash_on,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin),
                  const Text(
                    'Zenith Sprint',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_small),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.neutralDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.margin_extra_large),

            // About Content
            Container(
              padding: const EdgeInsets.all(AppValues.padding_large),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppValues.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin),
                  const Text(
                    'Zenith Sprint is dedicated to helping professionals improve their cognitive abilities, especially their mental arithmetic skills under pressure.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.neutralDark,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_large),
                  const Text(
                    'Our Vision',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin),
                  const Text(
                    'Our mission is to transform calculation from a conscious effort into an unconscious intuition, enabling users to perform at their best in high-pressure environments.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.neutralDark,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_large),
                  const Text(
                    'Core Values',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin),
                  _buildValueItem('Professionalism',
                      'Training methods based on cognitive science'),
                  _buildValueItem('Personalization',
                      'Adaptive training difficulty and content'),
                  _buildValueItem('Practicality',
                      'Challenges that simulate real professional scenarios'),
                  _buildValueItem(
                      'Growth', 'Visualized progress tracking and analysis'),
                ],
              ),
            ),
            const SizedBox(height: AppValues.margin_large),

            // Contact Info
            Container(
              padding: const EdgeInsets.all(AppValues.padding_large),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppValues.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin),
                  _buildContactItem(Icons.email, 'support@zenithsprint.com'),
                  _buildContactItem(Icons.language, 'www.zenithsprint.com'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.margin_small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.neutralDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.margin_small),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppValues.icon_medium,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppValues.margin),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.neutralDark,
            ),
          ),
        ],
      ),
    );
  }
}
