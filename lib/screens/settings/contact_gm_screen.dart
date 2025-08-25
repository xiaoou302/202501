import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/cyber_button.dart';

/// Contact GM Screen
/// Allows players to send messages to game administrators
class ContactGMScreen extends StatefulWidget {
  const ContactGMScreen({Key? key}) : super(key: key);

  @override
  State<ContactGMScreen> createState() => _ContactGMScreenState();
}

class _ContactGMScreenState extends State<ContactGMScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'Technical Issue';
  bool _isSubmitting = false;
  bool _showSuccessMessage = false;

  final List<String> _categories = [
    'Technical Issue',
    'Account Problem',
    'Gameplay Question',
    'Bug Report',
    'Feature Request',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Submit the form
  Future<void> _submitForm() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      setState(() {
        _isSubmitting = false;
        _showSuccessMessage = true;
      });

      // Reset form after delay
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _showSuccessMessage = false;
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();
          _selectedCategory = 'Technical Issue';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Contact GM'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(
          context,
        ).unfocus(), // Hide keyboard when tapping outside
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orangeAccent.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.contact_support,
                        color: Colors.orangeAccent,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'CONTACT GAME MASTER',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'re here to help with any issues or questions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Contact Form
              if (_showSuccessMessage)
                _buildSuccessMessage()
              else
                _buildContactForm(),

              const SizedBox(height: 32),

              // Response Time Info
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: Colors.blueAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'RESPONSE TIME',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Our Game Masters typically respond within 24-48 hours. For urgent issues, please include "URGENT" in your subject line.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Build success message widget
  Widget _buildSuccessMessage() {
    return GlassCard(
      isGlowing: true,
      glowColor: Colors.greenAccent,
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Message Sent Successfully!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thank you for contacting us. A Game Master will respond to your inquiry as soon as possible.',
            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CyberButton(
            text: 'Send Another Message',
            onPressed: () {
              setState(() {
                _showSuccessMessage = false;
              });
            },
            backgroundColor: Colors.transparent,
            textColor: Colors.greenAccent,
            borderColor: Colors.greenAccent.withOpacity(0.5),
            height: 48,
          ),
        ],
      ),
    );
  }

  // Build contact form widget
  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONTACT FORM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: _buildInputDecoration(
                'Your Name',
                'Enter your in-game name',
                Icons.person,
              ),
              style: const TextStyle(color: AppColors.textColor),
              maxLength: 30,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: _buildInputDecoration(
                'Email Address',
                'Enter your email address',
                Icons.email,
              ),
              style: const TextStyle(color: AppColors.textColor),
              keyboardType: TextInputType.emailAddress,
              maxLength: 50,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _buildInputDecoration(
                'Category',
                'Select a category',
                Icons.category,
              ),
              dropdownColor: AppColors.primaryDark,
              style: const TextStyle(color: AppColors.textColor),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
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
            const SizedBox(height: 16),

            // Subject Field
            TextFormField(
              controller: _subjectController,
              decoration: _buildInputDecoration(
                'Subject',
                'Enter message subject',
                Icons.subject,
              ),
              style: const TextStyle(color: AppColors.textColor),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a subject';
                }
                if (value.trim().length < 5) {
                  return 'Subject must be at least 5 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Message Field
            TextFormField(
              controller: _messageController,
              decoration: _buildInputDecoration(
                'Message',
                'Enter your message (min 20 characters)',
                Icons.message,
              ).copyWith(alignLabelWithHint: true),
              style: const TextStyle(color: AppColors.textColor),
              maxLines: 5,
              maxLength: 500,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your message';
                }
                if (value.trim().length < 20) {
                  return 'Message must be at least 20 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: _isSubmitting
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                      ),
                    )
                  : CyberButton(
                      text: 'SEND MESSAGE',
                      onPressed: _submitForm,
                      backgroundColor: AppColors.primaryAccent,
                      textColor: AppColors.primaryDark,
                      isGlowing: true,
                      height: 56,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build input decoration
  InputDecoration _buildInputDecoration(
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
      prefixIcon: Icon(icon, color: AppColors.primaryAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.8)),
      ),
      filled: true,
      fillColor: AppColors.primaryDark.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
