import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/helpers.dart';

// Renamed to CustomColorScheme to avoid conflict with Flutter's ColorScheme
class CustomColorScheme {
  final int hue; // Hue (0-360)
  final double saturation; // Saturation (0-100)
  final double lightness; // Lightness (0-100)
  final String name; // Color scheme name
  final DateTime createdAt;
  final List<String>? tags; // Optional tags for categorization

  CustomColorScheme({
    required this.hue,
    required this.saturation,
    required this.lightness,
    this.name = '',
    DateTime? createdAt,
    this.tags,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert from JSON to CustomColorScheme object
  factory CustomColorScheme.fromJson(Map<String, dynamic> json) {
    return CustomColorScheme(
      hue: json['hue'],
      saturation: json['saturation'],
      lightness: json['lightness'],
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  // Convert CustomColorScheme object to JSON
  Map<String, dynamic> toJson() {
    return {
      'hue': hue,
      'saturation': saturation,
      'lightness': lightness,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      if (tags != null) 'tags': tags,
    };
  }

  // Convert from JSON string list to CustomColorScheme object list
  static List<CustomColorScheme> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => CustomColorScheme.fromJson(json)).toList();
  }

  // Convert CustomColorScheme object list to JSON string
  static String toJsonList(List<CustomColorScheme> schemes) {
    final List<Map<String, dynamic>> jsonList =
        schemes.map((scheme) => scheme.toJson()).toList();
    return json.encode(jsonList);
  }

  // Create a random color scheme
  factory CustomColorScheme.random() {
    return CustomColorScheme(
      hue: (DateTime.now().millisecondsSinceEpoch % 360),
      saturation: 80,
      lightness: 50,
      name: 'Random Scheme',
    );
  }

  // Create a random pastel color scheme
  factory CustomColorScheme.randomPastel() {
    return CustomColorScheme(
      hue: (DateTime.now().millisecondsSinceEpoch % 360),
      saturation: 60,
      lightness: 80,
      name: 'Pastel Scheme',
    );
  }

  // Create a random vibrant color scheme
  factory CustomColorScheme.randomVibrant() {
    return CustomColorScheme(
      hue: (DateTime.now().millisecondsSinceEpoch % 360),
      saturation: 90,
      lightness: 60,
      name: 'Vibrant Scheme',
    );
  }

  // Create a random dark color scheme
  factory CustomColorScheme.randomDark() {
    return CustomColorScheme(
      hue: (DateTime.now().millisecondsSinceEpoch % 360),
      saturation: 70,
      lightness: 20,
      name: 'Dark Scheme',
    );
  }

  // Create a monochromatic scheme from this color
  List<CustomColorScheme> generateMonochromaticScheme({int count = 5}) {
    final List<CustomColorScheme> schemes = [];
    final double step = 100 / (count + 1);

    for (int i = 0; i < count; i++) {
      final double newLightness = step * (i + 1);
      schemes.add(
        CustomColorScheme(
          hue: hue,
          saturation: saturation,
          lightness: newLightness,
          name: '$name - Mono ${i + 1}',
        ),
      );
    }

    return schemes;
  }

  // Create an analogous scheme from this color
  List<CustomColorScheme> generateAnalogousScheme({int count = 5}) {
    final List<CustomColorScheme> schemes = [];
    final int step = 30;
    final int startHue = (hue - (count ~/ 2) * step) % 360;

    for (int i = 0; i < count; i++) {
      final int newHue = (startHue + i * step) % 360;
      schemes.add(
        CustomColorScheme(
          hue: newHue,
          saturation: saturation,
          lightness: lightness,
          name: '$name - Ana ${i + 1}',
        ),
      );
    }

    return schemes;
  }

  // Create a complementary scheme
  CustomColorScheme generateComplementary() {
    return CustomColorScheme(
      hue: (hue + 180) % 360,
      saturation: saturation,
      lightness: lightness,
      name: '$name - Comp',
    );
  }

  // Create a triadic scheme
  List<CustomColorScheme> generateTriadicScheme() {
    return [
      this,
      CustomColorScheme(
        hue: (hue + 120) % 360,
        saturation: saturation,
        lightness: lightness,
        name: '$name - Tri 1',
      ),
      CustomColorScheme(
        hue: (hue + 240) % 360,
        saturation: saturation,
        lightness: lightness,
        name: '$name - Tri 2',
      ),
    ];
  }

  // Create a tetradic scheme
  List<CustomColorScheme> generateTetradicScheme() {
    return [
      this,
      CustomColorScheme(
        hue: (hue + 90) % 360,
        saturation: saturation,
        lightness: lightness,
        name: '$name - Tetra 1',
      ),
      CustomColorScheme(
        hue: (hue + 180) % 360,
        saturation: saturation,
        lightness: lightness,
        name: '$name - Tetra 2',
      ),
      CustomColorScheme(
        hue: (hue + 270) % 360,
        saturation: saturation,
        lightness: lightness,
        name: '$name - Tetra 3',
      ),
    ];
  }

  // Create a split complementary scheme
  List<CustomColorScheme> generateSplitComplementaryScheme() {
    return [
      this,
      CustomColorScheme(
        hue: (hue + 150) % 360,
        saturation: saturation,
        lightness: lightness,
        name: '$name - Split 1',
      ),
      CustomColorScheme(
        hue: (hue + 210) % 360,
        saturation: saturation,
        lightness: lightness,
        name: '$name - Split 2',
      ),
    ];
  }

  // Get primary color
  Color get primaryColor => ColorHelper.fromHSL(hue, saturation, lightness);

  // Get complementary color
  Color get complementaryColor => ColorHelper.complementary(primaryColor);

  // Get analogous colors
  List<Color> get analogousColors => ColorHelper.analogous(primaryColor);

  // Get triadic colors
  List<Color> get triadicColors => ColorHelper.triadic(primaryColor);

  // Get lighter variant
  Color get lighterVariant => ColorHelper.adjustLightness(primaryColor, 0.1);

  // Get darker variant
  Color get darkerVariant => ColorHelper.adjustLightness(primaryColor, -0.1);

  // Get monochromatic colors
  List<Color> get monochromaticColors {
    final List<Color> colors = [];
    final double step = 0.2;

    for (double i = 0.1; i < 1.0; i += step) {
      colors.add(
        HSLColor.fromAHSL(
          1.0,
          hue.toDouble(),
          saturation / 100,
          (lightness * i) / 100,
        ).toColor(),
      );
    }

    return colors;
  }

  // Get tetradic colors
  List<Color> get tetradicColors {
    final hsl = HSLColor.fromAHSL(
      1.0,
      hue.toDouble(),
      saturation / 100,
      lightness / 100,
    );

    return [
      hsl.toColor(),
      HSLColor.fromAHSL(
        1.0,
        (hue + 90) % 360,
        saturation / 100,
        lightness / 100,
      ).toColor(),
      HSLColor.fromAHSL(
        1.0,
        (hue + 180) % 360,
        saturation / 100,
        lightness / 100,
      ).toColor(),
      HSLColor.fromAHSL(
        1.0,
        (hue + 270) % 360,
        saturation / 100,
        lightness / 100,
      ).toColor(),
    ];
  }

  // Get split complementary colors
  List<Color> get splitComplementaryColors {
    final hsl = HSLColor.fromAHSL(
      1.0,
      hue.toDouble(),
      saturation / 100,
      lightness / 100,
    );

    return [
      hsl.toColor(),
      HSLColor.fromAHSL(
        1.0,
        (hue + 150) % 360,
        saturation / 100,
        lightness / 100,
      ).toColor(),
      HSLColor.fromAHSL(
        1.0,
        (hue + 210) % 360,
        saturation / 100,
        lightness / 100,
      ).toColor(),
    ];
  }

  // Get color as hex string
  String get hexString {
    final color = primaryColor;
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Get color as RGB string
  String get rgbString {
    final color = primaryColor;
    return 'RGB(${color.red}, ${color.green}, ${color.blue})';
  }

  // Get color as HSL string
  String get hslString {
    return 'HSL($hue, ${saturation.toInt()}%, ${lightness.toInt()}%)';
  }

  // Copy and modify CustomColorScheme object
  CustomColorScheme copyWith({
    int? hue,
    double? saturation,
    double? lightness,
    String? name,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return CustomColorScheme(
      hue: hue ?? this.hue,
      saturation: saturation ?? this.saturation,
      lightness: lightness ?? this.lightness,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }

  // Check if two schemes are equal
  bool isEqual(CustomColorScheme other) {
    return hue == other.hue &&
        saturation == other.saturation &&
        lightness == other.lightness &&
        name == other.name;
  }
}
