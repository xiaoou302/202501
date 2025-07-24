class BreathMode {
  final String id;
  final String title;
  final List<int> steps; // e.g., [4, 7, 8] for anxiety mode
  final List<String> labels; // e.g., ["Inhale", "Hold", "Exhale"]
  final String colorHex;
  final int totalRounds;
  final String icon;
  final String description;

  BreathMode({
    required this.id,
    required this.title,
    required this.steps,
    required this.labels,
    required this.colorHex,
    required this.totalRounds,
    required this.icon,
    required this.description,
  });

  // Predefined breathing modes
  static BreathMode anxiety() {
    return BreathMode(
      id: 'anxiety',
      title: 'Reduce Anxiety',
      steps: [4, 7, 8],
      labels: ['Inhale', 'Hold', 'Exhale'],
      colorHex: '#4FC1B9',
      totalRounds: 8,
      icon: 'water',
      description: '4-7-8 Breathing',
    );
  }

  static BreathMode focus() {
    return BreathMode(
      id: 'focus',
      title: 'Improve Focus',
      steps: [4, 4, 4, 4],
      labels: ['Inhale', 'Hold', 'Exhale', 'Hold'],
      colorHex: '#D97C29',
      totalRounds: 10,
      icon: 'crosshairs',
      description: 'Box Breathing',
    );
  }

  static BreathMode relax() {
    return BreathMode(
      id: 'relax',
      title: 'Quick Relaxation',
      steps: [5, 5, 5],
      labels: ['Inhale', 'Hold', 'Exhale'],
      colorHex: '#9B5DE5',
      totalRounds: 6,
      icon: 'moon',
      description: '5-5-5 Breathing',
    );
  }

  static BreathMode energy() {
    return BreathMode(
      id: 'energy',
      title: 'Energy Boost',
      steps: [2, 1, 2],
      labels: ['Quick Inhale', 'Hold', 'Quick Exhale'],
      colorHex: '#FEE440',
      totalRounds: 15,
      icon: 'sun',
      description: 'Rapid Alternate Breathing',
    );
  }

  static BreathMode sleep() {
    return BreathMode(
      id: 'sleep',
      title: 'Deep Sleep Aid',
      steps: [5, 8, 10],
      labels: ['Slow Inhale', 'Gentle Hold', 'Deep Exhale'],
      colorHex: '#5a99e0',
      totalRounds: 10,
      icon: 'bed',
      description: 'Slow Deep Breathing',
    );
  }

  // Get all breathing modes
  static List<BreathMode> getAllModes() {
    return [anxiety(), focus(), relax(), energy(), sleep()];
  }
}
