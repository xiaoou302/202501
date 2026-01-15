import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../core/constants/app_constants.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<DrawingPoint> _points = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 3.0;
  bool _isEraser = false;
  List<File> _savedDrawings = [];

  final List<Color> _colors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  final List<double> _strokeWidths = [1.0, 3.0, 5.0, 8.0, 12.0];

  @override
  void initState() {
    super.initState();
    _loadSavedDrawings();
  }

  Future<void> _loadSavedDrawings() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((item) => item.path.endsWith('.png') && item.path.contains('drawing_'))
          .map((item) => File(item.path))
          .toList();
      
      // Sort by modification time (newest first)
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      
      setState(() {
        _savedDrawings = files;
      });
    } catch (e) {
      debugPrint('Error loading saved drawings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.midnight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildToolbar(),
            Expanded(
              child: _buildCanvas(),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.midnight,
            AppConstants.midnight.withValues(alpha: 0.95),
          ],
        ),
        border: const Border(
          bottom: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.gold.withValues(alpha: 0.2),
                            AppConstants.gold.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.palette_outlined,
                        color: AppConstants.gold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Flexible(
                      child: Text(
                        'Creative Studio',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.offwhite,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Text(
                    'Express your creativity',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppConstants.metalgray.withValues(alpha: 0.8),
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderButton(
                icon: Icons.photo_library_outlined,
                onPressed: _showGallery,
                tooltip: 'Gallery',
              ),
              const SizedBox(width: 8),
              _buildHeaderButton(
                icon: Icons.info_outline,
                onPressed: _showInfoDialog,
                tooltip: 'Info',
              ),
              const SizedBox(width: 8),
              _buildHeaderButton(
                icon: Icons.delete_outline,
                onPressed: _clearCanvas,
                tooltip: 'Clear',
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isDestructive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDestructive 
                  ? Colors.red.withValues(alpha: 0.1)
                  : AppConstants.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDestructive 
                    ? Colors.red.withValues(alpha: 0.3)
                    : AppConstants.gold.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isDestructive ? Colors.red.withValues(alpha: 0.9) : AppConstants.gold,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.35,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.surface.withValues(alpha: 0.95),
            AppConstants.surface,
          ],
        ),
        border: const Border(
          bottom: BorderSide(color: Colors.white10, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Brush/Eraser toggle with modern design
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppConstants.midnight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildModeButton(
                      icon: Icons.brush_outlined,
                      label: 'Brush',
                      isSelected: !_isEraser,
                      onTap: () => setState(() => _isEraser = false),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildModeButton(
                      icon: Icons.auto_fix_high_outlined,
                      label: 'Eraser',
                      isSelected: _isEraser,
                      onTap: () => setState(() => _isEraser = true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Stroke width selector with enhanced design
            _buildToolSection(
              icon: Icons.line_weight_outlined,
              label: 'Stroke Width',
              child: SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _strokeWidths.length,
                  itemBuilder: (context, index) {
                    final width = _strokeWidths[index];
                    final isSelected = _strokeWidth == width;
                    return GestureDetector(
                      onTap: () => setState(() => _strokeWidth = width),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    AppConstants.gold.withValues(alpha: 0.3),
                                    AppConstants.gold.withValues(alpha: 0.15),
                                  ],
                                )
                              : null,
                          color: isSelected ? null : AppConstants.midnight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? AppConstants.gold 
                                : Colors.white.withValues(alpha: 0.1),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppConstants.gold.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Container(
                            width: width * 2.5,
                            height: width * 2.5,
                            decoration: BoxDecoration(
                              color: isSelected ? AppConstants.gold : AppConstants.metalgray,
                              shape: BoxShape.circle,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppConstants.gold.withValues(alpha: 0.5),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Color palette with premium design
            _buildToolSection(
              icon: Icons.palette_outlined,
              label: 'Color Palette',
              child: SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                          _isEraser = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    AppConstants.gold.withValues(alpha: 0.3),
                                    AppConstants.gold.withValues(alpha: 0.1),
                                  ],
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppConstants.gold.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected 
                                    ? AppConstants.gold 
                                    : Colors.white.withValues(alpha: 0.3),
                                width: isSelected ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check_rounded,
                                    color: color == Colors.white || color == Colors.yellow
                                        ? AppConstants.midnight
                                        : Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppConstants.gold,
                    AppConstants.gold.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.gold.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppConstants.midnight : AppConstants.metalgray,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppConstants.midnight : AppConstants.metalgray,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolSection({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.gold.withValues(alpha: 0.2),
                    AppConstants.gold.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppConstants.gold, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstants.offwhite,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildCanvas() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.gold.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Canvas background with subtle texture
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppConstants.gold.withValues(alpha: 0.2),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            // Drawing area
            RepaintBoundary(
              key: _canvasKey,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _points.add(
                      DrawingPoint(
                        offset: details.localPosition,
                        paint: Paint()
                          ..color = _isEraser ? Colors.white : _selectedColor
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round
                          ..strokeJoin = StrokeJoin.round
                          ..isAntiAlias = true
                          ..filterQuality = FilterQuality.high,
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _points.add(
                      DrawingPoint(
                        offset: details.localPosition,
                        paint: Paint()
                          ..color = _isEraser ? Colors.white : _selectedColor
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round
                          ..strokeJoin = StrokeJoin.round
                          ..isAntiAlias = true
                          ..filterQuality = FilterQuality.high,
                      ),
                    );
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _points.add(DrawingPoint(offset: null, paint: Paint()));
                  });
                },
                child: CustomPaint(
                  painter: DrawingPainter(points: _points),
                  size: Size.infinite,
                ),
              ),
            ),
            // Watermark or hint when canvas is empty
            if (_points.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      size: 48,
                      color: AppConstants.metalgray.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start drawing here',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.metalgray.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.midnight.withValues(alpha: 0.95),
            AppConstants.midnight,
          ],
        ),
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.undo_rounded,
                label: 'Undo',
                onPressed: _undoLastStroke,
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildActionButton(
                icon: Icons.save_rounded,
                label: 'Save Artwork',
                onPressed: _saveDrawing,
                isPrimary: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      AppConstants.gold,
                      AppConstants.gold.withValues(alpha: 0.85),
                    ],
                  )
                : null,
            color: isPrimary ? null : AppConstants.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isPrimary 
                  ? AppConstants.gold.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppConstants.gold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? AppConstants.midnight : AppConstants.offwhite,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? AppConstants.midnight : AppConstants.offwhite,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text(
            'Clear Canvas',
            style: TextStyle(
              color: AppConstants.offwhite,
              fontFamily: 'PlayfairDisplay',
            ),
          ),
          content: const Text(
            'Are you sure you want to clear the entire canvas? This action cannot be undone.',
            style: TextStyle(color: AppConstants.metalgray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppConstants.metalgray),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _points.clear();
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _undoLastStroke() {
    if (_points.isEmpty) return;
    
    setState(() {
      // Remove points until we hit a null point (stroke separator) or empty
      while (_points.isNotEmpty && _points.last.offset != null) {
        _points.removeLast();
      }
      // Remove the null point separator
      if (_points.isNotEmpty) {
        _points.removeLast();
      }
    });
  }

  Future<void> _saveDrawing() async {
    try {
      // Get the render object
      RenderRepaintBoundary boundary = _canvasKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      
      // Convert to image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/drawing_$timestamp.png';
      
      // Save file
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // Reload saved drawings
      await _loadSavedDrawings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppConstants.midnight, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Drawing Saved!',
                        style: TextStyle(
                          color: AppConstants.midnight,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tap gallery icon to view your saved drawings',
                        style: TextStyle(
                          color: AppConstants.midnight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: AppConstants.gold,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save drawing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showGallery() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DrawingGalleryScreen(
          savedDrawings: _savedDrawings,
          onDrawingsChanged: () {
            _loadSavedDrawings();
          },
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.surface,
                  AppConstants.surface.withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppConstants.gold.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.gold.withValues(alpha: 0.15),
                        AppConstants.gold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.gold.withValues(alpha: 0.3),
                              AppConstants.gold.withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.palette_outlined,
                          color: AppConstants.gold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Creative Studio',
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 24,
                                color: AppConstants.offwhite,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Quick Guide',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppConstants.metalgray,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppConstants.metalgray),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Content - 添加滚动支持
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem('🎨', 'Switch between Brush and Eraser modes'),
                        _buildInfoItem('📏', 'Adjust stroke width (1-12 pixels)'),
                        _buildInfoItem('🌈', 'Choose from 12 vibrant colors'),
                        _buildInfoItem('✏️', 'Draw freely on the canvas'),
                        _buildInfoItem('↩️', 'Undo your last stroke'),
                        _buildInfoItem('💾', 'Save your masterpiece'),
                        _buildInfoItem('🖼️', 'Browse saved artworks in gallery'),
                        _buildInfoItem('🗑️', 'Clear canvas to start fresh'),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppConstants.gold,
                                      AppConstants.gold.withValues(alpha: 0.85),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.gold.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Start Creating',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppConstants.midnight,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
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
        );
      },
    );
  }

  Widget _buildInfoItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppConstants.midnight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.offwhite,
                  height: 1.4,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPoint {
  final Offset? offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw white background first
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Then draw the user's drawing
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != null && points[i + 1].offset != null) {
        canvas.drawLine(
          points[i].offset!,
          points[i + 1].offset!,
          points[i].paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingViewerScreen extends StatefulWidget {
  final File file;
  final VoidCallback onDelete;

  const DrawingViewerScreen({
    super.key,
    required this.file,
    required this.onDelete,
  });

  @override
  State<DrawingViewerScreen> createState() => _DrawingViewerScreenState();
}

class _DrawingViewerScreenState extends State<DrawingViewerScreen> {
  bool _fileExists = true;

  @override
  void initState() {
    super.initState();
    _checkFileExists();
  }

  void _checkFileExists() {
    setState(() {
      _fileExists = widget.file.existsSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_fileExists) {
      // File doesn't exist, go back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Drawing file not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      return const Scaffold(
        backgroundColor: AppConstants.midnight,
        body: Center(
          child: CircularProgressIndicator(color: AppConstants.gold),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.midnight,
      appBar: AppBar(
        backgroundColor: AppConstants.midnight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.offwhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'View Drawing',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: AppConstants.offwhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                widget.file,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppConstants.midnight,
          border: Border(
            top: BorderSide(color: Colors.white10),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Created: ${_formatDateTime(widget.file.lastModifiedSync())}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.metalgray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.file.path.split('/').last,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppConstants.metalgray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppConstants.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          title: const Text(
            'Delete Drawing',
            style: TextStyle(
              color: AppConstants.offwhite,
              fontFamily: 'PlayfairDisplay',
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this drawing? This action cannot be undone.',
            style: TextStyle(color: AppConstants.metalgray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppConstants.metalgray),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DrawingGalleryScreen extends StatefulWidget {
  final List<File> savedDrawings;
  final VoidCallback onDrawingsChanged;

  const DrawingGalleryScreen({
    super.key,
    required this.savedDrawings,
    required this.onDrawingsChanged,
  });

  @override
  State<DrawingGalleryScreen> createState() => _DrawingGalleryScreenState();
}

class _DrawingGalleryScreenState extends State<DrawingGalleryScreen> {
  late List<File> _drawings;

  @override
  void initState() {
    super.initState();
    _drawings = List.from(widget.savedDrawings);
  }

  Future<void> _refreshDrawings() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((item) => item.path.endsWith('.png') && item.path.contains('drawing_'))
          .map((item) => File(item.path))
          .toList();
      
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      
      setState(() {
        _drawings = files;
      });
      
      widget.onDrawingsChanged();
    } catch (e) {
      debugPrint('Error refreshing drawings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.midnight,
      appBar: AppBar(
        backgroundColor: AppConstants.midnight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.offwhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Drawings',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: AppConstants.offwhite,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_drawings.length} items',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.metalgray,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _drawings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: AppConstants.metalgray.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved drawings yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.metalgray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create and save your first drawing!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.metalgray,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _drawings.length,
              itemBuilder: (context, index) {
                final file = _drawings[index];
                return _buildGalleryItem(file, index);
              },
            ),
    );
  }

  Widget _buildGalleryItem(File file, int index) {
    return GestureDetector(
      onTap: () => _viewDrawing(file),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.surface,
              AppConstants.surface.withValues(alpha: 0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstants.gold.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppConstants.gold.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  // Gradient overlay for better text visibility
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.gold.withValues(alpha: 0.9),
                            AppConstants.gold.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        '#${_drawings.length - index}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppConstants.midnight,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppConstants.midnight.withValues(alpha: 0.5),
                    AppConstants.midnight.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.brush_outlined,
                        size: 14,
                        color: AppConstants.gold.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Artwork ${_drawings.length - index}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppConstants.offwhite,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: AppConstants.metalgray.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(file.lastModifiedSync()),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppConstants.metalgray.withValues(alpha: 0.9),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  void _viewDrawing(File file) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DrawingViewerScreen(
          file: file,
          onDelete: () async {
            await _deleteDrawing(file);
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  Future<void> _deleteDrawing(File file) async {
    try {
      await file.delete();
      await _refreshDrawings();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Drawing deleted'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
