import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onHomePressed;

  const CustomAppBar({super.key, required this.title, this.onHomePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.3),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.alchemicalGold.withOpacity(0.4),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.alchemicalGold.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onHomePressed != null)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.alabasterWhite.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.alabasterWhite.withOpacity(0.2),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.home_outlined, size: 22),
                    color: AppColors.alabasterWhite,
                    onPressed: onHomePressed,
                    tooltip: 'Return Home',
                  ),
                )
              else
                const SizedBox(width: 48),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: AppTextStyles.header2.copyWith(
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: AppColors.alchemicalGold.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
