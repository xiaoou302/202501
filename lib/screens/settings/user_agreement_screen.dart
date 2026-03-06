import 'package:flutter/material.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

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
          "USER AGREEMENT",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorPalette.concreteDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Last Updated: Oct 2024",
                style: AppTheme.monoStyle.copyWith(
                  fontSize: 10,
                  color: ColorPalette.matteSteel,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildTermItem(
              number: "01",
              title: "Acceptance of Terms",
              content:
                  "By accessing and using Selah, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by these terms, please do not use this service.",
            ),
            _buildTermItem(
              number: "02",
              title: "Use of License",
              content:
                  "Permission is granted to temporarily download one copy of the materials (information or software) on Selah for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.",
            ),
            _buildTermItem(
              number: "03",
              title: "Disclaimer",
              content:
                  "The materials on Selah are provided 'as is'. Selah makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability.",
            ),
            _buildTermItem(
              number: "04",
              title: "Limitations",
              content:
                  "In no event shall Selah or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Selah.",
            ),
            _buildTermItem(
              number: "05",
              title: "Governing Law",
              content:
                  "Any claim relating to Selah shall be governed by the laws of the local jurisdiction without regard to its conflict of law provisions.",
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "End of Agreement",
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

  Widget _buildTermItem({
    required String number,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: AppTheme.monoStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ColorPalette.rustedCopper,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.obsidian,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
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
