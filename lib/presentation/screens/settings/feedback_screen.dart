import 'package:flutter/material.dart';
import 'package:orivet/core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.vellum,
        appBar: AppBar(
          title: Text("Feedback",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 20)),
          backgroundColor: AppColors.vellum,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft,
                color: AppColors.leather),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "How was your experience?",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.leather),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your feedback helps us improve Rue for everyone.",
                style: TextStyle(color: AppColors.soot, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Rating
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating
                            ? FontAwesomeIcons.solidStar
                            : FontAwesomeIcons.star,
                        color: AppColors.brass,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: _subjectController,
                label: "Subject",
                maxLength: 50,
                icon: FontAwesomeIcons.tag,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _messageController,
                label: "Message",
                maxLength: 500,
                maxLines: 6,
                icon: FontAwesomeIcons.pen,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Mock submission
                    if (_subjectController.text.isEmpty ||
                        _messageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill in all fields"),
                            backgroundColor: AppColors.wax),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Feedback submitted. Thank you!"),
                          backgroundColor: AppColors.teal),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.leather,
                    foregroundColor: AppColors.vellum,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("SUBMIT FEEDBACK",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required int maxLength,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.ink),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.soot),
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding:
              const EdgeInsets.only(top: 12, left: 12, right: 8, bottom: 12),
          child: Icon(icon, color: AppColors.leather, size: 18),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.leather, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.leather.withOpacity(0.2)),
        ),
        counterStyle: const TextStyle(color: AppColors.soot),
      ),
    );
  }
}
