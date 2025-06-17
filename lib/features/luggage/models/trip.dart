import 'dart:math';
import 'packing_item.dart';

class Trip {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<PackingItem> packingList;

  Trip({
    String? id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.packingList = const [],
  }) : id = id ?? _generateId();

  // Get trip duration in days
  int get duration {
    return endDate.difference(startDate).inDays + 1;
  }

  // Get packing progress percentage
  double get packingProgress {
    if (packingList.isEmpty) return 0;

    final packedItems = packingList.where((item) => item.isPacked).length;
    return (packedItems / packingList.length) * 100;
  }

  // Get number of packed items
  int get packedItemsCount {
    return packingList.where((item) => item.isPacked).length;
  }

  // Create from JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      packingList: (json['packingList'] as List<dynamic>)
          .map((e) => PackingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'packingList': packingList.map((e) => e.toJson()).toList(),
    };
  }

  // Create a copy with updated packing list
  Trip copyWith({
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    List<PackingItem>? packingList,
  }) {
    return Trip(
      id: id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      packingList: packingList ?? this.packingList,
    );
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
