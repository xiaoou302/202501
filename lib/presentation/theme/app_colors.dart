import 'package:flutter/material.dart';

/// Ancient Book - Forgotten Tome color palette
/// 古籍《遗忘之书》配色方案
class AppColors {
  // Parchment & Paper colors (羊皮纸色系)
  static const Color parchmentLight = Color(0xFFFFF8E7); // 浅羊皮纸色
  static const Color parchmentMedium = Color(0xFFF5E6D3); // 中羊皮纸色
  static const Color parchmentDark = Color(0xFFE8D5B7); // 深羊皮纸色

  // Ink colors (墨水色系)
  static const Color inkBlack = Color(0xFF2C1810); // 古墨色
  static const Color inkBrown = Color(0xFF5D4037); // 棕墨色
  static const Color inkFaded = Color(0xFF8D6E63); // 褪色墨水

  // Magic & Mystery colors (魔法与神秘色系)
  static const Color magicGold = Color(0xFFD4AF37); // 神秘金色
  static const Color magicBlue = Color(0xFF4A90E2); // 魔法蓝
  static const Color magicPurple = Color(0xFF9B59B6); // 神秘紫
  static const Color arcaneGreen = Color(0xFF27AE60); // 奥术绿

  // Accent colors (强调色)
  static const Color glowAmber = Color(0xFFFFB74D); // 琥珀光晕
  static const Color glowCyan = Color(0xFF4DD0E1); // 青色光晕
  static const Color warningRed = Color(0xFFE74C3C); // 警告红

  // Text colors (文字色系)
  static const Color textPrimary = Color(0xFF2C1810); // 主文字色
  static const Color textSecondary = Color(0xFF5D4037); // 次文字色
  static const Color textTertiary = Color(0xFF8D6E63); // 三级文字色
  static const Color textGolden = Color(0xFFD4AF37); // 金色文字

  // UI Element colors (UI元素色系)
  static const Color borderLight = Color(0xFFD7C4A8); // 浅边框
  static const Color borderMedium = Color(0xFFBCA98C); // 中边框
  static const Color shadowBrown = Color(0xFF3E2723); // 棕色阴影

  // Status colors (状态色)
  static const Color successGreen = Color(0xFF27AE60);
  static const Color dangerRed = Color(0xFFE74C3C);
  static const Color infoBlue = Color(0xFF4A90E2);

  // Legacy colors (保持兼容)
  static const Color bgLight = parchmentLight;
  static const Color bgMedium = parchmentMedium;
  static const Color textDark = textPrimary;
  static const Color accentBlue = magicBlue;
  static const Color accentOrange = glowAmber;
  static const Color accentPurple = magicPurple;
  static const Color textMuted = textTertiary;
  static const Color darkBackground = Color(0xFF1A1410);

  // Gradient colors (渐变色组合)
  static const List<Color> parchmentGradient = [
    parchmentLight,
    parchmentMedium,
  ];
  static const List<Color> goldGradient = [
    Color(0xFFFFD700),
    Color(0xFFB8860B),
  ];
  static const List<Color> magicGradient = [magicBlue, magicPurple];
  static const List<Color> mysteryGradient = [
    Color(0xFF1A1410),
    Color(0xFF2C1810),
  ];

  // Glow colors (光晕效果)
  static Color magicGlow = magicBlue.withOpacity(0.5);
  static Color goldGlow = magicGold.withOpacity(0.6);
  static Color amberGlow = glowAmber.withOpacity(0.5);
  static Color arcaneGlow = arcaneGreen.withOpacity(0.4);

  // Old compatibility (旧版兼容)
  static Color accentGlow = magicGlow;
  static Color orangeGlow = amberGlow;
}
