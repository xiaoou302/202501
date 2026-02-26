import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orivet/core/constants/colors.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      appBar: AppBar(
        backgroundColor: AppColors.vellum,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(FontAwesomeIcons.arrowLeft, color: AppColors.leather),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "TERMS OF SERVICE",
          style: GoogleFonts.cinzel(
            color: AppColors.leather,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zero Tolerance Warning
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.wax.withOpacity(0.1),
                border: Border.all(color: AppColors.wax, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.triangleExclamation,
                          color: AppColors.wax, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "ZERO TOLERANCE POLICY",
                          style: GoogleFonts.cinzel(
                            color: AppColors.wax,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Rue has a strict zero-tolerance policy regarding objectionable content and abusive behavior.",
                    style: GoogleFonts.lato(
                      color: AppColors.ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We do not tolerate:",
                    style: GoogleFonts.lato(color: AppColors.ink),
                  ),
                  const SizedBox(height: 4),
                  _buildBulletPoint("Hate speech, harassment, or bullying."),
                  _buildBulletPoint(
                      "Nudity, pornography, or sexually explicit content."),
                  _buildBulletPoint(
                      "Violence, self-harm, or dangerous activities."),
                  _buildBulletPoint("Spam, scams, or misleading information."),
                  const SizedBox(height: 12),
                  Text(
                    "Consequences of Violation:",
                    style: GoogleFonts.lato(
                      color: AppColors.wax,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildBulletPoint(
                      "Immediate removal of offending content (posts, images, comments)."),
                  _buildBulletPoint(
                      "Permanent suspension (ban) of the user account."),
                  _buildBulletPoint(
                      "Reporting to relevant authorities if necessary."),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Standard Terms
            _buildSectionTitle("1. Acceptance of Terms"),
            _buildSectionText(
                "By accessing or using the Rue app, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree, please do not use the app."),

            _buildSectionTitle("2. User Conduct"),
            _buildSectionText(
                "You are responsible for all content you upload, post, or share. You agree not to use the app for any illegal or unauthorized purpose."),

            _buildSectionTitle("3. Content Ownership & AI Processing"),
            _buildSectionText(
                "You retain ownership of the photos you upload. Rue uses Volcengine's AI services to analyze and generate restoration guides."),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.shale.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.leather.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.shieldHalved,
                      size: 16, color: AppColors.leather),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Data Privacy: Your photos are processed securely and are NOT shared with third parties for training or marketing purposes. Processing is ephemeral and solely for providing the restoration service.",
                      style: GoogleFonts.lato(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle("4. Disclaimer"),
            _buildSectionText(
                "The AI restoration guide is for reference only. Rue is not responsible for any damage caused to your items during the restoration process. Always consult a professional for valuable artifacts."),

            const SizedBox(height: 40),
            Center(
              child: Text(
                "Last Updated: February 2025",
                style: GoogleFonts.lato(
                  color: AppColors.soot,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.wax),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(color: AppColors.ink, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.cinzel(
          color: AppColors.leather,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        color: AppColors.soot,
        height: 1.5,
        fontSize: 14,
      ),
    );
  }
}
