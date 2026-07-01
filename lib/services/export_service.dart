import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<void> exportText(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      print("Error exporting: $e");
    }
  }
}
