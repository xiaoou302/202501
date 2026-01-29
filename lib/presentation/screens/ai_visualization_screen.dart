import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oravie/core/constants/app_colors.dart';
import 'package:oravie/core/services/ai_service.dart';

class AIVisualizationScreen extends StatefulWidget {
  const AIVisualizationScreen({super.key});

  @override
  State<AIVisualizationScreen> createState() => _AIVisualizationScreenState();
}

class _AIVisualizationScreenState extends State<AIVisualizationScreen> {
  final AIService _aiService = AIService();
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  String? _generatedImageUrl;
  bool _isLoading = false;
  String _selectedStyle = 'Minimalist Wood';

  final List<Map<String, dynamic>> _styles = [
    {
      'label': 'Minimalist Wood',
      'icon': FontAwesomeIcons.seedling,
      'value': 'Minimalist Wood',
    },
    {
      'label': 'Vintage Industrial',
      'icon': FontAwesomeIcons.industry,
      'value': 'Vintage Industrial',
    },
    {
      'label': 'French Elegant',
      'icon': FontAwesomeIcons.wineGlass,
      'value': 'French Elegant',
    },
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _generatedImageUrl = null; // Reset generated image on new pick
      });
    }
  }

  Future<void> _generateVisualization() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image first'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Convert image to Base64
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 2. Construct prompt
      final userPrompt = _promptController.text.trim();
      final fullPrompt =
          "Interior design, $_selectedStyle style. ${userPrompt.isNotEmpty ? userPrompt : "High quality renovation, photorealistic, 8k resolution, interior design visualization."}";

      // 3. Call API
      final url = await _aiService.generateImage(
        prompt: fullPrompt,
        imageBase64: base64Image,
      );

      if (url != null) {
        setState(() {
          _generatedImageUrl = url;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to generate image'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _reset() {
    setState(() {
      _generatedImageUrl = null;
      _selectedImage = null;
      _promptController.clear();
    });
  }

  void _undoGeneration() {
    setState(() {
      _generatedImageUrl = null;
    });
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(child: Image.network(imageUrl)),
          ),
        ),
      ),
    );
  }

  // New Background Decor Widget similar to InspirationGalleryScreen
  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        // Top Left Blob
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.slateGreen.withOpacity(0.15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slateGreen.withOpacity(0.15),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // Center Right Blob (Warm tone)
        Positioned(
          top: 200,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0C3A5).withOpacity(0.2), // Warm beige
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE0C3A5).withOpacity(0.2),
                  blurRadius: 80,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
        // Blur Filter to smooth everything out
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            color: Colors.white.withOpacity(0.3), // Glass effect base
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.snowWhite,
        body: Stack(
          children: [
            _buildBackgroundDecor(), // Add background decor
            Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 24,
                    right: 24,
                    bottom: 16,
                  ),
                  color: Colors.white.withOpacity(
                    0.5,
                  ), // Make header semi-transparent

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: const BoxDecoration(
                              color: AppColors.slateGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Text(
                            'Presee Future',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.charcoal,
                              letterSpacing: -0.5,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.slateGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.slateGreen.withOpacity(0.2),
                          ),
                        ),
                        child: const Text(
                          'Beta 2.0',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slateGreen,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Canvas Area
                Expanded(
                  flex: 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Display Image
                      if (_generatedImageUrl != null)
                        GestureDetector(
                          onTap: () =>
                              _showFullScreenImage(_generatedImageUrl!),
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                _generatedImageUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(AppColors.slateGreen),
                                        ),
                                      );
                                    },
                              ),
                            ),
                          ),
                        )
                      else if (_selectedImage != null)
                        Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              ),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=800&q=80',
                                fit: BoxFit.cover,
                                color: Colors.white.withOpacity(0.5),
                                colorBlendMode: BlendMode.modulate,
                              ),
                            ),
                          ),
                        ),

                      // Upload Overlay (only show if no image selected)
                      if (_selectedImage == null)
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.slateGreen.withOpacity(
                                      0.15,
                                    ),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.cloudArrowUp,
                                    color: AppColors.slateGreen,
                                    size: 18,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Upload Your Space',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.charcoal,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Actions (Undo / Reset)
                      Positioned(
                        top: 32,
                        right: 32,
                        child: Row(
                          children: [
                            if (_generatedImageUrl != null)
                              GestureDetector(
                                onTap: _undoGeneration,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      FontAwesomeIcons.rotateLeft,
                                      color: AppColors.charcoal,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            if (_selectedImage != null)
                              GestureDetector(
                                onTap: _reset,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.redAccent,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Controls Panel
                Expanded(
                  flex: 6,
                  child: Container(
                    transform: Matrix4.translationValues(0, -24, 0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95), // Glassy white
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 30,
                          offset: const Offset(0, -10),
                        ),
                      ],
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ListView(
                          padding: const EdgeInsets.all(32),
                          children: [
                            // Handle Bar
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            // Style Selector
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.palette,
                                  size: 14,
                                  color: AppColors.slateGreen,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'TARGET STYLE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.charcoal.withOpacity(0.6),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _styles.map((style) {
                                  final isSelected =
                                      _selectedStyle == style['value'];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedStyle = style['value'];
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.slateGreen
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.transparent
                                                : Colors.grey[200]!,
                                            width: 1.5,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.slateGreen
                                                        .withOpacity(0.3),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 6),
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              style['icon'],
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.grey[400],
                                              size: 24,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              style['label'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Prompt Input
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.wandMagicSparkles,
                                  size: 14,
                                  color: AppColors.slateGreen,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AI ENHANCEMENT',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.charcoal.withOpacity(0.6),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey[100]!,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _promptController,
                                maxLength: 200,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText:
                                      'Describe your dream space... (e.g., "Add a warm rug, change wall color to sage green")',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                    height: 1.5,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  counterText: "",
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.charcoal,
                                  height: 1.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Generate Button
                            GestureDetector(
                              onTap: _isLoading ? null : _generateVisualization,
                              child: Container(
                                width: double.infinity,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _isLoading
                                        ? [Colors.grey[400]!, Colors.grey[400]!]
                                        : [
                                            AppColors.slateGreen,
                                            const Color(0xFF3A5F5F),
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (_isLoading
                                                  ? Colors.grey
                                                  : AppColors.slateGreen)
                                              .withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isLoading)
                                        const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      else
                                        const Icon(
                                          FontAwesomeIcons.wandMagicSparkles,
                                          color: Color(0xFFFDE047), // Yellow
                                          size: 20,
                                        ),
                                      const SizedBox(width: 12),
                                      Text(
                                        _isLoading
                                            ? 'Designing...'
                                            : 'Generate Preview',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'Costs 2 Credits · Estimated time 15s',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(height: 80), // Space for bottom nav
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Global Loading Overlay (Optional, blocking interaction)
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        "Designing your dream space...",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
  }
}
