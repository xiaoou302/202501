import 'package:flutter/material.dart';

class AppTheme {
  // Main colors
  static const Color darkBg = Color(0xFF121212);
  static const Color darkBlue = Color(0xFF1A1A2E);
  static const Color deepPurple = Color(0xFF3F0071);
  static const Color accentPurple = Color(0xFF9500FF);
  static const Color lightPurple = Color(0xFFBF5AF2);

  // Form styling
  static const double inputBorderRadius = 12.0;
  static const double inputVerticalPadding = 16.0;

  // Text styles with system fonts as fallback
  static TextStyle get headingStyle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        fontFamily: 'SF Pro Display',
      );

  static TextStyle get titleStyle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        fontFamily: 'SF Pro Display',
      );

  static TextStyle get subtitleStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      );

  static TextStyle get bodyStyle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.1,
        fontFamily: 'SF Pro Text',
      );

  static TextStyle get buttonStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        fontFamily: 'SF Pro Display',
      );

  // Input decoration theme
  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: darkBlue.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: inputVerticalPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(color: deepPurple.withOpacity(0.5), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(color: deepPurple.withOpacity(0.5), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: accentPurple, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontFamily: 'SF Pro Text',
      ),
      hintStyle: TextStyle(
        color: Colors.grey.withOpacity(0.6),
        fontSize: 14,
        fontFamily: 'SF Pro Text',
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
        fontFamily: 'SF Pro Text',
      ),
      suffixIconColor: accentPurple,
      prefixIconColor: accentPurple,
    );
  }

  // Date picker decoration
  static BoxDecoration get datePickerDecoration {
    return BoxDecoration(
      color: darkBlue.withOpacity(0.5),
      borderRadius: BorderRadius.circular(inputBorderRadius),
      border: Border.all(color: deepPurple.withOpacity(0.5), width: 1.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Custom button style
  static ButtonStyle get elevatedButtonStyle {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 14.0,
      ),
      backgroundColor: deepPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
      ),
      elevation: 4,
      textStyle: buttonStyle,
    );
  }

  // Checkbox theme
  static CheckboxThemeData get checkboxTheme {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return accentPurple;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      side: BorderSide(color: accentPurple.withOpacity(0.8), width: 1.5),
    );
  }

  // Radio button theme
  static RadioThemeData get radioTheme {
    return RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return accentPurple;
        }
        return Colors.grey;
      }),
    );
  }

  // Switch theme
  static SwitchThemeData get switchTheme {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return accentPurple;
        }
        return Colors.grey.shade400;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return accentPurple.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    );
  }

  // Create the theme data
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark();

    return baseTheme.copyWith(
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: accentPurple,
        secondary: lightPurple,
        surface: darkBlue,
        background: darkBg,
      ),
      textTheme: baseTheme.textTheme.apply(
        fontFamily: 'SF Pro Text',
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(
        fontFamily: 'SF Pro Text',
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: inputDecorationTheme,
      checkboxTheme: checkboxTheme,
      radioTheme: radioTheme,
      switchTheme: switchTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPurple,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBlue,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'SF Pro Display',
        ),
      ),
      cardTheme: CardTheme(
        color: darkBlue,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: darkBlue,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SF Pro Display',
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          fontFamily: 'SF Pro Text',
        ),
      ),
    );
  }
}
