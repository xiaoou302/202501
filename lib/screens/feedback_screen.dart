import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _feedbackFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  String _selectedCategory = 'Feature Request';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Feature Request',
    'Bug Report',
    'User Experience',
    'Performance Issue',
    'Other',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    _feedbackFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    if (email.isEmpty) return true; // 允许为空
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // 收起键盘
    FocusScope.of(context).unfocus();

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Submit Feedback'),
          backgroundColor: AppTheme.surfaceColor,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help Us Improve',
                  style: AppTheme.headingStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Your feedback helps us create a better experience for everyone.',
                  style: TextStyle(
                    color: AppTheme.textColor.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Category',
                  style: AppTheme.subheadingStyle,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.darkGradient,
                    borderRadius: AppTheme.borderRadius,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      dropdownColor: AppTheme.surfaceColor,
                      style: TextStyle(color: AppTheme.textColor),
                      icon: Icon(Icons.arrow_drop_down, color: AppTheme.textColor),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Your Feedback',
                  style: AppTheme.subheadingStyle,
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.darkGradient,
                    borderRadius: AppTheme.borderRadius,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: TextFormField(
                    controller: _feedbackController,
                    focusNode: _feedbackFocusNode,
                    maxLines: 5,
                    maxLength: 500,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: AppTheme.textColor),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your feedback';
                      }
                      if (value.trim().length < 10) {
                        return 'Feedback should be at least 10 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...',
                      hintStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.5)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      counterStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.7)),
                      errorStyle: TextStyle(color: AppTheme.accentRed),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Email (Optional)',
                  style: AppTheme.subheadingStyle,
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.darkGradient,
                    borderRadius: AppTheme.borderRadius,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: AppTheme.textColor),
                    maxLength: 100,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    validator: (value) {
                      if (value != null && value.isNotEmpty && !_isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'For follow-up questions',
                      hintStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.5)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      counterText: '',
                      errorStyle: TextStyle(color: AppTheme.accentRed),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.buttonRadius,
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Submit Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 