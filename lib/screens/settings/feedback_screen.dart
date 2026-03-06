import 'package:flutter/material.dart';
import '../../theme/color_palette.dart';
import '../../theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your feedback"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Thank you! Your feedback has been sent."),
        backgroundColor: ColorPalette.extractionGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorPalette.concrete,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: ColorPalette.obsidian,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "FEEDBACK",
            style: AppTheme.monoStyle.copyWith(
              color: ColorPalette.obsidian,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                "SHARE YOUR THOUGHTS",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColorPalette.obsidian,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Found a bug? Have a feature request? Let us know.",
                style: TextStyle(color: ColorPalette.matteSteel, fontSize: 15),
              ),
              const SizedBox(height: 40),

              // Email Input
              Text(
                "EMAIL (OPTIONAL)",
                style: AppTheme.monoStyle.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.matteSteel,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "name@example.com",
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: ColorPalette.matteSteel,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: ColorPalette.obsidian),
                ),
              ),
              const SizedBox(height: 32),

              // Feedback Input
              Text(
                "MESSAGE",
                style: AppTheme.monoStyle.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.matteSteel,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _feedbackController,
                  maxLines: 8,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: "Describe your experience or suggestion here...",
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                    counterText: "", // Hide default counter
                  ),
                  style: const TextStyle(
                    color: ColorPalette.obsidian,
                    height: 1.5,
                  ),
                  buildCounter:
                      (
                        context, {
                        required currentLength,
                        required isFocused,
                        required maxLength,
                      }) {
                        return Container(
                          padding: const EdgeInsets.only(right: 16, bottom: 16),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "$currentLength / $maxLength",
                            style: AppTheme.monoStyle.copyWith(
                              fontSize: 10,
                              color: ColorPalette.matteSteel.withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.obsidian,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    shadowColor: ColorPalette.obsidian.withOpacity(0.3),
                  ),
                  child: Text(
                    "SEND FEEDBACK",
                    style: AppTheme.monoStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 14,
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
