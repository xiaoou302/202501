import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsContactScreen extends StatelessWidget {
  const SettingsContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.polarIce,
        appBar: AppBar(
          title: const Text(
            'Contact Us',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.aeroNavy),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 32),
              const Text(
                'Send a Message',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.aeroNavy,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Subject',
                hint: 'e.g. Collaboration, Support',
                maxLength: 50,
                icon: Icons.subject,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Message',
                hint: 'Type your message here...',
                maxLength: 500,
                maxLines: 5,
                icon: Icons.message,
              ),
              const SizedBox(height: 24),
              _buildSubmitButton(context),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Follow us on social media',
                  style: TextStyle(
                    color: AppTheme.aeroNavy.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.language, Colors.blue),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.flutter_dash, Colors.lightBlue),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.code, Colors.black87),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.polarIce,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_outline,
              size: 32,
              color: AppTheme.laminarCyan,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get in Touch',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.aeroNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We\'d love to hear from you. Drop us a line anytime!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.aeroNavy.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required int maxLength,
    int maxLines = 1,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.aeroNavy,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          maxLength: maxLength,
          style: const TextStyle(color: AppTheme.aeroNavy),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.aeroNavy.withValues(alpha: 0.3),
            ),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: AppTheme.aeroNavy.withValues(alpha: 0.4))
                : Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Icon(
                      icon,
                      color: AppTheme.aeroNavy.withValues(alpha: 0.4),
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppTheme.aeroNavy.withValues(alpha: 0.05),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppTheme.laminarCyan,
                width: 2,
              ),
            ),
            counterStyle: TextStyle(
              color: AppTheme.aeroNavy.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.laminarCyan.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Message Sent Successfully!'),
              backgroundColor: AppTheme.aeroNavy,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.laminarCyan,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'SEND MESSAGE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
