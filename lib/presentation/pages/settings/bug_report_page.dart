import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Bug report page
class BugReportPage extends StatefulWidget {
  /// Constructor
  const BugReportPage({super.key});

  @override
  State<BugReportPage> createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _bugDescriptionController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedBugType = 'Gameplay Issue';
  bool _isSubmitting = false;

  final List<String> _bugTypes = [
    'Gameplay Issue',
    'Visual Glitch',
    'Performance Problem',
    'App Crash',
    'UI/UX Issue',
    'Other',
  ];

  @override
  void dispose() {
    _bugDescriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Report Bug',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/6.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use constraints to adapt to different screen sizes
                final double contentWidth = constraints.maxWidth > 700
                    ? 700
                    : constraints.maxWidth;
                final double horizontalPadding =
                    (constraints.maxWidth - contentWidth) / 2;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding > 0
                        ? horizontalPadding
                        : 16.0,
                    vertical: 16.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(),
                        const SizedBox(height: 20),
                        _buildBugReportForm(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bug_report,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Found a Bug?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We appreciate your help in improving ${AppConstants.appName}. Please describe the issue in detail so we can fix it as soon as possible.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBugReportForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormLabel('Bug Type'),
                const SizedBox(height: 8),
                _buildDropdown(),
                const SizedBox(height: 16),
                _buildFormLabel('Bug Description'),
                const SizedBox(height: 8),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildFormLabel('Your Email (Optional)'),
                const SizedBox(height: 8),
                _buildEmailField(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBugType,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          isExpanded: true,
          dropdownColor: Colors.black.withOpacity(0.8),
          style: const TextStyle(color: Colors.white),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedBugType = newValue;
              });
            }
          },
          items: _bugTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _bugDescriptionController,
      maxLines: 5,
      maxLength: 500,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Please describe what happened...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.beeswaxAmber),
        ),
        counterStyle: const TextStyle(color: Colors.white70),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please describe the bug';
        }
        if (value.trim().length < 10) {
          return 'Please provide more details';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'your.email@example.com',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.beeswaxAmber),
        ),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          // Simple email validation
          final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
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
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitBugReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'SUBMIT REPORT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }

  void _submitBugReport() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isSubmitting = false;
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text('Thank You!', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: Text(
              'Your bug report has been submitted successfully. We appreciate your help in improving ${AppConstants.appName}!',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppColors.beeswaxAmber),
                ),
              ),
            ],
          ),
        );
      });
    }
  }
}
