import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/colors.dart';

class Viewfinder extends StatefulWidget {
  final Function(File) onImageSelected;
  final File? selectedImage;

  const Viewfinder({
    super.key,
    required this.onImageSelected,
    this.selectedImage,
  });

  @override
  State<Viewfinder> createState() => _ViewfinderState();
}

class _ViewfinderState extends State<Viewfinder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      widget.onImageSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 256,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.trenchBlue,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.alienPurple.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // Image
              if (widget.selectedImage != null)
                Image.file(
                  widget.selectedImage!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.voidBlack,
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: AppColors.alienPurple.withValues(alpha: 0.5),
                      size: 48,
                    ),
                  ),
                ),

              // Corners
              _buildCorner(top: 16, left: 16, isTop: true, isLeft: true),
              _buildCorner(top: 16, right: 16, isTop: true, isLeft: false),
              _buildCorner(bottom: 16, left: 16, isTop: false, isLeft: true),
              _buildCorner(bottom: 16, right: 16, isTop: false, isLeft: false),

              // Scan Line
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 256 * _controller.value),
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            color: AppColors.alienPurple,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.alienPurple,
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Analyzing Text
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.voidBlack.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.alienPurple.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.alienPurple.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Text(
                    'TAP TO SCAN IMAGE',
                    style: TextStyle(
                      color: AppColors.alienPurple,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required bool isTop,
    required bool isLeft,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: AppColors.alienPurple, width: 2)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: AppColors.alienPurple, width: 2)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: AppColors.alienPurple, width: 2)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: AppColors.alienPurple, width: 2)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
