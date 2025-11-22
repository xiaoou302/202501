class FormatUtils {
  static String formatTime(int seconds) {
    return '${seconds}s';
  }

  static String formatScore(int score) {
    return score.toString();
  }

  static String formatPairs(int matched, int total) {
    return '$matched/$total';
  }
}
