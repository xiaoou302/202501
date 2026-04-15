import 'package:flutter/material.dart';
import 'dart:convert';
import '../utils/theme.dart';
import '../main.dart'; // To access global prefs

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Map<String, dynamic>> _profiles = [];
  String? _expandedProfileId;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  // Reload profiles whenever this screen becomes visible again
  @override
  void didUpdateWidget(covariant LibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadProfiles();
  }

  void _loadProfiles() {
    final String? profilesJson = prefs.getString('profiles');
    if (profilesJson != null) {
      List<dynamic> decoded = jsonDecode(profilesJson);
      setState(() {
        _profiles = decoded.map((e) => e as Map<String, dynamic>).toList();
      });
    } else {
      // Empty state
      setState(() {
        _profiles = [];
      });
    }
  }

  void _saveProfiles() {
    prefs.setString('profiles', jsonEncode(_profiles));
  }

  void _deleteProfile(String id) {
    setState(() {
      _profiles.removeWhere((profile) => profile['id'] == id);
    });
    _saveProfiles();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile deleted from archive.',
          style: TextStyle(fontFamily: 'monospace'),
        ),
        backgroundColor: AppTheme.stallRed,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.polarIce,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppTheme.aeroNavy.withValues(alpha: 0.1)),
          ),
          title: Row(
            children: const [
              Icon(Icons.folder_special, color: AppTheme.aeroNavy),
              SizedBox(width: 8),
              Text(
                'Archive Manual',
                style: TextStyle(
                  color: AppTheme.aeroNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoSection(
                  'Interface Introduction',
                  'The Aero Archive is your personal hangar. It persistently stores all the aerodynamic configurations and AI-extracted profiles you have tested in the Wind Tunnel.',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  'Features',
                  '• Permanent Storage: Your data is saved locally on your device.\n• Quick Overview: Each profile card displays the wing type (NACA or AI Mesh), fluid medium (AIR/WATER), and the maximum Lift (N) generated during that test.',
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.black12),
                const SizedBox(height: 16),
                const Text(
                  'How to Operate',
                  style: TextStyle(
                    color: AppTheme.laminarCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoSection(
                  'Saving Data',
                  'To add a new profile here, go to the Wind Tunnel tab, adjust your parameters, and tap the "Save" icon in the top right corner.',
                ),
                const SizedBox(height: 8),
                _buildInfoSection(
                  'Deleting Data',
                  'To remove a profile from your archive, simply swipe left on any profile card to delete it permanently.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'DISMISS',
                style: TextStyle(
                  color: AppTheme.aeroNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.aeroNavy,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            color: AppTheme.aeroNavy.withValues(alpha: 0.8),
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailMetric(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: isHighlight ? AppTheme.laminarCyan : AppTheme.aeroNavy,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(child: CustomPaint(painter: LibraryGridPainter())),

          // Header
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'Aero',
                        style: TextStyle(
                          color: AppTheme.aeroNavy,
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                        ),
                        children: [
                          TextSpan(
                            text: 'Archive',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.laminarCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_profiles.length} PROFILES LOGGED',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                // Info Button
                GestureDetector(
                  onTap: _showInfoDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.laminarCyan.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.laminarCyan.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: AppTheme.aeroNavy,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List or Empty State
          Positioned(
            top: 140,
            bottom: 0,
            left: 0,
            right: 0,
            child: _profiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.aeroNavy.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.dashboard_customize_outlined,
                            size: 72,
                            color: AppTheme.aeroNavy.withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'NO PROFILES LOGGED',
                          style: TextStyle(
                            color: AppTheme.aeroNavy,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Your Aero Archive is currently empty. Head over to the Wind Tunnel to simulate and save your first aerodynamic profile.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.aeroNavy.withValues(alpha: 0.6),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Shortcut to Tunnel
                        OutlinedButton.icon(
                          onPressed: () {
                            // Trigger navigation via parent or simply instruct user
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tap the Wind icon below to enter the Tunnel.',
                                ),
                                backgroundColor: AppTheme.laminarCyan,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.air,
                            color: AppTheme.laminarCyan,
                          ),
                          label: const Text(
                            'GO TO TUNNEL',
                            style: TextStyle(
                              color: AppTheme.aeroNavy,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppTheme.laminarCyan,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100), // Offset slightly upwards
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: _profiles.length,
                    itemBuilder: (context, index) {
                      final profile = _profiles[index];
                      final profileId = profile['id'] ?? index.toString();
                      final isActive = profile['is_active'] ?? false;
                      final isCustom = profile['is_custom'] ?? false;
                      final fluidType = profile['fluid'] ?? 'AIR';
                      final isExpanded = _expandedProfileId == profileId;

                      return Dismissible(
                        key: Key(profileId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteProfile(profileId);
                        },
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: AppTheme.stallRed.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.delete_sweep,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedProfileId = null;
                              } else {
                                _expandedProfileId = profileId;
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isActive || isExpanded
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isActive || isExpanded
                                    ? AppTheme.laminarCyan.withValues(
                                        alpha: 0.5,
                                      )
                                    : Colors.white,
                              ),
                              boxShadow: isActive || isExpanded
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.aeroNavy.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              children: [
                                // Basic Row (Always visible)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            if (isActive) ...[
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: AppTheme.laminarCyan,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                            Text(
                                              profile['name'] ??
                                                  'Unknown Profile',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: isActive || isExpanded
                                                    ? AppTheme.aeroNavy
                                                    : Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: fluidType == 'AIR'
                                                    ? AppTheme.laminarCyan
                                                          .withValues(
                                                            alpha: 0.2,
                                                          )
                                                    : AppTheme.aeroNavy
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                fluidType,
                                                style: TextStyle(
                                                  color: fluidType == 'AIR'
                                                      ? AppTheme.laminarCyan
                                                      : AppTheme.aeroNavy,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (isCustom)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppTheme
                                                      .turbulenceMagenta
                                                      .withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  'AI MESH',
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .turbulenceMagenta,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'LIFT (N)',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          profile['lift_n']?.toString() ?? '--',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'monospace',
                                            color: isActive || isExpanded
                                                ? AppTheme.turbulenceMagenta
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Expanded Details Section
                                if (isExpanded) ...[
                                  const SizedBox(height: 16),
                                  const Divider(color: Colors.black12),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDetailMetric(
                                        'AoA',
                                        '${(profile['aoa'] ?? 0.0).toStringAsFixed(1)}°',
                                      ),
                                      _buildDetailMetric(
                                        'VELOCITY',
                                        '${(profile['velocity'] ?? 0.0).toStringAsFixed(1)}m/s',
                                      ),
                                      _buildDetailMetric(
                                        'CHORD',
                                        '${(profile['chord'] ?? 0.0).toStringAsFixed(2)}m',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDetailMetric(
                                        'L/D RATIO',
                                        profile['max_ld']?.toString() ?? '--',
                                        isHighlight: true,
                                      ),
                                      _buildDetailMetric(
                                        'Cl (LIFT COEF)',
                                        profile['cl']?.toString() ?? '--',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'SAVED: ${profile['timestamp'] != null ? DateTime.parse(profile['timestamp']).toLocal().toString().split('.')[0] : 'Unknown'}',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class LibraryGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.aeroNavy.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
