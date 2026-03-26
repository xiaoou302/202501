import 'package:uuid/uuid.dart';

class TankConfig {
  final String id;
  final String name;
  final double length;
  final double width;
  final double height;
  final double substrateThickness;
  final double hardscapeVolume; // in Liters
  final String style;
  final List<String> plantSpecies;
  final DateTime? lastMaintenanceDate;

  // Computed
  double get grossVolume => (length * width * height) / 1000.0;
  double get netWaterVolume =>
      grossVolume -
      hardscapeVolume -
      ((length * width * substrateThickness) / 1000.0);

  TankConfig({
    required this.id,
    required this.name,
    required this.length,
    required this.width,
    required this.height,
    this.substrateThickness = 5.0,
    this.hardscapeVolume = 0.0,
    this.style = 'Nature Style',
    this.plantSpecies = const [],
    this.lastMaintenanceDate,
  });

  factory TankConfig.create({
    required String name,
    required double length,
    required double width,
    required double height,
  }) {
    return TankConfig(
      id: const Uuid().v4(),
      name: name,
      length: length,
      width: width,
      height: height,
    );
  }

  TankConfig copyWith({
    String? name,
    double? length,
    double? width,
    double? height,
    DateTime? lastMaintenanceDate,
  }) {
    return TankConfig(
      id: id,
      name: name ?? this.name,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      substrateThickness: substrateThickness,
      hardscapeVolume: hardscapeVolume,
      style: style,
      plantSpecies: plantSpecies,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'length': length,
      'width': width,
      'height': height,
      'substrateThickness': substrateThickness,
      'hardscapeVolume': hardscapeVolume,
      'style': style,
      'plantSpecies': plantSpecies,
      'lastMaintenanceDate': lastMaintenanceDate?.toIso8601String(),
    };
  }

  factory TankConfig.fromJson(Map<String, dynamic> json) {
    return TankConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      length: (json['length'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      substrateThickness:
          (json['substrateThickness'] as num?)?.toDouble() ?? 5.0,
      hardscapeVolume: (json['hardscapeVolume'] as num?)?.toDouble() ?? 0.0,
      style: json['style'] as String? ?? 'Nature Style',
      plantSpecies:
          (json['plantSpecies'] as List?)?.map((e) => e as String).toList() ??
          [],
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'] as String)
          : null,
    );
  }
}
