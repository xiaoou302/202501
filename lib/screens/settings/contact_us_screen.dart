import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.concrete,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: ColorPalette.obsidian,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "CONTACT US",
          style: AppTheme.monoStyle.copyWith(
            color: ColorPalette.obsidian,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "GET IN TOUCH",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ColorPalette.obsidian,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We'd love to hear from you.",
              style: TextStyle(color: ColorPalette.matteSteel, fontSize: 16),
            ),
            const SizedBox(height: 48),
            _buildContactCard(
              icon: FontAwesomeIcons.envelope,
              color: Colors.blueAccent,
              title: "Email Support",
              content: "support@baristal.app",
              subtitle: "Response time: < 24 hours",
            ),
            const SizedBox(height: 24),
            _buildContactCard(
              icon: FontAwesomeIcons.twitter,
              color: Colors.black,
              title: "Social Media",
              content: "@baristal_app",
              subtitle: "Follow us for brewing tips",
            ),
            const SizedBox(height: 24),
            _buildContactCard(
              icon: FontAwesomeIcons.globe,
              color: Colors.purpleAccent,
              title: "Official Website",
              content: "www.baristal.app",
              subtitle: "Read our blog & changelog",
            ),
            const SizedBox(height: 24),
            _buildContactCard(
              icon: FontAwesomeIcons.locationDot,
              color: Colors.redAccent,
              title: "HQ Location",
              content: "Shanghai, China",
              subtitle: "Coffee Lab & Innovation Center",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTheme.monoStyle.copyWith(
                    fontSize: 10,
                    color: ColorPalette.matteSteel,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 18,
                    color: ColorPalette.obsidian,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: ColorPalette.matteSteel.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
