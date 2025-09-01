import 'package:shared_preferences/shared_preferences.dart';

/// 音频管理类
///
/// 管理游戏中的音效和音乐
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  bool _soundEnabled = true;
  bool _musicEnabled = true;

  /// 初始化音频管理器
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
  }

  /// 获取音效是否启用
  bool get isSoundEnabled => _soundEnabled;

  /// 获取音乐是否启用
  bool get isMusicEnabled => _musicEnabled;

  /// 设置音效状态
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', enabled);
  }

  /// 设置音乐状态
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', enabled);
  }

  /// 播放音效
  void playSound(String soundName) {
    if (!_soundEnabled) return;

    // 在这里实现音效播放逻辑
    // 注意：这里只是一个占位实现，实际应用中可以使用 audioplayers 或 just_audio 等插件
    print('Playing sound: $soundName');
  }

  /// 播放背景音乐
  void playMusic(String musicName) {
    if (!_musicEnabled) return;

    // 在这里实现音乐播放逻辑
    print('Playing music: $musicName');
  }

  /// 停止背景音乐
  void stopMusic() {
    // 在这里实现停止音乐的逻辑
    print('Stopping music');
  }
}
