import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ootd_record.dart';

class OOTDRepository {
  static const String _key = 'ootd_records';

  Future<List<OOTDRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => OOTDRecord.fromJson(json)).toList();
  }

  Future<void> saveRecord(OOTDRecord record) async {
    final records = await getRecords();
    
    // Remove existing record for the same date
    records.removeWhere((r) => 
      r.date.year == record.date.year &&
      r.date.month == record.date.month &&
      r.date.day == record.date.day
    );
    
    records.add(record);
    
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(records.map((r) => r.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> updateRecord(OOTDRecord record) async {
    final records = await getRecords();
    final index = records.indexWhere((r) => r.id == record.id);
    
    if (index != -1) {
      records[index] = record;
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(records.map((r) => r.toJson()).toList());
      await prefs.setString(_key, jsonString);
    }
  }

  Future<void> deleteRecord(String id) async {
    final records = await getRecords();
    records.removeWhere((r) => r.id == id);
    
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(records.map((r) => r.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<OOTDRecord?> getRecordByDate(DateTime date) async {
    final records = await getRecords();
    try {
      return records.firstWhere((r) =>
        r.date.year == date.year &&
        r.date.month == date.month &&
        r.date.day == date.day
      );
    } catch (e) {
      return null;
    }
  }

  // 模拟内容审核 - 实际应用中应该调用后端API
  Future<Map<String, dynamic>> reviewContent({
    required String imagePath,
    required List<String> tags,
    String? note,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 2));
    
    // 简单的内容审核规则（实际应该使用AI或人工审核）
    // 这里只是演示，实际应该调用后端审核服务
    
    // 检查是否包含敏感词（示例）
    final sensitiveWords = ['违规', 'sensitive', 'inappropriate'];
    final allText = '${tags.join(' ')} ${note ?? ''}';
    
    for (var word in sensitiveWords) {
      if (allText.toLowerCase().contains(word.toLowerCase())) {
        return {
          'approved': false,
          'reason': 'Content contains inappropriate keywords',
        };
      }
    }
    
    // 模拟随机审核结果（90%通过率）
    final random = DateTime.now().millisecond % 10;
    if (random < 9) {
      return {
        'approved': true,
        'reason': null,
      };
    } else {
      return {
        'approved': false,
        'reason': 'Content does not meet community guidelines',
      };
    }
  }

  // 获取待审核的记录
  Future<List<OOTDRecord>> getPendingRecords() async {
    final records = await getRecords();
    return records.where((r) => r.reviewStatus == ReviewStatus.pending).toList();
  }

  // 获取已通过审核的记录
  Future<List<OOTDRecord>> getApprovedRecords() async {
    final records = await getRecords();
    return records.where((r) => r.reviewStatus == ReviewStatus.approved).toList();
  }
}
