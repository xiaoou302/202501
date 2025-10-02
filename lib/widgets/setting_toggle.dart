import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Widget for a settings toggle switch
class SettingToggle extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Icon color
  final Color iconColor;

  /// Label text
  final String label;

  /// Whether the toggle is on
  final bool value;

  /// Callback when the value changes
  final ValueChanged<bool> onChanged;

  const SettingToggle({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and label
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGraphite,
                ),
              ),
            ],
          ),

          // Custom toggle switch
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: value ? AppColors.accentCoral : Colors.grey[300],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: AnimationDurations.short,
                    curve: Curves.easeInOut,
                    left: value ? 24 : 4,
                    top: 4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
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
    );
  }
}
