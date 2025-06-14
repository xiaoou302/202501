import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/drink.dart';
import 'constants.dart';

// 日期时间格式化
class DateTimeHelper {
  // 格式化时间为 HH:MM AM/PM
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // 格式化日期为 YYYY-MM-DD
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // 格式化日期和时间为 YYYY-MM-DD HH:MM
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  // 计算两个日期之间的天数差
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return (toDate.difference(fromDate).inHours / 24).round();
  }

  // 判断是否为同一天
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // 获取今天的开始时间
  static DateTime startOfDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // 获取今天的结束时间
  static DateTime endOfDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }
}

// 咖啡因计算辅助函数
class CaffeineHelper {
  // 计算咖啡因代谢百分比
  static double calculateMetabolismPercentage(List<Drink> drinks) {
    if (drinks.isEmpty) {
      return 100.0;
    }

    final now = DateTime.now();
    double remainingCaffeine = 0.0;

    for (final drink in drinks) {
      // 计算从饮用时间到现在经过的小时数
      final hoursElapsed = now.difference(drink.time).inMinutes / 60;

      // 使用咖啡因半衰期公式计算剩余咖啡因量
      final decayFactor = pow(
        0.5,
        hoursElapsed / CaffeineConstants.caffeineHalfLife,
      );
      final remaining = drink.caffeine * decayFactor;

      // 累加剩余咖啡因
      remainingCaffeine += remaining;
    }

    // 计算总咖啡因摄入量
    final totalCaffeine = drinks.fold(0, (sum, drink) => sum + drink.caffeine);

    // 计算代谢百分比
    final metabolismPercentage =
        100 - (remainingCaffeine / totalCaffeine * 100);

    // 确保百分比在0-100之间
    return metabolismPercentage.clamp(0.0, 100.0);
  }

  // 计算今日咖啡因摄入总量
  static int calculateTodayTotalIntake(List<Drink> todayDrinks) {
    return todayDrinks.fold(0, (sum, drink) => sum + drink.caffeine);
  }

  // 估计完全代谢时间
  static DateTime estimateFullMetabolismTime(List<Drink> drinks) {
    if (drinks.isEmpty) {
      return DateTime.now();
    }

    final now = DateTime.now();
    DateTime latestTime = now;

    for (final drink in drinks) {
      // 计算从饮用时间到现在经过的小时数
      final hoursElapsed = now.difference(drink.time).inMinutes / 60;

      // 计算剩余咖啡因量
      final decayFactor = pow(
        0.5,
        hoursElapsed / CaffeineConstants.caffeineHalfLife,
      );
      final remainingCaffeine = drink.caffeine * decayFactor;

      // 如果剩余咖啡因量大于1毫克，计算完全代谢时间
      if (remainingCaffeine > 1) {
        // 计算还需要多少个半衰期
        final halfLivesNeeded = log(remainingCaffeine) / log(0.5);

        // 计算完全代谢所需的小时数
        final hoursNeeded =
            halfLivesNeeded * CaffeineConstants.caffeineHalfLife;

        // 计算完全代谢的时间点
        final metabolismTime = now.add(
          Duration(minutes: (hoursNeeded * 60).round()),
        );

        // 更新最晚的代谢时间
        if (metabolismTime.isAfter(latestTime)) {
          latestTime = metabolismTime;
        }
      }
    }

    return latestTime;
  }
}

// 颜色辅助函数
class ColorHelper {
  // 从HSL创建颜色
  static Color fromHSL(int hue, double saturation, double lightness) {
    return HSLColor.fromAHSL(
      1.0,
      hue.toDouble(),
      saturation / 100,
      lightness / 100,
    ).toColor();
  }

  // 生成互补色
  static Color complementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    return HSLColor.fromAHSL(
      hsl.alpha,
      (hsl.hue + 180) % 360,
      hsl.saturation,
      hsl.lightness,
    ).toColor();
  }

  // 生成类似色
  static List<Color> analogous(Color color, {int count = 5}) {
    final hsl = HSLColor.fromColor(color);
    final List<Color> colors = [];

    final hueStep = 30;
    final startHue = (hsl.hue - (count ~/ 2) * hueStep) % 360;

    for (int i = 0; i < count; i++) {
      final newHue = (startHue + i * hueStep) % 360;
      colors.add(
        HSLColor.fromAHSL(
          hsl.alpha,
          newHue,
          hsl.saturation,
          hsl.lightness,
        ).toColor(),
      );
    }

    return colors;
  }

  // 生成三色组合
  static List<Color> triadic(Color color) {
    final hsl = HSLColor.fromColor(color);
    return [
      color,
      HSLColor.fromAHSL(
        hsl.alpha,
        (hsl.hue + 120) % 360,
        hsl.saturation,
        hsl.lightness,
      ).toColor(),
      HSLColor.fromAHSL(
        hsl.alpha,
        (hsl.hue + 240) % 360,
        hsl.saturation,
        hsl.lightness,
      ).toColor(),
    ];
  }

  // 调整亮度
  static Color adjustLightness(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return HSLColor.fromAHSL(
      hsl.alpha,
      hsl.hue,
      hsl.saturation,
      (hsl.lightness + amount).clamp(0.0, 1.0),
    ).toColor();
  }

  // 调整饱和度
  static Color adjustSaturation(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return HSLColor.fromAHSL(
      hsl.alpha,
      hsl.hue,
      (hsl.saturation + amount).clamp(0.0, 1.0),
      hsl.lightness,
    ).toColor();
  }
}

// UI辅助函数
class UIHelper {
  // 创建渐变装饰
  static BoxDecoration gradientDecoration({
    required Gradient gradient,
    double radius = AppSizes.cardRadius,
    Color? borderColor,
    double borderWidth = 1.0,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      border:
          borderColor != null
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
    );
  }

  // 创建玻璃效果装饰
  static BoxDecoration glassDecoration({
    double radius = AppSizes.cardRadius,
    Color? borderColor,
    double borderWidth = 1.0,
    Color backgroundColor = Colors.black,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      color: backgroundColor.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border:
          borderColor != null
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // 创建卡片装饰
  static BoxDecoration cardDecoration({
    double radius = AppSizes.cardRadius,
    Color backgroundColor = Colors.black,
    double opacity = 0.6,
  }) {
    return BoxDecoration(
      color: backgroundColor.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: AppColors.hologramPurple.withOpacity(0.15),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
