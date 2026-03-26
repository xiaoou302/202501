import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../shared/widgets/glass_panel.dart';

class EulaPage extends StatelessWidget {
  const EulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.voidBlack,
                    AppColors.deepTeal.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.starlightWhite,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'EULA & Terms',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: GlassPanel(
                      borderRadius: BorderRadius.circular(24),
                      borderColor: AppColors.toxicityAlert.withValues(
                        alpha: 0.2,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: MarkdownBody(
                          data: _eulaContent,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              color: AppColors.mossMuted,
                              fontSize: 15,
                              height: 1.6,
                            ),
                            h1: const TextStyle(
                              color: AppColors.toxicityAlert,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 2.0,
                            ),
                            h2: const TextStyle(
                              color: AppColors.starlightWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 2.0,
                            ),
                            strong: const TextStyle(
                              color: AppColors.starlightWhite,
                              fontWeight: FontWeight.bold,
                            ),
                            listBullet: const TextStyle(
                              color: AppColors.alienPurple,
                              fontSize: 16,
                            ),
                            blockSpacing: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Agree Button (Bottom Fixed)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.floraNeon,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.floraNeon.withValues(alpha: 0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'I UNDERSTAND & AGREE',
                          style: TextStyle(
                            color: AppColors.voidBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const String _eulaContent = '''
# End User License Agreement (EULA)

**Last Updated: March 2026**

By accessing or using Glim, you agree to be bound by this Agreement. If you do not agree, do not use the Application.

## 1. Zero Tolerance Policy
**Strict Enforcement Against Abuse**

Glim maintains a **Zero Tolerance Policy** regarding objectionable content and abusive behavior. 

*   **Prohibited Content**: Users may not generate, upload, or share content that is defamatory, harassment, hate speech, explicit, or illegal.
*   **Consequences**: Any user found violating this policy will face immediate action, including but not limited to:
    *   **Immediate Removal** of offending content (e.g., gallery posts, comments).
    *   **Permanent Account Ban** and device blocking.
    *   Reporting to relevant authorities if required by law.

We reserve the right to monitor and enforce these rules at our sole discretion to maintain a safe community.

## 2. AI Service Declaration
**Transparency in AI Usage**

*   **Service Provider**: This application utilizes the **Doubao** large language model provided by **Volcengine (ByteDance)** for features such as "AI Diagnosis" and "Aquascape Advisor".
*   **Data Sharing**: 
    *   **Does your app share data with third-party AI services?** **Yes.**
    *   **Explanation**: When you use AI features, the specific image or text you submit is transmitted to Volcengine's servers for processing. This data is used solely to generate the response and is handled in accordance with Volcengine's privacy standards. We do not share your personal identity, contacts, or location with the AI provider.

## 3. User Content & License
You retain ownership of the photos and data you create. However, by using the AI features, you grant Glim and its service providers a limited license to process your content for the purpose of providing the service.

## 4. Disclaimer of Warranty
The Application is provided "AS IS" without warranty of any kind. Glim is not responsible for any damage to your aquarium livestock or equipment resulting from the use of our tools or advice.

## 5. Contact
For reports of abuse or policy violations, please contact us immediately at:
**support@abyssos.app**
''';
}
