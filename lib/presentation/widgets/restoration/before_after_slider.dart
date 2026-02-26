import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orivet/core/constants/colors.dart';

class BeforeAfterSlider extends StatefulWidget {
  final String beforeImage;
  final String afterImage;
  final double initialPosition;
  final bool isLocalBefore; // New parameter to support local file

  const BeforeAfterSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.initialPosition = 0.5,
    this.isLocalBefore = false,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  late double _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _position += details.delta.dx / width;
              _position = _position.clamp(0.0, 1.0);
            });
          },
          child: Stack(
            children: [
              // After Image (Base) - "Restored"
              SizedBox(
                width: width,
                height: height,
                child: Image.network(
                  widget.afterImage,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: AppColors.soot),
                ),
              ),

              // Before Image (Clipped) - "Damaged"
              ClipRect(
                clipper: _SliderClipper(_position),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.393,
                      0.769,
                      0.189,
                      0,
                      0,
                      0.349,
                      0.686,
                      0.168,
                      0,
                      0,
                      0.272,
                      0.534,
                      0.131,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]), // Sepia + Darker/Damaged look simulation
                    child: widget.isLocalBefore
                        ? Image.file(
                            File(widget.beforeImage),
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                Container(color: AppColors.soot),
                          )
                        : Image.network(
                            widget.beforeImage,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                Container(color: AppColors.soot),
                          ),
                  ),
                ),
              ),

              // Slider Handle
              Positioned(
                left: width * _position - 16, // Center handle
                top: 0,
                bottom: 0,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(width: 2, color: AppColors.brass)),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.brass,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.vellum, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        FontAwesomeIcons.arrowsLeftRight,
                        color: AppColors.leather,
                        size: 14,
                      ),
                    ),
                    Expanded(
                        child: Container(width: 2, color: AppColors.brass)),
                  ],
                ),
              ),

              // Labels
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: AppColors.brass.withOpacity(0.3)),
                    ),
                    child: const Text(
                      "DRAG TO COMPARE",
                      style: TextStyle(
                        color: AppColors.brass,
                        fontFamily: 'Courier Prime',
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SliderClipper extends CustomClipper<Rect> {
  final double position;

  _SliderClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(_SliderClipper oldClipper) =>
      oldClipper.position != position;
}
