import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pose_model.dart';

class PoseRepository {
  static const String _posesKey = 'poses';

  Future<List<Pose>> getPoses() async {
    final prefs = await SharedPreferences.getInstance();
    final posesJson = prefs.getString(_posesKey);
    
    if (posesJson == null) return [];
    
    final List<dynamic> decoded = json.decode(posesJson);
    return decoded.map((pose) => Pose.fromJson(pose)).toList();
  }

  Future<void> savePose(Pose pose) async {
    final poses = await getPoses();
    poses.insert(0, pose);
    
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(poses.map((pose) => pose.toJson()).toList());
    await prefs.setString(_posesKey, encoded);
  }

  Future<void> deletePose(String id) async {
    final poses = await getPoses();
    poses.removeWhere((pose) => pose.id == id);
    
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(poses.map((pose) => pose.toJson()).toList());
    await prefs.setString(_posesKey, encoded);
  }

  Future<void> likePose(String id) async {
    // Implement like functionality
  }
}
