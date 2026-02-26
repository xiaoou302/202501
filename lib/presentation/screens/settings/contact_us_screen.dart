import 'package:flutter/material.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      appBar: AppBar(
        title: Text("Contact Us",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 20)),
        backgroundColor: AppColors.vellum,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(FontAwesomeIcons.arrowLeft, color: AppColors.leather),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(FontAwesomeIcons.envelopesBulk,
                size: 64, color: AppColors.leather),
            const SizedBox(height: 24),
            const Text(
              "Get in Touch",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.leather),
            ),
            const SizedBox(height: 8),
            const Text(
              "We'd love to hear from you. Our team is always here to chat.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.soot, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildContactItem(
              context,
              FontAwesomeIcons.envelope,
              "Email Support",
              "support@orivet.com",
              "Our friendly team is here to help.",
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              FontAwesomeIcons.globe,
              "Visit Website",
              "www.orivet.com",
              "View our latest articles and updates.",
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              FontAwesomeIcons.locationDot,
              "Headquarters",
              "123 Artisan Way, Steampunk City",
              "Come say hello at our office HQ.",
            ),
            const SizedBox(height: 32),
            const Divider(color: AppColors.leather),
            const SizedBox(height: 24),
            const Text(
              "Follow Us",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.leather),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(FontAwesomeIcons.twitter),
                const SizedBox(width: 24),
                _buildSocialIcon(FontAwesomeIcons.instagram),
                const SizedBox(width: 24),
                _buildSocialIcon(FontAwesomeIcons.linkedin),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String title,
      String contact, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.leather.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.leather.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.leather.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.leather, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 14, color: AppColors.soot.withOpacity(0.8))),
                const SizedBox(height: 8),
                Text(contact,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teal)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.leather),
        color: AppColors.vellum,
      ),
      child: Icon(icon, color: AppColors.leather, size: 20),
    );
  }
}
