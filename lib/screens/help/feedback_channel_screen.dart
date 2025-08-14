import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Feedback Channel screen for users to submit feedback
class FeedbackChannelScreen extends StatefulWidget {
  const FeedbackChannelScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackChannelScreen> createState() => _FeedbackChannelScreenState();
}

class _FeedbackChannelScreenState extends State<FeedbackChannelScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedFeedbackType = 'Feature Request';
  bool _isSubmitting = false;

  final List<String> _feedbackTypes = [
    'Feature Request',
    'Bug Report',
    'General Feedback',
    'UI/UX Suggestion',
    'Performance Issue',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside input fields
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBackground,
          elevation: 0,
          title: const Text(
            'Feedback Channel',
            style: TextStyle(color: AppTheme.primaryText),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeedbackHeader(),
                const SizedBox(height: 24),
                _buildFeedbackForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build feedback header with illustration
  Widget _buildFeedbackHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.feedback_outlined,
              color: Color(0xFF2196F3),
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'We Value Your Feedback',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Your suggestions help us improve Virelia and make it better for everyone.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// Build the feedback form
  Widget _buildFeedbackForm() {
    return Card(
      color: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feedback type dropdown
            const Text(
              'Feedback Type',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFeedbackType,
                  isExpanded: true,
                  dropdownColor: AppTheme.primaryBackground,
                  style: const TextStyle(color: AppTheme.primaryText),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppTheme.secondaryText,
                  ),
                  items: _feedbackTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFeedbackType = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Feedback text field
            const Text(
              'Your Feedback',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              maxLength: 500, // Limit feedback to 500 characters
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization:
                  TextCapitalization.sentences, // Start with capital letter
              decoration: InputDecoration(
                hintText: 'Tell us what you think...',
                hintStyle: const TextStyle(color: AppTheme.secondaryText),
                filled: true,
                fillColor: AppTheme.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
                counterStyle: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
              style: const TextStyle(color: AppTheme.primaryText),
              textInputAction:
                  TextInputAction.next, // Move to next field on done
            ),
            const SizedBox(height: 16),

            // Email field
            const Text(
              'Your Email (optional)',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              maxLength: 100, // Reasonable limit for email addresses
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              autocorrect: false, // Disable autocorrect for email
              enableSuggestions: false, // Disable suggestions for email
              decoration: InputDecoration(
                hintText: 'email@example.com',
                hintStyle: const TextStyle(color: AppTheme.secondaryText),
                filled: true,
                fillColor: AppTheme.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
                counterStyle: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
                // Add email validation
                errorText: _validateEmail(_emailController.text),
              ),
              style: const TextStyle(color: AppTheme.primaryText),
              textInputAction: TextInputAction.done, // Close keyboard on done
              onChanged: (value) {
                // Trigger validation on change
                setState(() {});
              },
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppTheme.brandBlue.withOpacity(0.5),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Validate email format
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      // Email is optional, so empty is fine
      return null;
    }

    // Simple email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Submit feedback (simulated)
  void _submitFeedback() {
    // Validate feedback
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your feedback'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    // Validate email if provided
    if (_emailController.text.isNotEmpty &&
        _validateEmail(_emailController.text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      // Clear form
      _feedbackController.clear();
      _emailController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      // Provide haptic feedback
      HapticFeedback.mediumImpact();

      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
    });
  }
}
