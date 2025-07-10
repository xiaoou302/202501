import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application style constants
class AppStyles {
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16.0,
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyTextSmall = TextStyle(
    fontSize: 14.0,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    color: AppColors.textSecondary,
    height: 1.3,
    letterSpacing: 0.4,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static const TextStyle buttonTextSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
    letterSpacing: 0.25,
    height: 1.3,
  );

  // Dimensions
  static const double safeAreaTop =
      44.0; // Safe area top padding for modern devices
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusXLarge = 24.0;

  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(borderRadiusLarge),
    border: Border.all(color: AppColors.cardBorder),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: AppColors.buttonText,
    backgroundColor: AppColors.buttonPrimary,
    textStyle: buttonText,
    padding: const EdgeInsets.symmetric(
      horizontal: paddingLarge,
      vertical: paddingMedium,
    ),
    elevation: elevationMedium,
    shadowColor: AppColors.buttonShadowColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: AppColors.buttonText,
    backgroundColor: AppColors.buttonSecondary,
    textStyle: buttonText,
    padding: const EdgeInsets.symmetric(
      horizontal: paddingLarge,
      vertical: paddingMedium,
    ),
    elevation: elevationSmall,
    shadowColor: AppColors.shadowColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  );

  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: AppColors.accentPurple,
    textStyle: buttonText,
    padding: const EdgeInsets.symmetric(
      horizontal: paddingLarge,
      vertical: paddingMedium,
    ),
    side: const BorderSide(color: AppColors.accentPurple, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
  ).copyWith(
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return AppColors.accentPurple.withOpacity(0.04);
        }
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.pressed)) {
          return AppColors.accentPurple.withOpacity(0.12);
        }
        return null;
      },
    ),
  );

  // Input Decoration
  static InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: caption.copyWith(color: AppColors.textHint),
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: AppColors.accentPurple, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingMedium,
      ),
      isDense: true,
    );
  }

  // Tag Style
  static BoxDecoration tagDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(borderRadiusLarge),
      border: Border.all(
        color: color.withOpacity(0.3),
      ),
    );
  }
}
