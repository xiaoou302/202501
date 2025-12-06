import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'Bug Report';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Hide keyboard
      FocusScope.of(context).unfocus();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thank you for your feedback!'),
          backgroundColor: AppColors.jadeGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedType = 'Bug Report';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.inkGreen,
        appBar: AppBar(
          backgroundColor: AppColors.sandalwood,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.antiqueGold),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Report a Bug',
            style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FEEDBACK TYPE',
                  style: TextStyle(
                    color: AppColors.antiqueGold.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.sandalwood.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.2)),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    dropdownColor: AppColors.sandalwood,
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14),
                    items: ['Bug Report', 'Feature Request', 'General Feedback']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'TITLE',
                  style: TextStyle(
                    color: AppColors.antiqueGold.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.sandalwood.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.2)),
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    maxLength: 50,
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Brief summary of the issue',
                      hintStyle: TextStyle(color: AppColors.ivory, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      counterStyle: TextStyle(color: AppColors.antiqueGold, fontSize: 11),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.trim().length < 5) {
                        return 'Title must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    color: AppColors.antiqueGold.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.sandalwood.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.antiqueGold.withValues(alpha: 0.2)),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLength: 500,
                    maxLines: 8,
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Describe the issue in detail...',
                      hintStyle: TextStyle(color: AppColors.ivory, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      counterStyle: TextStyle(color: AppColors.antiqueGold, fontSize: 11),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.trim().length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.antiqueGold,
                      foregroundColor: AppColors.inkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT FEEDBACK',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
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
