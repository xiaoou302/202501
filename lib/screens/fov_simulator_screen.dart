import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/fov_calculator.dart';
import '../services/data_service.dart';
import '../models/astro_target.dart';
import '../widgets/glass_panel.dart';
import '../widgets/astro_image.dart';
import '../utils/app_colors.dart';

import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FovSimulatorScreen extends StatefulWidget {
  const FovSimulatorScreen({super.key});

  @override
  State<FovSimulatorScreen> createState() => _FovSimulatorScreenState();
}

class _FovSimulatorScreenState extends State<FovSimulatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _focalLengthController = TextEditingController(
    text: '400',
  );
  final TextEditingController _sensorWidthController = TextEditingController(
    text: '23.5',
  );
  final TextEditingController _sensorHeightController = TextEditingController(
    text: '15.6',
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  FovResult? _fovResult;
  AstroTarget? _selectedTarget;
  File? _customImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _calculate();
    _focalLengthController.addListener(_calculate);
    _sensorWidthController.addListener(_calculate);
    _sensorHeightController.addListener(_calculate);
    _animationController.forward();
  }

  void _calculate() {
    final fl = double.tryParse(_focalLengthController.text) ?? 0;
    final sw = double.tryParse(_sensorWidthController.text) ?? 0;
    final sh = double.tryParse(_sensorHeightController.text) ?? 0;
    setState(() {
      _fovResult = FovCalculator.calculate(sw, sh, fl);
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _customImage = File(image.path);
        _selectedTarget = null;
      });
    }
  }

  @override
  void dispose() {
    _focalLengthController.dispose();
    _sensorWidthController.dispose();
    _sensorHeightController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showTargetSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return GlassPanel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.list,
                          color: AppColors.andromedaCyan,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'SELECT TARGET',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.starlightWhite,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<DataService>(
                      builder: (context, dataService, child) {
                        return ListView.separated(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: dataService.targets.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final target = dataService.targets[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTarget = target;
                                  _customImage = null;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.darkMatter.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.glassBorder.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: AstroImage(
                                        imageUrl: target.imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            target.name.toUpperCase(),
                                            style: const TextStyle(
                                              color: AppColors.starlightWhite,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            target.constellation.toUpperCase(),
                                            style: const TextStyle(
                                              color: AppColors.andromedaCyan,
                                              fontSize: 10,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.meteoriteGrey,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate aspect ratio for the frame
    double frameAspectRatio = 1.0;
    if (_fovResult != null && _fovResult!.heightDegrees > 0) {
      frameAspectRatio = _fovResult!.widthDegrees / _fovResult!.heightDegrees;
    }

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.crosshairs,
                        color: AppColors.orionPurple,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FOV SIMULATOR',
                            style: TextStyle(
                              color: AppColors.orionPurple,
                              fontSize: 12,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Framing Assistant',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.starlightWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Configuration Panel
                  GlassPanel(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.sliders,
                                  size: 14,
                                  color: AppColors.andromedaCyan,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'OPTICAL TRAIN',
                                  style: TextStyle(
                                    color: AppColors.andromedaCyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildInput(
                                'FOCAL LENGTH',
                                'mm',
                                _focalLengthController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: _buildInput(
                                'SENSOR W',
                                'mm',
                                _sensorWidthController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: _buildInput(
                                'SENSOR H',
                                'mm',
                                _sensorHeightController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results Bar
                  GlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFovValue(
                          context,
                          'FIELD OF VIEW',
                          _fovResult?.formattedDegrees ?? 'N/A',
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColors.glassBorder,
                        ),
                        _buildFovValue(
                          context,
                          'ARCMINUTES',
                          _fovResult?.formattedArcmin ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Simulation View
                  Expanded(
                    child: GlassPanel(
                      padding: EdgeInsets.zero,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _customImage != null
                                ? Image.file(_customImage!, fit: BoxFit.cover)
                                : _selectedTarget != null
                                ? AstroImage(
                                    imageUrl: _selectedTarget!.imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.black,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.image,
                                          size: 48,
                                          color: AppColors.meteoriteGrey
                                              .withOpacity(0.3),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'NO TARGET SELECTED',
                                          style: TextStyle(
                                            color: AppColors.meteoriteGrey
                                                .withOpacity(0.5),
                                            letterSpacing: 1.5,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),

                          // Framing Rectangle
                          Center(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate max available size with some padding
                                double maxWidth = constraints.maxWidth * 0.8;
                                double maxHeight = constraints.maxHeight * 0.8;

                                return AspectRatio(
                                  aspectRatio: frameAspectRatio,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.safelightRed,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.safelightRed
                                              .withOpacity(0.2),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Crosshair
                                        Center(
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.safelightRed
                                                .withOpacity(0.7),
                                            size: 24,
                                          ),
                                        ),
                                        // Corner markers
                                        ..._buildCorners(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Controls Overlay
                          Positioned(
                            bottom: 16,
                            right: 16,
                            left: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.safelightRed
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: AppColors.safelightRed,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: const Text(
                                            'SIMULATION ACTIVE',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.safelightRed,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildActionButton(
                                        icon: FontAwesomeIcons.image,
                                        onTap: _pickImage,
                                        tooltip: 'Upload Image',
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: _buildActionButton(
                                          icon:
                                              FontAwesomeIcons.magnifyingGlass,
                                          onTap: () =>
                                              _showTargetSelector(context),
                                          label: 'SELECT',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
      ),
    );
  }

  List<Widget> _buildCorners() {
    return [
      // Top Left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.safelightRed, width: 3),
              left: BorderSide(color: AppColors.safelightRed, width: 3),
            ),
          ),
        ),
      ),
      // Top Right
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.safelightRed, width: 3),
              right: BorderSide(color: AppColors.safelightRed, width: 3),
            ),
          ),
        ),
      ),
      // Bottom Left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.safelightRed, width: 3),
              left: BorderSide(color: AppColors.safelightRed, width: 3),
            ),
          ),
        ),
      ),
      // Bottom Right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.safelightRed, width: 3),
              right: BorderSide(color: AppColors.safelightRed, width: 3),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    String? label,
    String? tooltip,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.orionPurple,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.orionPurple.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.orionPurple.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFovValue(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.meteoriteGrey,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.starlightWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            shadows: [
              BoxShadow(
                color: AppColors.andromedaCyan.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInput(
    String label,
    String unit,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.meteoriteGrey,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.meteoriteGrey.withOpacity(0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cosmicBlack.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: const TextStyle(
              color: AppColors.starlightWhite,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
