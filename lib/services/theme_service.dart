import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'isRedSafelight';
  bool _isRedSafelight = false;

  bool get isRedSafelight => _isRedSafelight;

  ThemeData get currentTheme =>
      _isRedSafelight ? AppTheme.redSafelightTheme : AppTheme.normalTheme;

  ThemeService() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isRedSafelight = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isRedSafelight = !_isRedSafelight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isRedSafelight);
    notifyListeners();
  }
}
