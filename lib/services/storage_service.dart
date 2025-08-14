import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mission.dart';

/// Mission type enum
enum MissionType {
  plan, // Plan missions in the mission hub
  luggage, // Trip missions in the smart luggage
}

/// Storage service, responsible for data persistence
class StorageService {
  static const String _planMissionsKey = 'plan_missions';
  static const String _luggageMissionsKey = 'luggage_missions';

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// Get storage key based on mission type
  String _getKeyForType(MissionType type) {
    switch (type) {
      case MissionType.plan:
        return _planMissionsKey;
      case MissionType.luggage:
        return _luggageMissionsKey;
    }
  }

  /// Save mission to local storage
  Future<bool> saveMission(Mission mission, MissionType type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final missions = await getMissions(type);

      // Update existing mission or add new mission
      final index = missions.indexWhere((m) => m.id == mission.id);
      if (index >= 0) {
        missions[index] = mission;
      } else {
        missions.add(mission);
      }

      // Save to storage
      final missionJsonList = missions
          .map((m) => jsonEncode(m.toJson()))
          .toList();
      return await prefs.setStringList(_getKeyForType(type), missionJsonList);
    } catch (e) {
      print('Error saving mission: $e');
      return false;
    }
  }

  /// Get all missions from local storage
  Future<List<Mission>> getMissions(MissionType type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final missionJsonList = prefs.getStringList(_getKeyForType(type)) ?? [];

      return missionJsonList
          .map((jsonStr) => Mission.fromJson(jsonDecode(jsonStr)))
          .toList();
    } catch (e) {
      print('Error getting missions: $e');
      return [];
    }
  }

  /// Get a single mission
  Future<Mission?> getMission(String id, MissionType type) async {
    try {
      final missions = await getMissions(type);
      return missions.firstWhere((mission) => mission.id == id);
    } catch (e) {
      print('Error getting single mission: $e');
      return null;
    }
  }

  /// Delete mission
  Future<bool> deleteMission(String id, MissionType type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final missions = await getMissions(type);

      missions.removeWhere((mission) => mission.id == id);

      final missionJsonList = missions
          .map((m) => jsonEncode(m.toJson()))
          .toList();
      return await prefs.setStringList(_getKeyForType(type), missionJsonList);
    } catch (e) {
      print('Error deleting mission: $e');
      return false;
    }
  }

  /// Migrate old data (if any)
  Future<void> migrateOldData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldMissionJsonList = prefs.getStringList('missions') ?? [];

      if (oldMissionJsonList.isNotEmpty) {
        // Convert old data to mission objects
        final oldMissions = oldMissionJsonList
            .map((jsonStr) => Mission.fromJson(jsonDecode(jsonStr)))
            .toList();

        // Categorize and save missions
        final planMissions = <Mission>[];
        final luggageMissions = <Mission>[];

        for (final mission in oldMissions) {
          // Categorize based on mission characteristics
          if (mission.title.contains('旅行') ||
              mission.title.contains('旅游') ||
              mission.title.contains('行程')) {
            luggageMissions.add(mission);
          } else {
            planMissions.add(mission);
          }
        }

        // Save categorized missions
        if (planMissions.isNotEmpty) {
          final planJsonList = planMissions
              .map((m) => jsonEncode(m.toJson()))
              .toList();
          await prefs.setStringList(_planMissionsKey, planJsonList);
        }

        if (luggageMissions.isNotEmpty) {
          final luggageJsonList = luggageMissions
              .map((m) => jsonEncode(m.toJson()))
              .toList();
          await prefs.setStringList(_luggageMissionsKey, luggageJsonList);
        }

        // Delete old data
        await prefs.remove('missions');
      }
    } catch (e) {
      print('Error migrating old data: $e');
    }
  }
}
