import 'package:flutter/material.dart';
import 'app_strings.dart';

class AppDateUtils {
  // Calculate days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }

  // Calculate days until a specific date
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    // If the date has passed, calculate to next year's date
    if (targetDate.isBefore(today)) {
      final nextYear = DateTime(
        targetDate.year + 1,
        targetDate.month,
        targetDate.day,
      );
      return daysBetween(today, nextYear);
    }

    return daysBetween(today, targetDate);
  }

  // Format date as string (year-month-day)
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  // Format date range as string
  static String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start)} to ${formatDate(end)} (${daysBetween(start, end)} ${AppStrings.daysLabel})';
  }

  // Calculate love days
  static int calculateLoveDays(DateTime anniversaryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(
      anniversaryDate.year,
      anniversaryDate.month,
      anniversaryDate.day,
    );

    return daysBetween(startDate, today);
  }

  // Calculate love years and remaining days
  static Map<String, int> calculateLoveYearsAndDays(DateTime anniversaryDate) {
    final days = calculateLoveDays(anniversaryDate);
    final years = days ~/ 365;
    final remainingDays = days % 365;

    return {'years': years, 'days': remainingDays};
  }

  // Get next anniversary date
  static DateTime getNextAnniversaryDate(DateTime anniversaryDate) {
    final now = DateTime.now();
    final anniversaryThisYear = DateTime(
      now.year,
      anniversaryDate.month,
      anniversaryDate.day,
    );

    if (anniversaryThisYear.isAfter(now)) {
      return anniversaryThisYear;
    } else {
      return DateTime(now.year + 1, anniversaryDate.month, anniversaryDate.day);
    }
  }
}
