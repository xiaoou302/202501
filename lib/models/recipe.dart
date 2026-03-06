class Recipe {
  final String id;
  final String name;
  final String beanId; // Optional link to a specific bean
  final String brewer; // e.g., "V60", "Kalita"
  final double temp;
  final int dose; // in grams
  final int water; // in grams
  final String grindSetting;
  final String imagePath;
  final String origin;
  final String roastLevel;
  final String process;
  final String description;
  final List<String> flavorTags;
  final List<BrewStep> steps;

  Recipe({
    required this.id,
    required this.name,
    this.beanId = '',
    required this.brewer,
    required this.temp,
    required this.dose,
    required this.water,
    required this.grindSetting,
    required this.imagePath,
    required this.origin,
    required this.roastLevel,
    required this.process,
    required this.description,
    required this.flavorTags,
    required this.steps,
  });
}

class BrewStep {
  final String description;
  final int durationSeconds;
  final int targetWeight; // Cumulative weight at end of step

  BrewStep({
    required this.description,
    required this.durationSeconds,
    required this.targetWeight,
  });
}
