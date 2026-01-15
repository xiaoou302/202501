import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();
  
  String _selectedType = 'Bug Report';
  final List<String> _feedbackTypes = [
    'Bug Report',
    'Feature Request',
    'General Feedback',
    'Question',
    'Other',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _emailFocus.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _submitFeedback() {
    if (_emailController.text.trim().isEmpty ||
        _subjectController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Here you would send the feedback to your backend
    debugPrint('═══════════════════════════════════════');
    debugPrint('📧 FEEDBACK SUBMITTED');
    debugPrint('Type: $_selectedType');
    debugPrint('Email: ${_emailController.text}');
    debugPrint('Subject: ${_subjectController.text}');
    debugPrint('Message: ${_messageController.text}');
    debugPrint('═══════════════════════════════════════');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppConstants.midnight, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Feedback Sent!',
                    style: TextStyle(
                      color: AppConstants.midnight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Thank you for your feedback. We\'ll review it soon.',
                    style: TextStyle(
                      color: AppConstants.midnight,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppConstants.gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        duration: const Duration(seconds: 3),
      ),
    );

    // Clear form
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
    setState(() {
      _selectedType = 'Bug Report';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: AppConstants.midnight,
        appBar: AppBar(
          backgroundColor: AppConstants.midnight,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppConstants.offwhite),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Feedback',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              color: AppConstants.offwhite,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.feedback,
                      color: Color(0xFF00BCD4),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'We value your feedback and suggestions',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppConstants.offwhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Feedback Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.gold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppConstants.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    dropdownColor: AppConstants.surface,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConstants.offwhite,
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: AppConstants.gold),
                    items: _feedbackTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedType = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.gold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                focusNode: _emailFocus,
                maxLength: 100,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppConstants.offwhite),
                decoration: InputDecoration(
                  hintText: 'your.email@example.com',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: AppConstants.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  counterStyle: const TextStyle(
                    color: AppConstants.metalgray,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Subject',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.gold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _subjectController,
                focusNode: _subjectFocus,
                maxLength: 100,
                style: const TextStyle(color: AppConstants.offwhite),
                decoration: InputDecoration(
                  hintText: 'Brief description of your feedback',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: AppConstants.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  counterStyle: const TextStyle(
                    color: AppConstants.metalgray,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Message',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.gold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                focusNode: _messageFocus,
                maxLength: 500,
                maxLines: 6,
                style: const TextStyle(color: AppConstants.offwhite),
                decoration: InputDecoration(
                  hintText: 'Please provide details about your feedback...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: AppConstants.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  counterStyle: const TextStyle(
                    color: AppConstants.metalgray,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.gold,
                    foregroundColor: AppConstants.midnight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
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
    );
  }
}
