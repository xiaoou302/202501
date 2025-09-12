import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'services/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage service
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);

  // Initialize game data on first run
  if (await storageService.isFirstRun()) {
    await storageService.initializeGameData();
  }

  runApp(const BlokkoApp());
}
