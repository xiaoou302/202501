import 'package:flutter/material.dart';
import 'package:zenithsprint/app/app_routes.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';
import 'package:zenithsprint/data/models/sprint_session.dart';

class InitialReportScreen extends StatelessWidget {
  const InitialReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)!.settings.arguments;
    SprintSession? session;

    if (arguments is SprintSession) {
      session = arguments;
    }

    final accuracy = session != null && session.totalQuestions > 0
        ? (session.correctAnswers / session.totalQuestions * 100)
            .toStringAsFixed(1)
        : "0.0";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppValues.padding_large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              'Congratulations!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              "You have completed the initial assessment.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 48),
            if (session != null) ...[
              _buildStatCard(
                  'Correct Answers', session.correctAnswers.toString()),
              const SizedBox(height: 16),
              _buildStatCard('Accuracy', '$accuracy%'),
            ] else ...[
              _buildStatCard('Correct Answers', 'N/A'),
              const SizedBox(height: 16),
              _buildStatCard('Accuracy', 'N/A'),
            ],
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child:
                  const Text('Start Training', style: TextStyle(fontSize: 16)),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppValues.padding_large),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.neutralDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
