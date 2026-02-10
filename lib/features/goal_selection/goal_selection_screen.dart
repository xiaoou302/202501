import 'package:flutter/material.dart';
import 'package:zenithsprint/app/app_routes.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  GoalSelectionScreenState createState() => GoalSelectionScreenState();
}

class GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? _selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.padding_large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                "What's your primary goal?",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              _buildGoalOption(
                'Ace your interviews',
                'Prepare for high-pressure quantitative assessments.',
              ),
              const SizedBox(height: AppValues.margin),
              _buildGoalOption(
                'Boost job performance',
                'Enhance your speed and accuracy in daily tasks.',
              ),
              const SizedBox(height: AppValues.margin),
              _buildGoalOption(
                'Prep for standardized tests',
                'Sharpen your mental math for exams like GMAT or GRE.',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedGoal != null
                    ? () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.baselineTest);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  // When not selected, the button is disabled
                  backgroundColor: _selectedGoal != null
                      ? AppColors.accent
                      : AppColors.neutralDark,
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: AppValues.margin),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalOption(String title, String subtitle) {
    final bool isSelected = _selectedGoal == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppValues.padding_large),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.accent.withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(AppValues.radius),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white24,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.neutralLight, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppValues.margin),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.accent,
              ),
          ],
        ),
      ),
    );
  }
}
