import 'package:flutter/material.dart';

// 应用颜色
class AppColors {
  // 主题颜色
  static const cosmicBlack = Color(0xFF000000);
  static const deepSpace = Color(0xFF0a0a1f);
  static const nebulaPurple = Color(0xFF2a0a3a);
  static const electricBlue = Color(0xFF00e5ff);
  static const hologramPurple = Color(0xFFb967ff);
  static const errorPink = Color(0xFFff4d94);
  static const textColor = Color(0xFFe0e0ff);

  // 渐变色
  static const primaryGradient = LinearGradient(
    colors: [electricBlue, hologramPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [hologramPurple, errorPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundGradient = LinearGradient(
    colors: [deepSpace, nebulaPurple],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// 应用尺寸
class AppSizes {
  static const double cardRadius = 24.0;
  static const double buttonRadius = 20.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
}

// 应用字符串
class AppStrings {
  // App name
  static const appName = 'Luxanvoryx';

  // Bottom navigation bar
  static const String navCaffeine = 'Caffeine';
  static const String navCoupons = 'Coupons';
  static const String navColors = 'Colors';
  static const String navSettings = 'Settings';

  // Caffeine tracker
  static const String caffeineTitle = 'Caffeine Tracker';
  static const String caffeineMetabolizing = 'Metabolism Progress';
  static const String caffeineEstimatedTime = 'Estimated full metabolism time';
  static const String caffeineDailyIntake = 'Today\'s Intake';
  static const String caffeineSafeRange = 'Safe range: 0-400mg';
  static const String caffeineMaxDaily = 'Daily max: 400mg';
  static const String caffeineDrinkRecords = 'Today\'s Drinks';

  // Coupon management
  static const String couponTitle = 'Coupon Manager';
  static const String couponDining = 'Dining';
  static const String couponShopping = 'Shopping';
  static const String couponTravel = 'Travel';
  static const String couponEntertainment = 'Entertainment';
  static const String couponHealth = 'Health';
  static const String couponEducation = 'Education';
  static const String couponExpiringSoon = 'Expiring Soon';
  static const String couponDaysToExpire = 'days';
  static const String couponScan = 'Scan Coupon';
  static const String couponAdd = 'Add';
  static const String couponEdit = 'Edit';
  static const String couponDelete = 'Delete';
  static const String couponUse = 'Use';
  static const String couponUsed = 'Used';
  static const String couponExpired = 'Expired';
  static const String couponActive = 'Active';
  static const String couponHistory = 'History';
  static const String couponNoExpiringSoon = 'No expiring coupons';
  static const String couponNoCoupons = 'No coupons available';

  // Color generator
  static const String colorTitle = 'Color Generator';
  static const String colorHSLValues = 'HSL Values';
  static const String colorHue = 'Hue';
  static const String colorSaturation = 'Saturation';
  static const String colorLightness = 'Lightness';
  static const String colorSchemes = 'Color Schemes';
  static const String colorRandomGenerate = 'Random Generate';
  static const String colorSave = 'Save';
  static const String colorSaveScheme = 'Save Color Scheme';
  static const String colorSchemeName = 'Color Scheme Name';
  static const String colorCancel = 'Cancel';
  static const String colorExport = 'Export';
  static const String colorExportTitle = 'Export Color';
  static const String colorCopyToClipboard =
      'Click any value to copy to clipboard';
  static const String colorCopied = 'Copied: ';
  static const String colorHistory = 'History';
  static const String colorFavorites = 'Favorites';
  static const String colorNoSavedSchemes = 'No saved color schemes';
  static const String colorNoFavorites = 'No favorite color schemes';
  static const String colorNoHistory = 'No recent color schemes';
  static const String colorRecentSchemes = 'Recent Schemes';
  static const String colorSavedSchemes = 'Saved Schemes';
  static const String colorPalettes = 'Color Palettes';
  static const String colorMonochromatic = 'Monochromatic';
  static const String colorAnalogous = 'Analogous';
  static const String colorComplementary = 'Complementary';
  static const String colorTriadic = 'Triadic';
  static const String colorTetradic = 'Tetradic';
  static const String colorSplitComplementary = 'Split Complementary';
  static const String colorDelete = 'Delete';
  static const String colorEdit = 'Edit';
  static const String colorAddToFavorites = 'Add to Favorites';
  static const String colorRemoveFromFavorites = 'Remove from Favorites';
  static const String colorRandomPastel = 'Random Pastel';
  static const String colorRandomVibrant = 'Random Vibrant';
  static const String colorRandomDark = 'Random Dark';
}

// 咖啡因相关常量
class CaffeineConstants {
  // 每日安全摄入量 (mg)
  static const int safeDailyIntake = 400;

  // 咖啡因半衰期 (小时)
  static const double caffeineHalfLife = 5.0;

  // 常见饮品的咖啡因含量 (mg/ml)
  static const Map<String, double> caffeineContent = {
    'Americano': 0.5,
    'Espresso': 2.0,
    'Latte': 0.3,
    'Black Tea': 0.2,
    'Green Tea': 0.1,
    'Energy Drink': 0.3,
    'Cola': 0.1,
  };

  // 饮品图标
  static const Map<String, String> drinkIcons = {
    'Americano': 'mug-hot',
    'Espresso': 'mug-hot',
    'Latte': 'mug-hot',
    'Black Tea': 'mug-hot',
    'Green Tea': 'glass',
    'Energy Drink': 'bolt',
    'Cola': 'glass',
  };

  // 饮品分类
  static const Map<String, String> drinkCategories = {
    'Americano': 'Coffee',
    'Espresso': 'Coffee',
    'Latte': 'Coffee',
    'Black Tea': 'Tea',
    'Green Tea': 'Tea',
    'Energy Drink': 'Energy Drinks',
    'Cola': 'Soda',
  };
}
