class UserSettings {
  bool steamNoiseEnabled;
  bool darkMode;
  String defaultBrewer;
  String defaultGrinder;

  UserSettings({
    this.steamNoiseEnabled = false,
    this.darkMode = false,
    this.defaultBrewer = 'V60',
    this.defaultGrinder = 'Comandante C40',
  });
}
