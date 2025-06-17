import 'dart:math';

class PackingItem {
  final String id;
  final String name;
  bool isPacked;

  PackingItem({String? id, required this.name, this.isPacked = false})
      : id = id ?? _generateId();

  // Create from JSON
  factory PackingItem.fromJson(Map<String, dynamic> json) {
    return PackingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      isPacked: json['isPacked'] as bool,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'isPacked': isPacked};
  }

  // Toggle packed status
  void togglePacked() {
    isPacked = !isPacked;
  }

  // Generate random ID
  static String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        10,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
