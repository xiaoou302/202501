import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Version information page
class VersionInfoPage extends StatelessWidget {
  /// Constructor
  const VersionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Version Information',
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
            image: AssetImage('assets/6.jpg'),
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
                  horizontal: horizontalPadding > 0 ? horizontalPadding : 16.0,
                  vertical: 16.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVersionHeader(),
                      const SizedBox(height: 24),
                      _buildVersionHistory(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVersionHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.carvedJadeGreen.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.spa, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 3,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current Version: 1.0.0',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Release Date: October 17, 2025',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionHistory() {
    final versionData = [
      VersionData(
        version: '1.0.0',
        date: 'October 17, 2025',
        features: [
          'Initial release with 12 levels across 3 chapters',
          'Core gameplay mechanics implemented',
          'Achievement system',
          'Basic settings and help pages',
        ],
      ),
      VersionData(
        version: '0.9.0 (Beta)',
        date: 'September 15, 2025',
        features: [
          'Closed beta testing phase',
          'Performance optimizations',
          'UI/UX improvements based on user feedback',
          'Bug fixes and stability improvements',
        ],
      ),
      VersionData(
        version: '0.5.0 (Alpha)',
        date: 'August 1, 2025',
        features: [
          'Internal alpha testing',
          'Core gameplay prototype',
          'Basic UI implementation',
          'Initial level designs',
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'Version History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
        ...versionData.map((version) => _buildVersionCard(version)).toList(),
      ],
    );
  }

  Widget _buildVersionCard(VersionData version) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.beeswaxAmber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'v${version.version}',
                        style: const TextStyle(
                          color: AppColors.beeswaxAmber,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      version.date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'What\'s New:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...version.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 2, right: 4),
                          decoration: BoxDecoration(
                            color: AppColors.beeswaxAmber.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: AppColors.beeswaxAmber,
                              size: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              letterSpacing: 0.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 3,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

/// Version data model
class VersionData {
  /// Version number
  final String version;

  /// Release date
  final String date;

  /// List of features/changes
  final List<String> features;

  /// Constructor
  const VersionData({
    required this.version,
    required this.date,
    required this.features,
  });
}
