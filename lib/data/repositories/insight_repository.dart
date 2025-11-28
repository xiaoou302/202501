import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/insight_model.dart';

class InsightRepository {
  static const String _insightsKey = 'insights';

  Future<List<Insight>> getInsights() async {
    final prefs = await SharedPreferences.getInstance();
    final insightsJson = prefs.getString(_insightsKey);
    
    if (insightsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(insightsJson);
    return decoded.map((insight) => Insight.fromJson(insight)).toList();
  }

  Future<void> saveInsight(Insight insight) async {
    final insights = await getInsights();
    insights.insert(0, insight);
    
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(insights.map((insight) => insight.toJson()).toList());
    await prefs.setString(_insightsKey, encoded);
  }

  Future<void> deleteInsight(String id) async {
    final insights = await getInsights();
    insights.removeWhere((insight) => insight.id == id);
    
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(insights.map((insight) => insight.toJson()).toList());
    await prefs.setString(_insightsKey, encoded);
  }
}
