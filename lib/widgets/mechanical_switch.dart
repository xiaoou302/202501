import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../utils/app_colors.dart';

class MechanicalSwitch extends StatelessWidget {
  final VoidCallback onTap;

  const MechanicalSwitch({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isRedSafelight = context.select<ThemeService, bool>(
      (s) => s.isRedSafelight,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: isRedSafelight ? AppColors.dwarfRed : AppColors.darkMatter,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRedSafelight
                ? AppColors.safelightRed
                : AppColors.glassBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              top: 2,
              left: isRedSafelight ? 42 : 2,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isRedSafelight
                      ? AppColors.safelightRed
                      : AppColors.meteoriteGrey,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isRedSafelight
                          ? AppColors.safelightRed.withOpacity(0.6)
                          : Colors.black.withOpacity(0.4),
                      blurRadius: isRedSafelight ? 15 : 4,
                      spreadRadius: isRedSafelight ? 2 : 0,
                      offset: const Offset(0, 2),
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
