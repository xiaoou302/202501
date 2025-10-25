import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Feedback screen - Bug reports and suggestions
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _feedbackType = 'Bug Report';

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thank you for your feedback!'),
          backgroundColor: AppColors.arcaneGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Clear form
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      setState(() {
        _feedbackType = 'Bug Report';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // Dismiss keyboard when tapping outside
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.parchmentGradient,
            ),
            image: DecorationImage(
              image: NetworkImage(
                'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
              ),
              repeat: ImageRepeat.repeat,
              opacity: 0.03,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.parchmentLight,
                              AppColors.parchmentMedium.withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.borderMedium,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntro(),
                            const SizedBox(height: 24),
                            _buildFeedbackTypeSelector(),
                            const SizedBox(height: 20),
                            _buildEmailField(),
                            const SizedBox(height: 16),
                            _buildSubjectField(),
                            const SizedBox(height: 16),
                            _buildMessageField(),
                            const SizedBox(height: 24),
                            _buildSubmitButton(),
                          ],
                        ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.parchmentDark.withOpacity(0.3),
            AppColors.parchmentMedium.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMedium, width: 2),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.inkBlack.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              iconSize: 20,
              onPressed: () => Navigator.pop(context),
              color: AppColors.inkBrown,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send Feedback',
                  style: TextStyle(
                    color: AppColors.inkBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Help us improve',
                  style: TextStyle(
                    color: AppColors.inkFaded,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.bug_report_rounded, color: AppColors.glowAmber, size: 28),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glowAmber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.glowAmber.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.feedback_rounded, color: AppColors.glowAmber, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'We value your feedback! Report bugs or share suggestions to help us improve.',
              style: TextStyle(
                color: AppColors.inkBrown,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback Type',
          style: TextStyle(
            color: AppColors.inkBlack,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: ['Bug Report', 'Suggestion', 'Question', 'Other'].map((
            type,
          ) {
            final isSelected = _feedbackType == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _feedbackType = type;
                });
              },
              selectedColor: AppColors.glowAmber.withOpacity(0.3),
              backgroundColor: AppColors.parchmentDark.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.inkBlack : AppColors.inkFaded,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email (Optional)',
          style: TextStyle(
            color: AppColors.inkBlack,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'your.email@example.com',
            filled: true,
            fillColor: AppColors.parchmentDark.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderMedium),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glowAmber, width: 2),
            ),
            counterText: '',
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubjectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject *',
          style: TextStyle(
            color: AppColors.inkBlack,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _subjectController,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'Brief summary of your feedback',
            filled: true,
            fillColor: AppColors.parchmentDark.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderMedium),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glowAmber, width: 2),
            ),
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Subject is required';
            }
            if (value.trim().length < 5) {
              return 'Subject must be at least 5 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message *',
          style: TextStyle(
            color: AppColors.inkBlack,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _messageController,
          maxLength: 500,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Describe your feedback in detail...',
            filled: true,
            fillColor: AppColors.parchmentDark.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderMedium),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glowAmber, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Message is required';
            }
            if (value.trim().length < 10) {
              return 'Message must be at least 10 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.goldGradient),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.magicGold.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _submitFeedback,
        icon: const Icon(Icons.send_rounded, size: 22),
        label: const Text(
          'Submit Feedback',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
