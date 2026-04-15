import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsFeedbackScreen extends StatelessWidget {
  const SettingsFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.polarIce,
        appBar: AppBar(
          title: const Text(
            'Feedback & Suggestions',
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
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.aeroNavy,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(),
              const SizedBox(height: 24),
              const Text(
                'Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.aeroNavy,
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(),
              const SizedBox(height: 32),
              _buildSubmitButton(context),
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
            color: AppTheme.turbulenceMagenta.withValues(alpha: 0.1),
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
              color: AppTheme.turbulenceMagenta.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.feedback_outlined,
              size: 32,
              color: AppTheme.turbulenceMagenta,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Help Us Improve',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.aeroNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Report bugs, request features, or tell us what you think.',
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

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.aeroNavy.withValues(alpha: 0.05)),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: 'Bug Report',
        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.aeroNavy),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: ['Bug Report', 'Feature Request', 'General Feedback']
            .map(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.aeroNavy,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (_) {},
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      maxLines: 6,
      maxLength: 1000,
      style: const TextStyle(color: AppTheme.aeroNavy),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Describe your feedback in detail...',
        hintStyle: TextStyle(color: AppTheme.aeroNavy.withValues(alpha: 0.3)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.aeroNavy.withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.turbulenceMagenta, width: 2),
        ),
        counterStyle: TextStyle(color: AppTheme.aeroNavy.withValues(alpha: 0.4)),
      ),
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
            color: AppTheme.turbulenceMagenta.withValues(alpha: 0.3),
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
              content: const Text('Feedback Submitted! Thank you.'),
              backgroundColor: AppTheme.aeroNavy,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.turbulenceMagenta,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'SUBMIT FEEDBACK',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
