import 'package:flutter/material.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _selectedFeedbackType = '';
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Feedback and Suggestions',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.padding_large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppValues.padding_large),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppValues.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.feedback_outlined,
                        color: AppColors.accent,
                        size: AppValues.icon_large,
                      ),
                      const SizedBox(width: AppValues.margin),
                      const Expanded(
                        child: Text(
                          'We Value Your Opinion',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppValues.margin),
                  const Text(
                    'Your feedback helps us continuously improve Zenith Sprint. Please let us know your thoughts, suggestions, or any issues you encounter.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.neutralDark,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.margin_large),

            // Feedback Form
            Container(
              padding: const EdgeInsets.all(AppValues.padding_large),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppValues.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Feedback Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_small),
                  _buildFeedbackTypeChips(),
                  const SizedBox(height: AppValues.margin_large),

                  const Text(
                    'Detailed Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_small),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText:
                          'Please describe your feedback or suggestions in detail...',
                      hintStyle: TextStyle(color: AppColors.neutralLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppValues.radius),
                        borderSide: BorderSide(color: AppColors.neutralLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppValues.radius),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      filled: true,
                      fillColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_large),

                  const Text(
                    'Contact Information (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_small),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email address, so we can get back to you',
                      hintStyle: TextStyle(color: AppColors.neutralLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppValues.radius),
                        borderSide: BorderSide(color: AppColors.neutralLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppValues.radius),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                      filled: true,
                      fillColor: AppColors.secondary,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: AppValues.margin_extra_large),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showSubmitDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppValues.radius),
                        ),
                      ),
                      child: const Text(
                        'Submit Feedback',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.margin_large),

            // Alternative Contact Methods
            Container(
              padding: const EdgeInsets.all(AppValues.padding_large),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppValues.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Other Contact Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppValues.margin),
                  _buildContactMethod(
                    Icons.email,
                    'Email',
                    'feedback@zenithsprint.com',
                  ),
                  _buildContactMethod(
                    Icons.language,
                    'Website',
                    'www.zenithsprint.com/support',
                  ),
                  _buildContactMethod(
                    Icons.chat_bubble_outline,
                    'Live Chat',
                    'Weekdays 9:00-18:00',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackTypeChips() {
    final types = [
      'Feature Suggestion',
      'Bug Report',
      'User Experience',
      'Other'
    ];
    return Wrap(
      spacing: AppValues.margin_small,
      children: types
          .map((type) => FilterChip(
                label: Text(type),
                selected: _selectedFeedbackType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedFeedbackType = selected ? type : '';
                  });
                },
                selectedColor: AppColors.accent.withOpacity(0.2),
                checkmarkColor: AppColors.accent,
              ))
          .toList(),
    );
  }

  Widget _buildContactMethod(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.margin),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppValues.padding_small),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppValues.radius_small),
            ),
            child: Icon(
              icon,
              color: AppColors.accent,
              size: AppValues.icon_medium,
            ),
          ),
          const SizedBox(width: AppValues.margin),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.neutralDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.radius),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.accent,
                size: AppValues.icon_large,
              ),
              const SizedBox(width: AppValues.margin),
              const Text('Submission Successful'),
            ],
          ),
          content: const Text(
            'Thank you for your feedback! We will carefully consider your suggestions and contact you if necessary.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to settings
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
