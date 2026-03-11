class SessionLog {
  final DateTime date;
  final String targetId;
  final int seeing; // 1..5
  final int transparency; // 1..7
  final int bortle; // 1..9
  final bool success;
  final String? notes;
  final String? imagePath;

  const SessionLog({
    required this.date,
    required this.targetId,
    required this.seeing,
    required this.transparency,
    required this.bortle,
    required this.success,
    this.notes,
    this.imagePath,
  });
}
