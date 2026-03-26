import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bottom_nav_bar.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/diagnosis/diagnosis_screen.dart';
import '../../features/titration/titration_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/pages/about_page.dart';
import '../../features/settings/pages/feedback_page.dart';
import '../../features/settings/pages/simple_content_page.dart';
import '../../features/splash/splash_page.dart';
import '../../features/splash/eula_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  //dasdasdasdasdggf
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/eula', builder: (context, state) => const EulaPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/gallery',
                builder: (context, state) => const GalleryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/diagnosis',
                builder: (context, state) => const DiagnosisScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/titration',
                builder: (context, state) => const TitrationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'manual',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SimpleContentPage(
                      title: 'App Manual',
                      content:
                          '## 1. Dashboard\n'
                          'The central hub of Glim. Monitor critical water parameters like pH, temperature, and TDS in real-time. Use the "Run Weekly Maintenance" button to log routine care.\n\n'
                          '## 2. Gallery\n'
                          'Explore world-class aquascapes. Tap any image to view details like tank size, lighting, and plant list. Use the "Clone Ecosystem" feature to import settings to your own tank profile.\n\n'
                          '## 3. Diagnosis (AI Botanist)\n'
                          'Identify plant deficiencies and diseases instantly. Tap the camera icon to take a photo of your aquatic plants. The AI will analyze the image and suggest treatments.\n\n'
                          '## 4. Titration Engine\n'
                          'Calculate precise fertilizer doses. Input your tank dimensions, hardscape volume, and plant density. The engine generates a custom dosing schedule for major brands (ADA, Seachem, Tropica).',
                    ),
                  ),
                  GoRoute(
                    path: 'feedback',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const FeedbackPage(),
                  ),
                  GoRoute(
                    path: 'contact',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SimpleContentPage(
                      title: 'Contact Us',
                      content:
                          '## Get in Touch\n\n'
                          'We love hearing from our community of aquascapers. Whether you have a feature request, a bug report, or just want to share your tank, reach out!\n\n'
                          '**Email Support:**\n'
                          'support@abyssos.app\n\n'
                          '**Official Website:**\n'
                          'www.abyssos.app\n\n'
                          '**Business Inquiries:**\n'
                          'business@abyssos.app\n\n'
                          'We typically respond within 24 hours on business days.',
                    ),
                  ),
                  GoRoute(
                    path: 'about',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AboutPage(),
                  ),
                  GoRoute(
                    path: 'statement',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SimpleContentPage(
                      title: 'Special Statement',
                      content:
                          '## Disclaimer\n\n'
                          'Glim provides tools and AI-based advice for informational purposes only. While we strive for accuracy, aquariums are complex biological systems.\n\n'
                          '1. **Not a Substitute for Professional Advice**: AI diagnosis should be used as a reference, not a definitive medical prescription for livestock.\n'
                          '2. **User Responsibility**: Always verify critical water parameters (like CO2 and Ammonia) with calibrated physical test kits.\n'
                          '3. **Liability**: Glim and its developers are not liable for any loss of livestock (fish, shrimp, plants) or equipment damage resulting from the use of this app.',
                    ),
                  ),
                  GoRoute(
                    path: 'privacy',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SimpleContentPage(
                      title: 'Privacy & Security',
                      content:
                          '## Privacy Policy\n\n'
                          '**Last Updated: March 2026**\n\n'
                          '1. **Local First**: We believe your data belongs to you. Tank profiles, water logs, and journals are stored locally on your device.\n\n'
                          '2. **Data Transmission**: Internet access is required only for:\n'
                          '   - Fetching global gallery images.\n'
                          '   - AI Diagnosis (sending images to analysis server).\n\n'
                          '3. **No Account Required**: You do not need to create an account or provide personal email to use the core features of Glim.\n\n'
                          '4. **Third-Party Services**: We use Volcengine for AI image processing. See "AI Permissions" for details.',
                    ),
                  ),
                  GoRoute(
                    path: 'agreement',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SimpleContentPage(
                      title: 'User Agreement',
                      content:
                          '## Terms of Service\n\n'
                          'By downloading and using Glim, you agree to the following terms:\n\n'
                          '1. **License**: We grant you a limited, non-exclusive, non-transferable license to use the app for personal, non-commercial purposes.\n\n'
                          '2. **Content**: You retain ownership of photos you take, but you grant us a license to process them for AI diagnosis if you use that feature.\n\n'
                          '3. **Prohibited Use**: You may not reverse engineer, decompile, or attempt to extract the source code of the app.\n\n'
                          '4. **Termination**: We reserve the right to terminate access to online features if these terms are violated.',
                    ),
                  ),
                  GoRoute(
                    path: 'ai-permissions',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SimpleContentPage(
                      title: 'AI Permissions',
                      content:
                          '## AI Service Declaration\n\n'
                          '**1. Which AI service does your app use?**\n'
                          'This app uses the "Doubao" large language model provided by **Volcengine (ByteDance)** for image analysis and plant health diagnosis.\n\n'
                          '**2. Does your app share data with third-party AI services?**\n'
                          '**Yes.** When you use the "AI Diagnosis" feature, the image you select is uploaded to Volcengine\'s servers for processing.\n\n'
                          '**3. Explanation of Data Sharing**\n'
                          'The data sharing is strictly limited to the image you actively select for diagnosis. The image is processed solely to generate the diagnosis result. We do not share your location, contacts, or other personal data with the AI provider.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
