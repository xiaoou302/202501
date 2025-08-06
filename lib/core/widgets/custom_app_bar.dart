import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Custom app bar optimized for notch/Dynamic Island displays
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: topPadding, // Dynamically adjust for notch/Dynamic Island
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.midnightBlue,
            AppColors.midnightBlue.withOpacity(0.0),
          ],
        ),
      ),
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Leading widget or empty container
            if (leading != null)
              leading!
            else if (title != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  title!,
                  style: const TextStyle(
                    color: AppColors.stardustWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            else
              const SizedBox(width: 40),

            // Actions
            if (actions != null && actions!.isNotEmpty)
              Row(children: actions!)
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
