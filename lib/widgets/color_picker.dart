import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ColorPicker extends StatefulWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final Function(Color) onColorSelected;

  const ColorPicker({
    Key? key,
    required this.colors,
    this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8),
              child: Text(
                "Choose a color theme:",
                style: TextStyle(
                  color: AppTheme.textColor.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: widget.colors.map((color) {
                final isSelected = widget.selectedColor == color;
                return GestureDetector(
                  onTap: () => widget.onColorSelected(color),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color,
                          Color.lerp(color, Colors.black, 0.2) ?? color,
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(isSelected ? 0.6 : 0.3),
                          blurRadius: isSelected ? 12 : 5,
                          spreadRadius: isSelected ? 2 : 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    transform: isSelected
                        ? (Matrix4.identity()..scale(1.1))
                        : Matrix4.identity(),
                    transformAlignment: Alignment.center,
                    child: isSelected
                        ? Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: AppTheme.textColor.withOpacity(0.5),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Color will be applied to your journal entry",
                      style: TextStyle(
                        color: AppTheme.textColor.withOpacity(0.5),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
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

  // Predefined color palette
  static List<Color> defaultColors() {
    return [
      AppTheme.primaryColor,
      AppTheme.accentGreen,
      AppTheme.accentPurple,
      AppTheme.accentPink,
      AppTheme.accentYellow,
      AppTheme.accentBlue,
    ];
  }
}
