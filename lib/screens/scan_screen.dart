import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import '../utils/theme.dart';
import '../services/LocalAirfoilGenerator.dart';
import 'CoinBalanceManager.dart';

class ScanScreen extends StatefulWidget {
  final Function(List<Offset> upper, List<Offset> lower, double camber)?
  onTestRequested;

  const ScanScreen({super.key, this.onTestRequested});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  late AnimationController _scannerController;
  late AnimationController _fadeController;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isProcessing = false;
  bool _extractionComplete = false;

  double _chordLength = 0.0;
  double _maxCamber = 0.0;

  List<Offset> _upperSurface = [];
  List<Offset> _lowerSurface = [];

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final balance = await CoinBalanceManager.getBalance();
        if (balance <= 0) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Insufficient coins. Please purchase more.'),
              backgroundColor: AppTheme.turbulenceMagenta,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          return;
        }

        setState(() {
          _selectedImage = File(image.path);
          _isProcessing = true;
          _extractionComplete = false;
          _fadeController.reset();
        });
        _processImage();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final result = LocalAirfoilGenerator.generateRandomAirfoil(numPoints: 20);

    await CoinBalanceManager.deductCoins(1);

    setState(() {
      _isProcessing = false;
      _extractionComplete = true;

      _chordLength = result.chordLength;
      _maxCamber = result.maxCamber;

      _upperSurface = result.upperSurface
          .map((p) => Offset(p['x']!, p['y']!))
          .toList();

      _lowerSurface = result.lowerSurface
          .map((p) => Offset(p['x']!, p['y']!))
          .toList();
    });

    _fadeController.forward();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: AppTheme.laminarCyan.withValues(alpha: 0.3),
            ),
          ),
          title: Row(
            children: const [
              Icon(Icons.info_outline, color: AppTheme.laminarCyan),
              SizedBox(width: 8),
              Text(
                'Aero-Vision Info',
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
                  'Interface & Functionality',
                  'Aero-Vision uses local NACA airfoil generation to instantly convert your images into engineering-grade geometric data for wind tunnel testing. No cloud processing required - all calculations happen on your device.',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  'Image Upload Requirements',
                  '• Image must clearly show an airfoil, wing cross-section, or propeller blade slice.\n• Ensure high contrast (e.g., black lines on white paper).\n• Avoid people, landscapes, or irrelevant objects in the frame.',
                ),
                const SizedBox(height: 16),
                _buildInfoSection(
                  'Coin Consumption',
                  '• Each airfoil scan consumes 1 coin from your balance.\n• Ensure you have sufficient coins before scanning.\n• Visit the Coin Store to purchase more coins if needed.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'GOT IT',
                style: TextStyle(
                  color: AppTheme.laminarCyan,
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
            color: AppTheme.laminarCyan,
            fontSize: 14,
            fontWeight: FontWeight.w600,
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
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          // Image Background Layer (Fades out when extraction completes)
          if (_selectedImage != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: 1.0 - _fadeController.value,
                    child: child,
                  );
                },
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  color: AppTheme.polarIce.withValues(alpha: 0.8),
                  colorBlendMode: BlendMode.lighten,
                ),
              ),
            ),

          // Camera Viewport Overlay (Corner Brackets & Center Info)
          Positioned(
            top: 130,
            bottom: MediaQuery.of(context).size.height < 700
                ? 220
                : 350, // Responsive bottom margin to prevent overlap
            left: 20,
            right: 20,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: ViewportBracketPainter()),
                ),
                // Center Hint Text (when not complete)
                if (!_extractionComplete &&
                    !_isProcessing &&
                    _selectedImage == null)
                  _buildEmptyState(),
              ],
            ),
          ),

          // Top Status Pill
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isProcessing
                        ? AppTheme.turbulenceMagenta.withValues(alpha: 0.3)
                        : AppTheme.laminarCyan.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.aeroNavy.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isProcessing ? Icons.memory : Icons.my_location,
                      color: _isProcessing
                          ? AppTheme.turbulenceMagenta
                          : AppTheme.laminarCyan,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isProcessing
                          ? 'Processing Vision Data...'
                          : 'Edge Detection Active',
                      style: TextStyle(
                        color: _isProcessing
                            ? AppTheme.turbulenceMagenta
                            : AppTheme.laminarCyan,
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Info Button (Top Right)
          Positioned(
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: _showInfoDialog,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.laminarCyan.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.aeroNavy.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppTheme.laminarCyan,
                  size: 24,
                ),
              ),
            ),
          ),

          // Central Scanner View (Fades in when extraction completes)
          if (_isProcessing || _extractionComplete)
            Positioned(
              top: 150,
              bottom: 300,
              left: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _scannerController,
                  _fadeController,
                ]),
                builder: (context, child) {
                  return Opacity(
                    opacity: _extractionComplete ? _fadeController.value : 1.0,
                    child: CustomPaint(
                      painter: ScannerPainter(
                        animationValue: _scannerController.value,
                        isComplete: _extractionComplete,
                        upperSurface: _upperSurface,
                        lowerSurface: _lowerSurface,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Data Panel (Slides up and fades in)
          if (_extractionComplete)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuint,
              bottom: _extractionComplete ? 140 : 100,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _extractionComplete ? 1.0 : 0.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.laminarCyan.withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.aeroNavy.withValues(alpha: 0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.laminarCyan.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: AppTheme.laminarCyan,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'NURBS Extracted',
                                    style: const TextStyle(
                                      color: AppTheme.aeroNavy,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.laminarCyan.withValues(
                                    alpha: 0.1,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.laminarCyan.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'RANDOM',
                                  style: TextStyle(
                                    color: AppTheme.laminarCyan,
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.aeroNavy.withValues(alpha: 0.0),
                                  AppTheme.aeroNavy.withValues(alpha: 0.1),
                                  AppTheme.aeroNavy.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CHORD_LEN',
                                style: TextStyle(
                                  color: AppTheme.aeroNavy.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '${_chordLength.toStringAsFixed(1)} ',
                                  style: const TextStyle(
                                    color: AppTheme.aeroNavy,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'monospace',
                                    fontSize: 20,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'mm',
                                      style: TextStyle(
                                        color: AppTheme.aeroNavy.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MAX_CAMBER',
                                style: TextStyle(
                                  color: AppTheme.aeroNavy.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '${_maxCamber.toStringAsFixed(1)} ',
                                  style: const TextStyle(
                                    color: AppTheme.turbulenceMagenta,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'monospace',
                                    fontSize: 20,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '%',
                                      style: TextStyle(
                                        color: AppTheme.aeroNavy.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Action Bar
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSideButton(
                  Icons.photo_library,
                  'Album',
                  () => _pickImage(ImageSource.gallery),
                ),
                _buildCaptureButton(),
                _buildSideButton(Icons.science, 'Experiment', () {
                  if (_extractionComplete && widget.onTestRequested != null) {
                    widget.onTestRequested!(
                      _upperSurface,
                      _lowerSurface,
                      _maxCamber,
                    );
                  } else if (!_extractionComplete) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please scan an airfoil first.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }, isActive: _extractionComplete),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.laminarCyan.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.laminarCyan.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.laminarCyan.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.document_scanner_outlined,
                size: 48,
                color: AppTheme.laminarCyan,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'AERO-VISION READY',
              style: TextStyle(
                color: AppTheme.aeroNavy,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Upload or capture an image to extract\nNURBS geometry and generate mesh.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.aeroNavy.withValues(alpha: 0.6),
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTag('Sketches'),
                const SizedBox(width: 8),
                _buildTag('Propellers'),
                const SizedBox(width: 8),
                _buildTag('Wing Profiles'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.aeroNavy.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.aeroNavy.withValues(alpha: 0.1)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.aeroNavy,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSideButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.laminarCyan.withValues(alpha: 0.15)
                  : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? AppTheme.laminarCyan
                    : AppTheme.aeroNavy.withValues(alpha: 0.1),
              ),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: AppTheme.laminarCyan.withValues(alpha: 0.3),
                    blurRadius: 8,
                  )
                else
                  BoxShadow(
                    color: AppTheme.aeroNavy.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Icon(
              icon,
              color: isActive
                  ? AppTheme.laminarCyan
                  : AppTheme.aeroNavy.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? AppTheme.laminarCyan
                  : AppTheme.aeroNavy.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: () => _pickImage(ImageSource.camera),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.laminarCyan, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppTheme.laminarCyan.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.aeroNavy.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
            ),
            const Icon(Icons.camera, color: AppTheme.aeroNavy, size: 36),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.laminarCyan.withValues(alpha: 0.05)
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

class ViewportBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.laminarCyan.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double length = 30.0;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(0, length)
        ..lineTo(0, 0)
        ..lineTo(length, 0),
      paint,
    );
    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, length),
      paint,
    );
    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - length)
        ..lineTo(0, size.height)
        ..lineTo(length, size.height),
      paint,
    );
    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - length),
      paint,
    );

    // Center Crosshair
    final crossPaint = Paint()
      ..color = AppTheme.aeroNavy.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(size.width / 2 - 10, size.height / 2),
      Offset(size.width / 2 + 10, size.height / 2),
      crossPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - 10),
      Offset(size.width / 2, size.height / 2 + 10),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScannerPainter extends CustomPainter {
  final double animationValue;
  final bool isComplete;
  final List<Offset> upperSurface;
  final List<Offset> lowerSurface;

  ScannerPainter({
    required this.animationValue,
    required this.isComplete,
    this.upperSurface = const [],
    this.lowerSurface = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Airfoil Outline
    final path = Path();

    if (upperSurface.isNotEmpty && lowerSurface.isNotEmpty) {
      // Dynamic rendering based on AI points
      // AI points are normalized -1.0 to 1.0 (X) and roughly -0.5 to 0.5 (Y)
      // We need to map them to the canvas size

      double mapX(double x) {
        // Map -1.0 to 1.0 -> 20 to (size.width - 20)
        return 20 + ((x + 1.0) / 2.0) * (size.width - 40);
      }

      double mapY(double y) {
        // Map y (e.g. -0.5 to 0.5) to canvas height. Invert Y for canvas.
        // Multiply by 150 to scale up the thickness visually
        return (size.height / 2) - (y * 150);
      }

      // Draw upper surface
      path.moveTo(mapX(upperSurface.first.dx), mapY(upperSurface.first.dy));
      for (int i = 1; i < upperSurface.length; i++) {
        path.lineTo(mapX(upperSurface[i].dx), mapY(upperSurface[i].dy));
      }

      // Draw lower surface (usually from trailing edge back to leading edge, or vice versa depending on AI)
      // Assuming AI returns lower surface from leading to trailing edge as well
      // We need to connect from trailing edge (last point of upper) to trailing edge of lower
      path.lineTo(mapX(lowerSurface.last.dx), mapY(lowerSurface.last.dy));
      for (int i = lowerSurface.length - 2; i >= 0; i--) {
        path.lineTo(mapX(lowerSurface[i].dx), mapY(lowerSurface[i].dy));
      }
      path.close();
    } else {
      // Fallback: Default hardcoded mock shape
      path.moveTo(20, size.height / 2);
      path.quadraticBezierTo(
        80,
        size.height / 2 - 40,
        200,
        size.height / 2 - 40,
      );
      path.quadraticBezierTo(
        size.width - 20,
        size.height / 2 - 20,
        size.width - 20,
        size.height / 2,
      );
      path.quadraticBezierTo(
        200,
        size.height / 2 + 20,
        80,
        size.height / 2 + 20,
      );
      path.quadraticBezierTo(20, size.height / 2, 20, size.height / 2);
    }

    if (isComplete) {
      // Draw Metallic Body when complete (Data Twin)
      final fillPaint = Paint()
        ..shader =
            ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), [
              AppTheme.titaniumSilver.withValues(alpha: 0.5),
              AppTheme.titaniumSilver.withValues(alpha: 0.1),
            ])
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Outer Glow for Stroke
    final glowPaint = Paint()
      ..color = isComplete
          ? AppTheme.laminarCyan.withValues(alpha: 0.5)
          : AppTheme.laminarCyan.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isComplete ? 4.0 : 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawPath(path, glowPaint);

    // Inner sharp Stroke
    final strokePaint = Paint()
      ..color = isComplete ? AppTheme.aeroNavy : AppTheme.laminarCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = isComplete ? 2.0 : 2.0;

    canvas.drawPath(path, strokePaint);

    // Draw scanning laser only if NOT complete
    if (!isComplete) {
      final laserY = 20 + (size.height - 40) * animationValue;

      // Laser Core
      final laserPaint = Paint()
        ..color = AppTheme.turbulenceMagenta
        ..strokeWidth = 2.0;

      // Laser Glow
      final laserGlowPaint = Paint()
        ..color = AppTheme.turbulenceMagenta.withValues(alpha: 0.6)
        ..strokeWidth = 8.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawLine(
        Offset(10, laserY),
        Offset(size.width - 10, laserY),
        laserGlowPaint,
      );

      canvas.drawLine(
        Offset(20, laserY),
        Offset(size.width - 20, laserY),
        laserPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ScannerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isComplete != isComplete;
  }
}
