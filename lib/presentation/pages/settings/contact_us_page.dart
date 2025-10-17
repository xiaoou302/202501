import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Contact us page
class ContactUsPage extends StatefulWidget {
  /// Constructor
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedSubject = 'General Inquiry';
  bool _isSubmitting = false;

  final List<String> _subjects = [
    'General Inquiry',
    'Feedback',
    'Business Cooperation',
    'Technical Support',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
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
            'Contact Us',
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
              image: AssetImage('assets/8.jpg'),
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
                        _buildContactForm(),
                        const SizedBox(height: 20),
                        _buildContactInfoCard(),
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
                  color: AppColors.carvedJadeGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: AppColors.carvedJadeGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'d love to hear from you! Send us a message and we\'ll respond as soon as possible.',
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

  Widget _buildContactForm() {
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
                _buildFormLabel('Your Name'),
                const SizedBox(height: 8),
                _buildNameField(),
                const SizedBox(height: 16),
                _buildFormLabel('Your Email'),
                const SizedBox(height: 8),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildFormLabel('Subject'),
                const SizedBox(height: 8),
                _buildSubjectDropdown(),
                const SizedBox(height: 16),
                _buildFormLabel('Message'),
                const SizedBox(height: 8),
                _buildMessageField(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoCard() {
    final contactMethods = [
      ContactMethod(
        icon: Icons.email,
        title: 'Email',
        detail: 'support@Jongaragame.com',
        color: Colors.blue,
      ),
      ContactMethod(
        icon: Icons.language,
        title: 'Website',
        detail: 'www.Jongaragame.com',
        color: Colors.green,
      ),
      ContactMethod(
        icon: Icons.location_on,
        title: 'Address',
        detail: '123 Game Street, App City, 10001',
        color: Colors.red,
      ),
    ];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Other Ways to Reach Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...contactMethods.map((method) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: method.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(method.icon, color: method.color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            method.detail,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Enter your name',
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
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your name';
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
        hintText: 'Enter your email',
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
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        // Simple email validation
        final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildSubjectDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSubject,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          isExpanded: true,
          dropdownColor: Colors.black.withOpacity(0.8),
          style: const TextStyle(color: Colors.white),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSubject = newValue;
              });
            }
          },
          items: _subjects.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      maxLines: 5,
      maxLength: 500,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Type your message here...',
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
          return 'Please enter your message';
        }
        if (value.trim().length < 10) {
          return 'Message is too short';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.carvedJadeGreen,
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
                'SEND MESSAGE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }

  void _submitForm() {
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
                Text('Message Sent!', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: Text(
              'Thank you for contacting us. We will get back to you as soon as possible.',
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

/// Contact method model
class ContactMethod {
  /// Icon data
  final IconData icon;

  /// Title text
  final String title;

  /// Detail text
  final String detail;

  /// Icon color
  final Color color;

  /// Constructor
  const ContactMethod({
    required this.icon,
    required this.title,
    required this.detail,
    required this.color,
  });
}
