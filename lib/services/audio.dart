import '../core/utils/audio_manager.dart';

/// 音频服务
/// 提供游戏中所有音频播放功能
class AudioService {
  // 单例模式
  AudioService._();
  static final AudioService _instance = AudioService._();
  static AudioService get instance => _instance;

  // 音频管理器
  final AudioManager _audioManager = AudioManager.instance;

  // 音效类型
  static const String sfxTap = 'tap';
  static const String sfxMatch = 'match';
  static const String sfxPlexiMatch = 'plexi_match';
  static const String sfxTransmute = 'transmute';
  static const String sfxLevelComplete = 'level_complete';
  static const String sfxLevelFail = 'level_fail';
  static const String sfxUnlock = 'unlock';

  // 音乐类型
  static const String musicMenu = 'menu';
  static const String musicGame = 'game';
  static const String musicVictory = 'victory';

  // 初始化
  Future<void> init() async {
    await _audioManager.init();
  }

  // 播放音效
  void playSfx(String sfxName) {
    _audioManager.playSfx(sfxName);
  }

  // 播放背景音乐
  void playMusic(String musicName) {
    _audioManager.playBackgroundMusic(musicName);
  }

  // 停止背景音乐
  void stopMusic() {
    _audioManager.stopBackgroundMusic();
  }

  // 播放点击音效
  void playTapSfx() {
    playSfx(sfxTap);
  }

  // 播放匹配音效
  void playMatchSfx() {
    playSfx(sfxMatch);
  }

  // 播放完美匹配音效
  void playPlexiMatchSfx() {
    playSfx(sfxPlexiMatch);
  }

  // 播放嬗变音效
  void playTransmuteSfx() {
    playSfx(sfxTransmute);
  }

  // 播放关卡完成音效
  void playLevelCompleteSfx() {
    playSfx(sfxLevelComplete);
  }

  // 播放关卡失败音效
  void playLevelFailSfx() {
    playSfx(sfxLevelFail);
  }

  // 播放解锁音效
  void playUnlockSfx() {
    playSfx(sfxUnlock);
  }

  // 播放菜单音乐
  void playMenuMusic() {
    playMusic(musicMenu);
  }

  // 播放游戏音乐
  void playGameMusic() {
    playMusic(musicGame);
  }

  // 播放胜利音乐
  void playVictoryMusic() {
    playMusic(musicVictory);
  }

  // 获取音乐开关状态
  bool get isMusicEnabled => _audioManager.musicEnabled;

  // 获取音效开关状态
  bool get isSfxEnabled => _audioManager.sfxEnabled;

  // 获取音乐音量
  double get musicVolume => _audioManager.musicVolume;

  // 获取音效音量
  double get sfxVolume => _audioManager.sfxVolume;

  // 设置音乐开关
  Future<void> setMusicEnabled(bool enabled) async {
    await _audioManager.setMusicEnabled(enabled);
  }

  // 设置音效开关
  Future<void> setSfxEnabled(bool enabled) async {
    await _audioManager.setSfxEnabled(enabled);
  }

  // 设置音乐音量
  Future<void> setMusicVolume(double volume) async {
    await _audioManager.setMusicVolume(volume);
  }

  // 设置音效音量
  Future<void> setSfxVolume(double volume) async {
    await _audioManager.setSfxVolume(volume);
  }
}
