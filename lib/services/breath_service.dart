import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breath_mode.dart';

class BreathService {
  // Current breathing session state
  BreathMode? _currentMode;
  int _currentStep = 0;
  int _currentRound = 1;
  int _stepCountdown = 0;
  Timer? _timer;
  bool _isActive = false;
  bool _isSoundEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isBackgroundMusicEnabled = false;

  // Session statistics
  int _totalSessionsCompleted = 0;
  int _totalMinutesPracticed = 0;
  DateTime? _lastSessionDate; //ssssssss

  // Callbacks for UI updates
  Function(String)? onInstructionChange;
  Function(int)? onTimerChange;
  Function(int, int)? onRoundChange;
  Function(double)? onProgressChange;
  Function()? onSessionComplete;

  // Initialize service
  Future<void> initialize() async {
    await _loadSettings();
    await _loadStatistics();
  }

  // Load user settings
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;
    _isVibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    _isBackgroundMusicEnabled =
        prefs.getBool('background_music_enabled') ?? false; //sdasdasdasd
  }

  // Save user settings
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _isSoundEnabled);
    await prefs.setBool('vibration_enabled', _isVibrationEnabled);
    await prefs.setBool('background_music_enabled', _isBackgroundMusicEnabled);
  }

  // Load statistics
  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    _totalSessionsCompleted = prefs.getInt('total_sessions') ?? 0;
    _totalMinutesPracticed = prefs.getInt('total_minutes') ?? 0;
    final lastSessionStr = prefs.getString('last_session_date');
    _lastSessionDate =
        lastSessionStr != null ? DateTime.parse(lastSessionStr) : null;
  }

  // Save statistics
  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_sessions', _totalSessionsCompleted);
    await prefs.setInt('total_minutes', _totalMinutesPracticed);
    if (_lastSessionDate != null) {
      await prefs.setString(
        'last_session_date',
        _lastSessionDate!.toIso8601String(),
      );
    }
  }

  // Toggle settings
  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    await _saveSettings();
  }

  Future<void> toggleVibration() async {
    _isVibrationEnabled = !_isVibrationEnabled;
    await _saveSettings();
  }

  Future<void> toggleBackgroundMusic() async {
    _isBackgroundMusicEnabled = !_isBackgroundMusicEnabled;
    await _saveSettings();
  }

  // Get settings
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;
  bool get isBackgroundMusicEnabled => _isBackgroundMusicEnabled;

  // Get statistics
  int get totalSessionsCompleted => _totalSessionsCompleted;
  int get totalMinutesPracticed => _totalMinutesPracticed;
  DateTime? get lastSessionDate => _lastSessionDate;

  // Provide feedback
  void _provideFeedback() async {
    if (_isVibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
    if (_isSoundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  // Start a breathing session
  void startBreathing(BreathMode mode) {
    _currentMode = mode;
    _currentStep = 0;
    _currentRound = 1;
    _isActive = true;
    _updateStep();
  }

  // Update the current step
  void _updateStep() {
    if (_currentMode == null || !_isActive) return;

    if (_currentRound > _currentMode!.totalRounds) {
      _completeSession();
      return;
    }

    final totalStepTime = _currentMode!.steps[_currentStep];
    _stepCountdown = totalStepTime;

    // Provide feedback on step change
    _provideFeedback();

    // Notify UI of the new step
    if (onInstructionChange != null) {
      onInstructionChange!(_currentMode!.labels[_currentStep]);
    }

    if (onRoundChange != null) {
      onRoundChange!(_currentRound, _currentMode!.totalRounds);
    }

    if (onProgressChange != null) {
      onProgressChange!(0.0); // Reset progress
    }

    // Start the timer for this step
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _stepCountdown--;

      // Update progress
      if (onProgressChange != null && totalStepTime > 0) {
        final progress = 1.0 - (_stepCountdown / totalStepTime);
        onProgressChange!(progress);
      }

      // Update timer display
      if (onTimerChange != null) {
        onTimerChange!(_stepCountdown);
      }

      if (_stepCountdown < 0) {
        timer.cancel();
        _currentStep++;

        // Move to next round if needed
        if (_currentStep >= _currentMode!.steps.length) {
          _currentStep = 0;
          _currentRound++;
        }

        _updateStep();
      }
    });
  }

  // End the breathing session
  void endBreathing() {
    _timer?.cancel();
    _isActive = false;
  }

  // Complete the session
  void _completeSession() async {
    _timer?.cancel();
    _isActive = false;

    // Update statistics
    _totalSessionsCompleted++;
    if (_currentMode != null) {
      final sessionMinutes = (_currentMode!.totalRounds *
              _currentMode!.steps.reduce((a, b) => a + b)) ~/
          60;
      _totalMinutesPracticed += sessionMinutes;
    }
    _lastSessionDate = DateTime.now();
    await _saveStatistics();

    if (onSessionComplete != null) {
      onSessionComplete!();
    }
  }

  // Dispose resources
  void dispose() {
    _timer?.cancel();
    _isActive = false;
  }

  // Check if a session is active
  bool get isActive => _isActive;

  // Get current mode
  BreathMode? get currentMode => _currentMode;
}
