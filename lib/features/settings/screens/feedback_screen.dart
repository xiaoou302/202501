import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General',
    'Bug Report',
    'Feature Request',
    'User Experience',
    'Performance',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: AppConstants.softCoral,
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDark
            ? AppConstants.deepPlum
            : AppConstants.shellWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Experience Feedback'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingL),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppConstants.darkGray
                          : AppConstants.panelWhite,
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.feedback,
                          size: 64,
                          color: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: AppConstants.spacingM),
                        Text(
                          'We Value Your Opinion',
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        Text(
                          'Help us improve Leno by sharing your thoughts and suggestions.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppConstants.mediumGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Name Field
                  Text('Name', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppConstants.spacingS),
                  TextFormField(
                    controller: _nameController,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      filled: true,
                      fillColor: isDark
                          ? AppConstants.darkGray
                          : AppConstants.panelWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingM),

                  // Email Field
                  Text('Email', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppConstants.spacingS),
                  TextFormField(
                    controller: _emailController,
                    maxLength: 100,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      filled: true,
                      fillColor: isDark
                          ? AppConstants.darkGray
                          : AppConstants.panelWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingM),

                  // Category Dropdown
                  Text('Category', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppConstants.spacingS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingM,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppConstants.darkGray
                          : AppConstants.panelWhite,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),

                  // Feedback Field
                  Text('Your Feedback', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppConstants.spacingS),
                  TextFormField(
                    controller: _feedbackController,
                    maxLength: 1000,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts with us...',
                      filled: true,
                      fillColor: isDark
                          ? AppConstants.darkGray
                          : AppConstants.panelWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your feedback';
                      }
                      if (value.trim().length < 10) {
                        return 'Feedback must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingXL),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.softCoral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Submit Feedback',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
