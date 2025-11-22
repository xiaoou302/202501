class LevelModel {
  final int id;
  final String name;
  final int rows;
  final int cols;
  final int time;
  final int pairs;
  final bool hasObservation;

  const LevelModel({
    required this.id,
    required this.name,
    required this.rows,
    required this.cols,
    required this.time,
    required this.pairs,
    this.hasObservation = false,
  });

  int get totalCards => pairs * 2;
}
