import 'package:shared_preferences/shared_preferences.dart';

/// 音频管理器
/// 负责管理游戏中的音乐和音效
class AudioManager {
  // 单例模式
  AudioManager._();
  static final AudioManager _instance = AudioManager._();
  static AudioManager get instance => _instance;

  // 音频设置
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.8;
  double _sfxVolume = 0.9;

  // Getters
  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  // 初始化
  Future<void> init() async {
    await _loadSettings();
  }

  // 加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
    _sfxEnabled = prefs.getBool('sfx_enabled') ?? true;
    _musicVolume = prefs.getDouble('music_volume') ?? 0.8;
    _sfxVolume = prefs.getDouble('sfx_volume') ?? 0.9;
  }

  // 保存设置
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', _musicEnabled);
    await prefs.setBool('sfx_enabled', _sfxEnabled);
    await prefs.setDouble('music_volume', _musicVolume);
    await prefs.setDouble('sfx_volume', _sfxVolume);
  }

  // 设置音乐开关
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    await _saveSettings();
    // TODO: 实现音乐播放/暂停逻辑
  }

  // 设置音效开关
  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
    await _saveSettings();
  }

  // 设置音乐音量
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume;
    await _saveSettings();
    // TODO: 实现音量调整逻辑
  }

  // 设置音效音量
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume;
    await _saveSettings();
  }

  // 播放音效
  void playSfx(String sfxName) {
    if (!_sfxEnabled) return;
    // TODO: 实现音效播放逻辑
  }

  // 播放背景音乐
  void playBackgroundMusic(String musicName) {
    if (!_musicEnabled) return;
    // TODO: 实现背景音乐播放逻辑
  }

  // 停止背景音乐
  void stopBackgroundMusic() {
    // TODO: 实现背景音乐停止逻辑
  }
}
