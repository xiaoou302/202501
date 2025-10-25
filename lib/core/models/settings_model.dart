/// Application settings model
class AppSettings {
  final double musicVolume;
  final double sfxVolume;
  final bool expertMode;
  final double fadeSpeed;
  final String language;

  const AppSettings({
    this.musicVolume = 0.75,
    this.sfxVolume = 0.9,
    this.expertMode = false,
    this.fadeSpeed = 1.0,
    this.language = 'English',
  });

  AppSettings copyWith({
    double? musicVolume,
    double? sfxVolume,
    bool? expertMode,
    double? fadeSpeed,
    String? language,
  }) {
    return AppSettings(
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      expertMode: expertMode ?? this.expertMode,
      fadeSpeed: fadeSpeed ?? this.fadeSpeed,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'musicVolume': musicVolume,
      'sfxVolume': sfxVolume,
      'expertMode': expertMode,
      'fadeSpeed': fadeSpeed,
      'language': language,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      musicVolume: (json['musicVolume'] as num?)?.toDouble() ?? 0.75,
      sfxVolume: (json['sfxVolume'] as num?)?.toDouble() ?? 0.9,
      expertMode: (json['expertMode'] as bool?) ?? false,
      fadeSpeed: (json['fadeSpeed'] as num?)?.toDouble() ?? 1.0,
      language: (json['language'] as String?) ?? 'English',
    );
  }
}
