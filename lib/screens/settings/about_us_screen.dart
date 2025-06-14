import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                _buildHeader(context),
                const SizedBox(height: 24),

                // Content
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Logo
                      _buildLogo(),
                      const SizedBox(height: 32),

                      // About us text
                      _buildAboutUsSection(),
                      const SizedBox(height: 32),

                      // Mission
                      _buildMissionSection(),
                      const SizedBox(height: 32),

                      // Team
                      _buildTeamSection(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build header with back button
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        const Text(
          "About Us",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Build logo section
  Widget _buildLogo() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.hologramPurple.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "L",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Luxanvoryx",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Version 1.0.0",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Build about us section
  Widget _buildAboutUsSection() {
    return _buildContentCard(
      title: "Our Story",
      icon: FontAwesomeIcons.bookOpen,
      iconColor: const Color(0xFF4FC3F7),
      content:
          "Luxanvoryx was founded in 2023 with a vision to create beautifully designed, multi-functional applications that enhance everyday life. Our team of passionate developers and designers work together to create tools that are both aesthetically pleasing and highly functional.\n\nWe believe that technology should be both beautiful and useful, and we strive to create applications that embody this philosophy. Our flagship app combines several useful tools including a caffeine tracker, coupon manager, and color generator in one sleek package.",
    );
  }

  // Build mission section
  Widget _buildMissionSection() {
    return _buildContentCard(
      title: "Our Mission",
      icon: FontAwesomeIcons.rocket,
      iconColor: const Color(0xFFBA68C8),
      content:
          "At Luxanvoryx, our mission is to create innovative digital tools that simplify everyday tasks while providing a delightful user experience. We are committed to:\n\n• Designing intuitive interfaces that are easy to use\n• Developing features that solve real-world problems\n• Continuously improving our products based on user feedback\n• Maintaining the highest standards of quality and reliability",
    );
  }

  // Build team section
  Widget _buildTeamSection() {
    return _buildContentCard(
      title: "Our Team",
      icon: FontAwesomeIcons.users,
      iconColor: const Color(0xFF66BB6A),
      content:
          "Luxanvoryx is powered by a diverse team of talented individuals who are passionate about creating exceptional digital experiences. Our team includes:\n\n• Experienced developers with expertise in Flutter and mobile app development\n• Creative designers who specialize in creating beautiful and functional interfaces\n• Product managers who ensure our applications meet user needs\n• Quality assurance specialists who maintain our high standards",
    );
  }

  // Build content card
  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Container(
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withOpacity(0.7),
                      iconColor.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content text
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
