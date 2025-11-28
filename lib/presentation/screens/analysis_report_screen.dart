import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AnalysisReportScreen extends StatelessWidget {
  const AnalysisReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Report'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAISummary(),
                const SizedBox(height: 24),
                _buildDetailedBreakdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAISummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Text Feedback',
          style: TextStyle(
            color: AppConstants.offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppConstants.graphite,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'AI Summary:',
                style: TextStyle(
                  color: AppConstants.techBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '"Your form shows good spinal neutrality. The main correction area is your left arm angle, which is 8 degrees lower. Your right arm also has a slight deviation. Please focus on lifting from the shoulders."',
                style: TextStyle(
                  color: AppConstants.offWhite,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Breakdown',
          style: TextStyle(
            color: AppConstants.offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppConstants.graphite,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Column(
            children: [
              _buildMeasurementRow(
                'Left Arm Angle:',
                '82°',
                'Standard: 90°',
                AppConstants.theatreRed,
              ),
              const Divider(color: AppConstants.ebony, height: 24),
              _buildMeasurementRow(
                'Spine Neutrality:',
                'Good',
                'Match',
                AppConstants.techBlue,
              ),
              const Divider(color: AppConstants.ebony, height: 24),
              _buildMeasurementRow(
                'Right Arm Angle:',
                '88°',
                'Standard: 90°',
                AppConstants.offWhite,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementRow(
    String label,
    String value,
    String standard,
    Color valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppConstants.offWhite,
            fontSize: 14,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              standard,
              style: const TextStyle(
                color: AppConstants.midGray,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
