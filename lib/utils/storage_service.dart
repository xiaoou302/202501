import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class StorageService {
  static const String _keyGameState = 'game_state';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> saveGameState(GameState state) async {
    await init();
    try {
      final json = jsonEncode(state.toJson());
      return await _prefs!.setString(_keyGameState, json);
    } catch (e) {
      print('Error saving game state: $e');
      return false;
    }
  }

  Future<GameState> loadGameState() async {
    await init();
    try {
      final json = _prefs!.getString(_keyGameState);
      if (json == null) return GameState.initial();
      return GameState.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e) {
      print('Error loading game state: $e');
      return GameState.initial();
    }
  }

  Future<bool> clearAll() async {
    await init();
    return await _prefs!.clear();
  }
}
