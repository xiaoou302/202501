import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

/// App theme configuration
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.midnightBlue,
      primaryColor: AppColors.stardustWhite,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.goldenHighlight,
        secondary: AppColors.fieryRed,
        background: AppColors.midnightBlue,
        surface: AppColors.midnightBlue,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.midnightBlue,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.stardustWhite),
        bodyMedium: TextStyle(color: AppColors.stardustWhite),
        titleLarge: TextStyle(color: AppColors.stardustWhite),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.1),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.stardustWhite),
      // Use cardColor for background color
      cardColor: Colors.grey.shade900.withOpacity(0.5),
      // Add shape to cards
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      cardTheme: ThemeData.dark().cardTheme.copyWith(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.borderColor),
            ),
          ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade900,
        contentTextStyle: const TextStyle(color: AppColors.stardustWhite),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.midnightBlue.withOpacity(0.8),
        selectedItemColor: AppColors.goldenHighlight,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.goldenHighlight,
      ),
    );
  }
}
