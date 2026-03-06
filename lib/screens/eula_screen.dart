import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/color_palette.dart';
import '../theme/app_theme.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

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
          "EULA",
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zero Tolerance Alert Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorPalette.obsidian,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.triangleExclamation,
                        color: ColorPalette.rustedCopper,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "ZERO TOLERANCE POLICY",
                        style: AppTheme.monoStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Selah is committed to maintaining a safe and respectful community. We have a strict zero-tolerance policy regarding objectionable content and abusive users.",
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),
                  _buildBulletPoint(
                    "Objectionable Content",
                    "Includes hate speech, harassment, nudity, violence, illegal activities, and spam.",
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint(
                    "Consequences",
                    "Violations will result in immediate content removal and permanent account ban without prior notice.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader("AI SERVICES & PRIVACY"),
            const SizedBox(height: 16),

            _buildTermItem(
              number: "AI",
              title: "AI Service Providers",
              content:
                  "This application uses Doubao (by ByteDance) and DeepSeek as its AI service providers to deliver intelligent analysis features.",
            ),
            _buildTermItem(
              number: "DS",
              title: "Data Sharing Policy",
              content:
                  "Does this application share user data with third-party AI services? No. Your data is processed solely to provide the requested analysis and is not shared with third parties.",
            ),

            const SizedBox(height: 32),

            _buildSectionHeader("STANDARD TERMS"),
            const SizedBox(height: 16),

            _buildTermItem(
              number: "01",
              title: "License Grant",
              content:
                  "Selah grants you a revocable, non-exclusive, non-transferable, limited license to download, install, and use the Application strictly in accordance with the terms of this Agreement.",
            ),
            _buildTermItem(
              number: "02",
              title: "User Content",
              content:
                  "You are solely responsible for the content you post. By posting content, you grant Selah a license to use, modify, and display such content. You agree not to post content that violates any third-party rights or laws.",
            ),
            _buildTermItem(
              number: "03",
              title: "Restrictions",
              content:
                  "You agree not to decompile, reverse engineer, disassemble, attempt to derive the source code of, or decrypt the Application.",
            ),
            _buildTermItem(
              number: "04",
              title: "Termination",
              content:
                  "This Agreement is effective until terminated by you or Selah. Your rights under this Agreement will terminate automatically without notice if you fail to comply with any term(s) of this Agreement.",
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                "By using Selah, you agree to these terms.",
                style: AppTheme.monoStyle.copyWith(
                  fontSize: 10,
                  color: ColorPalette.matteSteel.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: ColorPalette.rustedCopper,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: "$title: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(text: content),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.monoStyle.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: ColorPalette.matteSteel,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTermItem({
    required String number,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: AppTheme.monoStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ColorPalette.obsidian.withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.obsidian,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: ColorPalette.matteSteel,
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
