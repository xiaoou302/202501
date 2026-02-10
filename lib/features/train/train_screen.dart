import 'package:flutter/material.dart';
import 'package:zenithsprint/app/app_routes.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppValues.padding_large),
          children: [
            Text(
              'Train',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppValues.margin_large),
            _buildPressureChamberCard(context),
            const SizedBox(height: AppValues.margin_large),
            Text(
              'Specialized Training',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.neutralLight, fontSize: 18),
            ),
            const SizedBox(height: AppValues.margin),
            _buildTrainingItem(
              context,
              title: 'Core Arithmetic',
              subtitle: 'Basic Operations',
              icon: Icons.calculate_outlined,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.sprint),
            ),
            const SizedBox(height: AppValues.margin_small),
            _buildTrainingItem(
              context,
              title: 'Percentages & Fractions',
              subtitle: 'Percentages and Fractions',
              icon: Icons.percent_outlined,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.sprint),
            ),
            const SizedBox(height: AppValues.margin_small),
            _buildTrainingItem(
              context,
              title: 'Estimation Drills',
              subtitle: 'Estimation Practice',
              icon: Icons.lightbulb_outline,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.sprint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureChamberCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding_large),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.radius_large),
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The Pressure Chamber',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppValues.margin_small),
          Text(
            'Simulate real-world high-stakes scenarios.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: AppValues.margin),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.sprint),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white.withValues(alpha: 0.2),
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppValues.radius_small),
              ),
            ),
            child: const Text('Explore Scenarios'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingItem(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppValues.padding),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(AppValues.radius),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.neutralLight, size: 28),
            const SizedBox(width: AppValues.margin),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.neutralLight),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.neutralLight),
          ],
        ),
      ),
    );
  }
}
