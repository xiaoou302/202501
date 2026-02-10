import 'package:flutter/material.dart';
import 'package:zenithsprint/app/app_routes.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';
import 'package:zenithsprint/data/models/sprint_session.dart';

class SprintResultsScreen extends StatelessWidget {
  const SprintResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SprintSession? session = ModalRoute.of(context)?.settings.arguments as SprintSession?;
    
    // Fallback data if no session is passed
    final accuracy = session?.accuracy.toStringAsFixed(0) ?? '93';
    final answered = session?.totalQuestions.toString() ?? '14';
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.padding_large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Sprint Complete!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  _buildResultCard(context, 'Accuracy', '$accuracy%'),
                  const SizedBox(width: AppValues.margin),
                  _buildResultCard(context, 'Answered', answered),
                ],
              ),
              const SizedBox(height: 24),
              _buildCognitiveTipCard(context),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // In a real app, you might want to pop until you get to the home screen
                  // and then navigate to the insights tab.
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home, (route) => false);
                },
                child: const Text('View Full Insights'),
              ),
              const SizedBox(height: AppValues.margin),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.sprint);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.neutralLight),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Start Another Sprint'),
              ),
              const SizedBox(height: AppValues.margin),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppValues.padding_large),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(AppValues.radius),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.neutralLight),
            ),
            const SizedBox(height: AppValues.margin_small),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCognitiveTipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding_large),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.radius_large),
        gradient: const LinearGradient(
          colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cognitive Tip Unlocked!',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppValues.margin_small),
          Text(
            'The Rule of 72: A simple way to estimate an investment\'s doubling time.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }
}
