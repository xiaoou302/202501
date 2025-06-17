import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../shared/widgets/app_card.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedCategory = 'Feature Suggestion';
  int _selectedRating = 4;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Feature Suggestion',
    'Bug Report',
    'Experience Improvement',
    'Other'
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));

      // Show success dialog
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Feedback Submitted',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thank you for your valuable feedback! We will carefully consider your suggestions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Return'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of input fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feedback'),
          centerTitle: true,
        ),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    // Use MediaQuery to get screen size for responsive adjustments
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = screenSize.width < 360 ? 12.0 : 16.0;

    return ListView(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildFeedbackForm(),
        // Add bottom padding for small screens to ensure form is fully visible when keyboard is open
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader() {
    // Make header size responsive based on screen size
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width < 360 ? 90.0 : 120.0;
    final iconInnerSize = screenSize.width < 360 ? 45.0 : 60.0;
    final titleSize = screenSize.width < 360 ? 24.0 : 28.0;

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppTheme.accentPurple, AppTheme.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentPurple.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.feedback,
              size: iconInnerSize,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Feedback',
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your feedback helps us improve',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeedbackForm() {
    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Feedback Type', Icons.category, Colors.purple),
            const SizedBox(height: 12),
            _buildCategorySelector(),
            const SizedBox(height: 20),
            _buildSectionTitle('App Rating', Icons.star, Colors.amber),
            const SizedBox(height: 12),
            _buildRatingSelector(),
            const SizedBox(height: 20),
            _buildSectionTitle('Feedback Content', Icons.edit, Colors.blue),
            const SizedBox(height: 12),
            _buildFeedbackInput(),
            const SizedBox(height: 20),
            _buildSectionTitle(
                'Contact Information (Optional)', Icons.email, Colors.green),
            const SizedBox(height: 12),
            _buildEmailInput(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    // Adjust icon and text size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 360 ? 18.0 : 24.0;
    final fontSize = screenWidth < 360 ? 16.0 : 18.0;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth < 360 ? 6 : 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: iconSize,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.darkBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.deepPurple.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          dropdownColor: AppTheme.darkBlue,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
          items: _categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRatingSelector() {
    // Make star size responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final starSize = screenWidth < 360 ? 28.0 : 36.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final rating = index + 1;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedRating = rating;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                rating <= _selectedRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: starSize,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeedbackInput() {
    return TextFormField(
      controller: _feedbackController,
      maxLines: 4, // Reduce lines on small screens
      maxLength: 500, // Limit to 500 characters
      decoration: InputDecoration(
        hintText: 'Please describe your issue or suggestion in detail...',
        filled: true,
        fillColor: AppTheme.darkBlue.withOpacity(0.3),
        counterText: '', // Hide the default counter
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.deepPurple.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.deepPurple.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.accentPurple,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your feedback';
        }
        if (value.trim().length < 10) {
          return 'Feedback must be at least 10 characters';
        }
        if (value.trim().length > 500) {
          return 'Feedback cannot exceed 500 characters';
        }
        return null;
      },
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      maxLength: 100, // Reasonable email length limit
      decoration: InputDecoration(
        hintText: 'Your email address',
        filled: true,
        fillColor: AppTheme.darkBlue.withOpacity(0.3),
        counterText: '', // Hide the default counter
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.deepPurple.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.deepPurple.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.accentPurple,
          ),
        ),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          // Simple email format validation
          final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegExp.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
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
    );
  }
}
