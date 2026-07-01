class NotificationService {
  static Future<void> scheduleReminder(DateTime time) async {
    // Simulated notification scheduling
    print("Reminder scheduled for ${time.toIso8601String()}");
  }
}
