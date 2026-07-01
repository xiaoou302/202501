import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class VisualTags extends StatelessWidget {
  final bool isValidPet;
  final String breed;
  final String estimatedAge;
  final String condition;
  final String message;

  const VisualTags({
    super.key,
    required this.isValidPet,
    required this.breed,
    required this.estimatedAge,
    required this.condition,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!isValidPet) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.morningPeach,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.peachFuzz),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.cocoaBrown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          icon: Icons.pets,
          title: 'Breed',
          text: breed,
          iconColor: AppColors.seafoam,
          bgColor: AppColors.mistyFoam.withValues(alpha: 0.5),
          borderColor: AppColors.seafoam.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          icon: Icons.cake,
          title: 'Estimated Age',
          text: estimatedAge,
          iconColor: AppColors.seafoam,
          bgColor: AppColors.mistyFoam.withValues(alpha: 0.5),
          borderColor: AppColors.seafoam.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          icon: Icons.health_and_safety,
          title: 'Condition',
          text: condition,
          iconColor: AppColors.cocoaBrown,
          bgColor: AppColors.creamWhite,
          borderColor: AppColors.warmGauze,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          icon: Icons.lightbulb_outline,
          title: 'Advice',
          text: message,
          iconColor: AppColors.peachFuzz,
          bgColor: AppColors.morningPeach.withValues(alpha: 0.3),
          borderColor: AppColors.peachFuzz.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String text,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text.isEmpty ? 'N/A' : text,
            style: const TextStyle(
              color: AppColors.cocoaBrown,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
