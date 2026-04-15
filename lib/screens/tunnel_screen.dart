import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import '../utils/theme.dart';
import '../main.dart'; // For prefs
import 'dart:math';

class TunnelScreen extends StatefulWidget {
  final List<Offset> customUpperSurface;
  final List<Offset> customLowerSurface;
  final double initialCamber;

  const TunnelScreen({
    super.key,
    this.customUpperSurface = const [],
    this.customLowerSurface = const [],
    this.initialCamber = 4.0,
  });

  @override
  State<TunnelScreen> createState() => _TunnelScreenState();
}

class _TunnelScreenState extends State<TunnelScreen>
    with SingleTickerProviderStateMixin {
  double _aoa = 8.0;
  double _velocity = 15.0; // Freestream velocity m/s
  late double _camber; // Maximum Camber % (Shape curvature)
  double _chordLength = 1.0; // Added chord length
  bool _isAir = true; // Fluid medium toggle
  late AnimationController _flowController;

  @override
  void initState() {
    super.initState();
    _camber = widget.initialCamber;
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  double get _fluidDensity => _isAir ? 1.225 : 997.0; // kg/m^3

  String get _reynoldsNumber {
    // Mock formula for visual scaling
    double re = (_velocity * 1.0 * 100000);
    return '${(re / 100000).toStringAsFixed(1)} × 10⁵';
  }

  Widget _buildFluidToggle(String title, bool isAirToggle) {
    bool isSelected = _isAir == isAirToggle;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAir = isAirToggle;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.aeroNavy : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
        ),
      ),
    );
  }

  double get _stallAngle {
    // Higher camber stalls slightly earlier
    return max(8.0, 14.0 - (_camber * 0.5));
  }

  double get _cl {
    if (_aoa <= _stallAngle) {
      // Camber adds base lift (Cl at 0 AoA)
      double baseCl = _camber * 0.1;
      return baseCl + (0.1 * _aoa);
    } else {
      return max(0.1, 1.4 - (_aoa - _stallAngle) * 0.2); // Stall
    }
  }

  double get _ld {
    if (_aoa <= _stallAngle) {
      return _cl * 40;
    } else {
      return _cl * 10; // Drastic drop in L/D during stall
    }
  }

  double get _liftForce {
    // Lift = 0.5 * density * V^2 * Area * Cl
    double area = 1.0; // Assume 1m^2 reference area for comparison
    return 0.5 * _fluidDensity * pow(_velocity, 2) * area * _cl;
  }

  bool get _isStalled => _aoa > _stallAngle;

  void _saveCurrentProfile() {
    final String? profilesJson = prefs.getString('profiles');
    List<Map<String, dynamic>> profiles = [];
    if (profilesJson != null) {
      List<dynamic> decoded = jsonDecode(profilesJson);
      profiles = decoded.map((e) => e as Map<String, dynamic>).toList();
    }

    final isCustom = widget.customUpperSurface.isNotEmpty;
    final profileName = isCustom ? 'Custom AI Wing' : 'NACA Parametric';

    // Build the save object
    final newProfile = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': '$profileName - ${_camber.toStringAsFixed(1)}%',
      'timestamp': DateTime.now().toIso8601String(),
      'is_active': false,
      'is_custom': isCustom,
      'max_ld': _ld.toStringAsFixed(1),
      'cl': _cl.toStringAsFixed(3),
      'lift_n': _liftForce.toStringAsFixed(0),
      'aoa': _aoa,
      'velocity': _velocity,
      'chord': _chordLength,
      'camber': _camber,
      'fluid': _isAir ? 'AIR' : 'WATER',
    };

    profiles.insert(0, newProfile);
    prefs.setString('profiles', jsonEncode(profiles));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Configuration saved to Aero Archive.',
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        backgroundColor: AppTheme.laminarCyan,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildTelemetryItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumSliderRow({
    required String label,
    required String value,
    required String unit,
    required double sliderValue,
    required double min,
    required double max,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 2),
                    child: Text(
                      unit,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width < 400 ? 110 : 140,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor,
              inactiveTrackColor: Colors.grey.shade300.withValues(alpha: 0.2),
              thumbColor: activeColor,
              trackHeight: 4,
              overlayColor: activeColor.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: sliderValue,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
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
              Icon(Icons.air, color: AppTheme.laminarCyan),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Wind Tunnel Manual',
                  style: TextStyle(
                    color: AppTheme.aeroNavy,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoSection(
                    'Navier-Stokes Lite',
                    'Welcome to your pocket CFD lab. This simulator uses a 2D potential flow model and Kutta-Joukowski theorem to visualize aerodynamic performance in real-time without the need for complex meshing.',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    'How to Operate',
                    '• Environment: Toggle between AIR and WATER at the top to see how fluid density drastically affects Lift.\n• Sliders: Adjust Angle of Attack (AoA), Velocity, Chord Length, and Camber at the bottom console.\n• Telemetry: Watch the HUD on the right for real-time Lift Coefficient (Cl), Lift Force (N), and Lift-to-Drag Ratio (L/D).',
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 16),
                  const Text(
                    'Physical Phenomena',
                    style: TextStyle(
                      color: AppTheme.turbulenceMagenta,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoSection(
                    'Pressure Mapping',
                    'According to Bernoulli\'s principle, faster flow means lower pressure. The magenta glow on the upper surface represents the low-pressure suction zone (the source of lift).',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoSection(
                    'Stall & Vortex Street',
                    'Push the AoA past the critical limit (typically >12° depending on camber). You will witness boundary layer separation, a sudden drop in lift, and a turbulent von Kármán vortex street in the wake.',
                  ),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    final bgColor = _isStalled
        ? AppTheme.stallRed.withValues(alpha: 0.1)
        : AppTheme.polarIce;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(
            child: CustomPaint(
              painter: TunnelGridPainter(isStalled: _isStalled),
            ),
          ),

          // Top Info Bar
          Positioned(
            top: 60,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Info Button
                GestureDetector(
                  onTap: _showInfoDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: AppTheme.aeroNavy,
                      size: 24,
                    ),
                  ),
                ),
                // Premium Fluid Segmented Control
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildFluidToggle('AIR', true),
                      _buildFluidToggle('WATER', false),
                    ],
                  ),
                ),
                // Reynolds Number Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'REYNOLDS #',
                        style: TextStyle(
                          color: AppTheme.aeroNavy.withValues(alpha: 0.6),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        _reynoldsNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          fontFamily: 'monospace',
                          color: AppTheme.aeroNavy,
                        ),
                      ),
                    ],
                  ),
                ),
                // Save Button
                GestureDetector(
                  onTap: _saveCurrentProfile,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.laminarCyan.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.laminarCyan),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.laminarCyan.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.save,
                      color: AppTheme.aeroNavy,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stall Warning
          if (_isStalled)
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.stallRed,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.stallRed.withValues(alpha: 0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'STALL WARNING',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Tunnel Simulation Visualization
          Positioned(
            top: 180,
            bottom: 250,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _flowController,
              builder: (context, child) {
                return CustomPaint(
                  painter: AirfoilSimulationPainter(
                    aoa: _aoa,
                    velocity: _velocity,
                    camber: _camber,
                    isStalled: _isStalled,
                    animationValue: _flowController.value,
                    customUpperSurface: widget.customUpperSurface,
                    customLowerSurface: widget.customLowerSurface,
                  ),
                );
              },
            ),
          ),

          // Telemetry Panel
          Positioned(
            top: MediaQuery.of(context).size.height < 750 ? 110 : 200,
            bottom: MediaQuery.of(context).size.height < 750
                ? 300
                : null, // Prevent overlap with bottom panel on small screens
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 90,
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height < 750
                        ? 12
                        : 24,
                  ), // Reduce vertical padding
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTelemetryItem(
                          'Cl',
                          _cl.toStringAsFixed(3),
                          _isStalled ? AppTheme.stallRed : AppTheme.aeroNavy,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height < 750
                              ? 10
                              : 20,
                        ),
                        _buildTelemetryItem(
                          'LIFT',
                          '${_liftForce.toStringAsFixed(0)}N',
                          _isStalled
                              ? AppTheme.stallRed
                              : AppTheme.turbulenceMagenta,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height < 750
                              ? 10
                              : 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.9),
                                Colors.white.withValues(alpha: 0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.aeroNavy.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'L/D',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _ld.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  color: AppTheme.aeroNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Control Panel
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 400
                        ? 16
                        : 24,
                    vertical: MediaQuery.of(context).size.height < 750
                        ? 12
                        : 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.aeroNavy.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Angle of Attack Slider
                      _buildPremiumSliderRow(
                        label: 'ANGLE OF ATTACK',
                        value: _aoa.toStringAsFixed(1),
                        unit: 'deg',
                        sliderValue: _aoa,
                        min: 0,
                        max: 20,
                        activeColor: AppTheme.aeroNavy,
                        onChanged: (val) => setState(() => _aoa = val),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height < 750
                              ? 4
                              : 8,
                        ),
                        child: const Divider(color: Colors.white30, height: 1),
                      ),
                      // Freestream Velocity Slider
                      _buildPremiumSliderRow(
                        label: 'FREESTREAM VEL',
                        value: _velocity.toStringAsFixed(1),
                        unit: 'm/s',
                        sliderValue: _velocity,
                        min: 1.0,
                        max: 50.0,
                        activeColor: AppTheme.turbulenceMagenta,
                        onChanged: (val) => setState(() => _velocity = val),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height < 750
                              ? 4
                              : 8,
                        ),
                        child: const Divider(color: Colors.white30, height: 1),
                      ),
                      // Chord Length Slider
                      _buildPremiumSliderRow(
                        label: 'CHORD LENGTH',
                        value: _chordLength.toStringAsFixed(2),
                        unit: 'm',
                        sliderValue: _chordLength,
                        min: 0.1,
                        max: 3.0,
                        activeColor: AppTheme.aeroNavy,
                        onChanged: (val) => setState(() => _chordLength = val),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height < 750
                              ? 4.0
                              : 8.0,
                        ),
                        child: const Divider(color: Colors.white30, height: 1),
                      ),
                      // Max Camber Slider
                      _buildPremiumSliderRow(
                        label: 'MAX CAMBER',
                        value: _camber.toStringAsFixed(1),
                        unit: '%',
                        sliderValue: _camber,
                        min: min(0.0, _camber),
                        max: max(12.0, _camber),
                        activeColor: AppTheme.laminarCyan,
                        onChanged: (val) => setState(() => _camber = val),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TunnelGridPainter extends CustomPainter {
  final bool isStalled;

  TunnelGridPainter({required this.isStalled});

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AirfoilSimulationPainter extends CustomPainter {
  final double aoa;
  final double velocity;
  final double camber;
  final bool isStalled;
  final double animationValue;
  final List<Offset> customUpperSurface;
  final List<Offset> customLowerSurface;

  AirfoilSimulationPainter({
    required this.aoa,
    required this.velocity,
    required this.camber,
    required this.isStalled,
    required this.animationValue,
    this.customUpperSurface = const [],
    this.customLowerSurface = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-aoa * pi / 180); // Rotate airfoil based on AoA

    final path = Path();

    // Draw Airfoil Body (Dynamically deform based on camber OR use custom AI points)
    if (customUpperSurface.isNotEmpty && customLowerSurface.isNotEmpty) {
      // Using custom AI points
      double mapX(double x) {
        // Map -1.0 to 1.0 -> -100 to 100
        return x * 100;
      }

      // Helper to make camber bend more in the middle
      double xCurveInfluence(double x) {
        return (1.0 -
            (x * x)); // Parabola that is 1 at x=0, and 0 at x=1 or x=-1
      }

      double mapY(double x, double y) {
        // Y is inverted in canvas. Also apply camber multiplier
        // AI points already have their own shape, but we can still deform them slightly based on the slider
        return -(y * 50) - (camber * xCurveInfluence(x) * 2.0);
      }

      path.moveTo(
        mapX(customUpperSurface.first.dx),
        mapY(customUpperSurface.first.dx, customUpperSurface.first.dy),
      );
      for (int i = 1; i < customUpperSurface.length; i++) {
        double cx = customUpperSurface[i].dx;
        path.lineTo(mapX(cx), mapY(cx, customUpperSurface[i].dy));
      }

      path.lineTo(
        mapX(customLowerSurface.last.dx),
        mapY(customLowerSurface.last.dx, customLowerSurface.last.dy) -
            (camber * xCurveInfluence(customLowerSurface.last.dx) * 1.5),
      );
      for (int i = customLowerSurface.length - 2; i >= 0; i--) {
        double cx = customLowerSurface[i].dx;
        // Lower surface also bends upwards
        path.lineTo(
          mapX(cx),
          mapY(cx, customLowerSurface[i].dy) -
              (camber * xCurveInfluence(cx) * 1.5),
        );
      }
      path.close();
    } else {
      // Default parameter-based shape
      // The higher the camber, the more curved the upper surface and lower surface become
      double camberOffset = camber * 3.0; // Visual multiplier for camber

      path.moveTo(-100, 0); // Leading edge
      // Upper curve (pushed up by camber)
      path.quadraticBezierTo(
        -50,
        -30 - camberOffset,
        50,
        -10 - (camberOffset * 0.5),
      );
      path.quadraticBezierTo(100, 0, 100, 0); // Trailing edge
      // Lower curve (also curves up to maintain thickness, creating undercamber)
      path.quadraticBezierTo(
        50,
        10 - (camberOffset * 0.8),
        -50,
        20 - (camberOffset * 0.2),
      );
      path.quadraticBezierTo(-100, 0, -100, 0);
    }

    // Dynamic Pressure Field Mapping (Gradients)
    // Low pressure on top (Laminar Cyan -> Turbulence Magenta)
    // High pressure on bottom (Dark Blue / Aero Navy)
    final pressurePaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, -50),
        const Offset(0, 50),
        [
          AppTheme.turbulenceMagenta.withValues(
            alpha: isStalled ? 0.9 : 0.4 + (aoa / 20) * 0.5,
          ), // Suction Peak
          AppTheme.laminarCyan.withValues(alpha: 0.6),
          AppTheme.aeroNavy.withValues(alpha: 0.8), // High Pressure
        ],
        [0.0, 0.4, 1.0],
      )
      ..style = PaintingStyle.fill;

    // Draw an aura around the airfoil to represent the pressure field
    canvas.drawPath(
      path,
      Paint()
        ..shader = pressurePaint.shader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    final fillPaint = Paint()..color = AppTheme.titaniumSilver;
    final strokePaint = Paint()
      ..color = AppTheme.aeroNavy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Restore transform before drawing streamlines so they span the whole screen
    canvas.restore();

    // Draw Streamlines
    final streamPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Animate flow speed based on velocity
    double flowOffset =
        (animationValue * size.width * (velocity / 10)) % size.width;

    if (!isStalled) {
      // Bernoulli Mapping: Top streamlines are compressed (faster, magenta)
      streamPaint.shader = ui.Gradient.linear(
        Offset(-size.width / 2 + flowOffset, 0),
        Offset(size.width + flowOffset, 0),
        [
          AppTheme.laminarCyan,
          AppTheme.turbulenceMagenta,
          AppTheme.laminarCyan,
        ],
        [0.0, 0.5, 1.0],
        TileMode.repeated,
      );

      // Upper Surface Streamline (Compressed)
      final topStream = Path();
      topStream.moveTo(0, size.height / 2 - 60);
      topStream.quadraticBezierTo(
        size.width / 2,
        size.height / 2 - 100 - aoa * 2.5,
        size.width,
        size.height / 2 - 40,
      );
      canvas.drawPath(topStream, streamPaint);

      // Lower Surface Streamline (Slower, High Pressure)
      streamPaint.shader = ui.Gradient.linear(
        Offset(-size.width / 2 + flowOffset * 0.5, 0), // Moves slower
        Offset(size.width + flowOffset * 0.5, 0),
        [AppTheme.aeroNavy, AppTheme.laminarCyan, AppTheme.aeroNavy],
        [0.0, 0.5, 1.0],
        TileMode.repeated,
      );
      final midStream = Path();
      midStream.moveTo(0, size.height / 2 + 30);
      midStream.quadraticBezierTo(
        size.width / 2,
        size.height / 2 + 50 + aoa * 1.5,
        size.width,
        size.height / 2 + 20,
      );
      canvas.drawPath(midStream, streamPaint);
    } else {
      // Turbulent / Stalled Streamlines (Boundary Layer Separation)
      streamPaint.shader = ui.Gradient.linear(
        Offset(-size.width / 2 + flowOffset, 0),
        Offset(size.width + flowOffset, 0),
        [AppTheme.stallRed, AppTheme.turbulenceMagenta, AppTheme.stallRed],
        [0.0, 0.5, 1.0],
        TileMode.repeated,
      );

      final turbPath1 = Path();
      turbPath1.moveTo(0, size.height / 2 - 20);
      turbPath1.quadraticBezierTo(
        size.width / 3,
        size.height / 2 - 50,
        size.width / 2,
        size.height / 2 - 20,
      );
      turbPath1.quadraticBezierTo(
        size.width * 2 / 3,
        size.height / 2 + 50,
        size.width,
        size.height / 2 - 40,
      );
      canvas.drawPath(turbPath1, streamPaint);

      final turbPath2 = Path();
      turbPath2.moveTo(0, size.height / 2 + 20);
      turbPath2.quadraticBezierTo(
        size.width / 3,
        size.height / 2 + 10,
        size.width / 2,
        size.height / 2 + 40,
      );
      turbPath2.quadraticBezierTo(
        size.width * 2 / 3,
        size.height / 2 - 20,
        size.width,
        size.height / 2 + 20,
      );
      canvas.drawPath(turbPath2, streamPaint);

      // Von Karman Vortex Street (Particles)
      final particlePaint = Paint()
        ..color = AppTheme.stallRed.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 5; i++) {
        double cx = size.width / 2 + 50 + (i * 40) + (flowOffset % 40);
        double cy = size.height / 2 + sin(cx * 0.1) * 30;
        canvas.drawCircle(Offset(cx, cy), 4.0, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AirfoilSimulationPainter oldDelegate) {
    return oldDelegate.aoa != aoa ||
        oldDelegate.velocity != velocity ||
        oldDelegate.camber != camber ||
        oldDelegate.isStalled != isStalled ||
        oldDelegate.animationValue != animationValue;
  }
}
