import 'package:flutter/material.dart';

// ============================================================================
// COLORS (The Opus Magnum Color Scheme)
// ============================================================================

class AppColors {
  static const Color voidCharcoal = Color(0xFF1A1A1A);
  static const Color alabasterWhite = Color(0xFFE9E9E9);
  static const Color alchemicalGold = Color(0xFFD4AF37);
  static const Color neutralSteel = Color(0xFF7A7A7A);
  static const Color rubedoRed = Color(0xFFD13030);
}

// ============================================================================
// TYPOGRAPHY
// ============================================================================

class AppTextStyles {
  static const String serifFont = 'serif';
  static const String sansSerifFont = 'sans-serif';

  static const TextStyle header1 = TextStyle(
    fontFamily: serifFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.alabasterWhite,
  );

  static const TextStyle header2 = TextStyle(
    fontFamily: serifFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.alabasterWhite,
  );

  static const TextStyle header3 = TextStyle(
    fontFamily: serifFont,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.alchemicalGold,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: serifFont,
    fontSize: 18,
    color: AppColors.alabasterWhite,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: sansSerifFont,
    fontSize: 16,
    color: AppColors.alabasterWhite,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: sansSerifFont,
    fontSize: 14,
    color: AppColors.neutralSteel,
  );

  static const TextStyle clue = TextStyle(
    fontFamily: serifFont,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    color: AppColors.alchemicalGold,
    height: 1.6,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: sansSerifFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

// ============================================================================
// SPACING
// ============================================================================

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// ============================================================================
// BORDER RADIUS
// ============================================================================

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;

  static BorderRadius get smallRadius => BorderRadius.circular(sm);
  static BorderRadius get mediumRadius => BorderRadius.circular(md);
  static BorderRadius get largeRadius => BorderRadius.circular(lg);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(xl);
}

// ============================================================================
// ALCHEMY ACTIONS & MATERIALS
// ============================================================================

class AlchemyData {
  static const List<String> actions = [
    'dissolve',
    'combine',
    'calcify',
    'sublimate',
  ];

  static const List<String> materials = [
    'red_lion',
    'white_eagle',
    'sulfur',
    'mercury',
    'green_lion',
    'red_king',
    'white_queen',
  ];

  static String getActionLabel(String action) {
    switch (action) {
      case 'dissolve':
        return 'Dissolve';
      case 'combine':
        return 'Combine';
      case 'calcify':
        return 'Calcify';
      case 'sublimate':
        return 'Sublimate';
      default:
        return action;
    }
  }

  static String getMaterialLabel(String material) {
    switch (material) {
      case 'red_lion':
        return 'Red Lion';
      case 'white_eagle':
        return 'White Eagle';
      case 'sulfur':
        return 'Sulfur';
      case 'mercury':
        return 'Mercury';
      case 'green_lion':
        return 'Green Lion';
      case 'red_king':
        return 'Red King';
      case 'white_queen':
        return 'White Queen';
      default:
        return material;
    }
  }

  static IconData getActionIcon(String action) {
    switch (action) {
      case 'dissolve':
        return Icons.science;
      case 'combine':
        return Icons.link;
      case 'calcify':
        return Icons.local_fire_department;
      case 'sublimate':
        return Icons.landscape;
      default:
        return Icons.help;
    }
  }

  static IconData getMaterialIcon(String material) {
    switch (material) {
      case 'red_lion':
      case 'green_lion':
        return Icons.diamond;
      case 'white_eagle':
        return Icons.air;
      case 'sulfur':
        return Icons.circle;
      case 'mercury':
        return Icons.water_drop;
      case 'red_king':
        return Icons.star;
      case 'white_queen':
        return Icons.favorite;
      default:
        return Icons.help;
    }
  }

  static Color getMaterialColor(String material) {
    switch (material) {
      case 'red_lion':
      case 'red_king':
        return Colors.red.shade400;
      case 'white_eagle':
      case 'white_queen':
        return AppColors.alabasterWhite;
      case 'sulfur':
        return Colors.yellow.shade300;
      case 'mercury':
        return Colors.grey.shade400;
      case 'green_lion':
        return Colors.green.shade400;
      default:
        return AppColors.neutralSteel;
    }
  }
}

// ============================================================================
// TEXT CONTENT
// ============================================================================

class AppStrings {
  static const String appName = 'Cognifex';
  static const String subtitle = 'The Alchemist\'s Paradox';

  static const String homeTitle = 'Cognifex';
  static const String studyTitle = 'The Study';
  static const String laboratoryTitle = 'The Laboratory';
  static const String craftingLogTitle = 'Crafting Log';
  static const String revelationsTitle = 'Revelations';
  static const String introductionTitle = 'Introduction';
  static const String settingsTitle = 'Settings';

  static const String beginTheWork = 'Begin The Work';
  static const String lockRecipe = 'Lock Recipe & Enter Laboratory';
  static const String execute = 'Execute';
  static const String beginAnew = 'Begin Anew';
  static const String returnToStudy = 'Return to Study';
  static const String confirmEnter = 'Confirm & Enter';
  static const String resetProgress = 'Reset All Progress';

  static const String encryptedLog = 'Encrypted Log';
  static const String recipeSlate = 'Recipe Slate';

  static const String confirmationWarning =
      'Are you certain? Once in the Laboratory, there is no turning back. Your recipe will be locked.';
  static const String victoryMessage = 'The Great Work is Complete';
  static const String victoryDescription =
      '...the final substance cools in the crucible, emitting a perfect, ruby-like glow.';
  static const String victorySuccess =
      'You have succeeded. You have created the\n[ Philosopher\'s Stone ].';
  static const String failureMessage = 'A Fatal Error';
  static const String failureDescription =
      '...the unstable mixture boils over, emitting a piercing shriek. You do not even have time to step back.';
  static const String failureEnd =
      'The laboratory is consumed in the blast.\nYour work is at an end.';

  static const String selectAction = '[Select Action]';
  static const String selectMaterial = '[Select Material]';
}

// ============================================================================
// GAME CONFIGURATION
// ============================================================================

class GameConfig {
  static const int totalSteps = 12;
  static const Duration shakeAnimationDuration = Duration(milliseconds: 500);
  static const Duration pulseAnimationDuration = Duration(milliseconds: 1500);
}
