import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';

/// Feedback screen with input field
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _feedbackFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    _feedbackFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  // Submit feedback
  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      _showSnackBar('Please enter your feedback');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    _showSnackBar('Thank you for your feedback!');
    _feedbackController.clear();
    _emailController.clear();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.champagne,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside of text fields
      onTap: () {
        _feedbackFocus.unfocus();
        _emailFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.deepSpace,
        appBar: AppBar(
          backgroundColor: AppTheme.deepSpace,
          title: const Text(
            'Feedback',
            style: TextStyle(
              color: AppTheme.moonlight,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.champagne),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro text
              Animations.fadeSlideIn(
                child: const Text(
                  'We value your feedback',
                  style: TextStyle(
                    color: AppTheme.moonlight,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Animations.fadeSlideIn(
                delay: 100,
                child: const Text(
                  'Your thoughts help us improve Soli. Please share your experience, suggestions, or report any issues you\'ve encountered.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),

              // Feedback form
              Animations.fadeSlideIn(
                delay: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Feedback',
                      style: TextStyle(
                        color: AppTheme.champagne,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.silverstone,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _feedbackController,
                        focusNode: _feedbackFocus,
                        style: const TextStyle(color: AppTheme.moonlight),
                        maxLines: 6,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          hintText: 'Enter your feedback here...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          counterStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Email field
              Animations.fadeSlideIn(
                delay: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Email (Optional)',
                      style: TextStyle(
                        color: AppTheme.champagne,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.silverstone,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        style: const TextStyle(color: AppTheme.moonlight),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'email@example.com',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We\'ll only use this to follow up on your feedback if needed',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Submit button
              Animations.fadeSlideIn(
                delay: 400,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.champagne,
                      foregroundColor: AppTheme.deepSpace,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.deepSpace,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
