import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orivet/core/constants/colors.dart';

class GuideStepWidget extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final bool isCompleted;
  final String? warning;

  const GuideStepWidget({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.warning,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isCompleted ? 0.5 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.shale : AppColors.leather,
              shape: BoxShape.circle,
              border: isCompleted ? Border.all(color: AppColors.leather) : null,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: GoogleFonts.lato(
                  color: isCompleted ? AppColors.leather : AppColors.vellum,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    color: AppColors.soot,
                    height: 1.5,
                  ),
                ),
                if (warning != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.shale,
                      border:
                          Border.all(color: AppColors.leather.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.triangleExclamation,
                            color: AppColors.wax, size: 12),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            warning!.toUpperCase(),
                            style: GoogleFonts.lato(
                              color: AppColors.leather,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
