import 'package:intl/intl.dart';

/// 日期时间处理工具类
class DateTimeUtils {
  /// 格式化日期为 "yyyy-MM-dd"
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// 格式化日期为 "yyyy-MM-dd HH:mm"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  /// 格式化为相对时间（今天、明天、后天，或具体日期）
  static String formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == tomorrow) {
      return 'Tomorrow';
    } else if (targetDate == dayAfterTomorrow) {
      return 'Day after tomorrow';
    } else {
      return formatDate(dateTime);
    }
  }

  /// 格式化为相对时间（今天、明天、后天，或具体日期）加时间
  static String formatRelativeDateWithTime(DateTime dateTime) {
    final relativeDate = formatRelativeDate(dateTime);
    final time = DateFormat('HH:mm').format(dateTime);

    // 如果是今天、明天或后天，使用简短格式
    if (relativeDate == 'Today' ||
        relativeDate == 'Tomorrow' ||
        relativeDate == 'Day after tomorrow') {
      // 对于"Day after tomorrow"使用更简短的"In 2 days"
      String shortDate = relativeDate;
      if (relativeDate == 'Day after tomorrow') {
        shortDate = 'In 2 days';
      }
      return '$shortDate $time';
    }

    // 对于其他日期，使用短日期格式 MM/dd
    return '${DateFormat('MM/dd').format(dateTime)} $time';
  }

  /// 检查日期是否为今天
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// 检查日期是否为本周
  static bool isThisWeek(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekDay = now.weekday;
    final firstDayOfWeek = today.subtract(Duration(days: weekDay - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    return dateTime.isAfter(firstDayOfWeek.subtract(const Duration(days: 1))) &&
        dateTime.isBefore(lastDayOfWeek.add(const Duration(days: 1)));
  }
}
