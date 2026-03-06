import 'recipe.dart';

enum BrewStatus { idle, brewing, paused, completed }

class BrewSession {
  final String id;
  final Recipe recipe;
  final DateTime startTime;
  int elapsedSeconds;
  int currentStepIndex;
  BrewStatus status;

  BrewSession({
    required this.id,
    required this.recipe,
    required this.startTime,
    this.elapsedSeconds = 0,
    this.currentStepIndex = 0,
    this.status = BrewStatus.idle,
  });
}
