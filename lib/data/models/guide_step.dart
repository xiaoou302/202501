class GuideResult {
  final String description;
  final String material;
  final List<GuideStep> steps;

  GuideResult({
    required this.description,
    required this.material,
    required this.steps,
  });
}

class GuideStep {
  final String title;
  final String description;
  final String? warning;

  GuideStep({
    required this.title,
    required this.description,
    this.warning,
  });

  factory GuideStep.fromJson(Map<String, dynamic> json) {
    return GuideStep(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      warning: json['warning'],
    );
  }
}
