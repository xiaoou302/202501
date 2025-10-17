/// Model representing a level layout configuration
class LevelLayout {
  /// List of coordinate positions for tiles in this layout
  final List<Map<String, double>> coordinates;

  /// Total number of tiles in this layout
  final int tileCount;

  /// Layout size category (small, medium, large)
  final String sizeCategory;

  /// Constructor
  const LevelLayout({
    required this.coordinates,
    required this.tileCount,
    required this.sizeCategory,
  });

  /// Creates a LevelLayout from a map
  factory LevelLayout.fromMap(Map<String, dynamic> map) {
    return LevelLayout(
      coordinates: (map['coordinates'] as List<dynamic>)
          .map((e) => Map<String, double>.from(e as Map))
          .toList(),
      tileCount: map['tileCount'] as int,
      sizeCategory: map['sizeCategory'] as String,
    );
  }

  /// Converts this LevelLayout to a map
  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinates,
      'tileCount': tileCount,
      'sizeCategory': sizeCategory,
    };
  }

  /// Predefined small layout (for levels 1-3)
  factory LevelLayout.small() {
    const tileW = 50.0;
    const tileH = 70.0;
    final coords = <Map<String, double>>[];

    // Layer 0 (bottom)
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < 6; c++) {
        coords.add({
          'x': 70 + c * (tileW * 0.7),
          'y': 110 + r * (tileH * 0.7),
          'z': 0,
        });
      }
    }

    // Layer 1 (middle)
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 5; c++) {
        coords.add({
          'x': 95 + c * (tileW * 0.7),
          'y': 150 + r * (tileH * 0.7),
          'z': 1,
        });
      }
    }

    // Layer 2 (upper)
    for (int r = 0; r < 2; r++) {
      for (int c = 0; c < 3; c++) {
        coords.add({
          'x': 120 + c * (tileW * 0.7),
          'y': 180 + r * (tileH * 0.7),
          'z': 2,
        });
      }
    }

    // Layer 3 (top)
    for (int c = 0; c < 3; c++) {
      coords.add({'x': 120 + c * (tileW * 0.7), 'y': 220, 'z': 3});
    }

    return LevelLayout(
      coordinates: coords.take(54).toList(),
      tileCount: 54,
      sizeCategory: 'small',
    );
  }

  /// Predefined medium layout (for levels 4-7)
  factory LevelLayout.medium() {
    const tileW = 50.0;
    const tileH = 70.0;
    final coords = <Map<String, double>>[];

    // Layer 0 (bottom)
    for (int r = 0; r < 6; r++) {
      for (int c = 0; c < 7; c++) {
        coords.add({
          'x': 45 + c * (tileW * 0.75),
          'y': 80 + r * (tileH * 0.7),
          'z': 0,
        });
      }
    }

    // Layer 1 (middle)
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 5; c++) {
        coords.add({
          'x': 80 + c * (tileW * 0.75),
          'y': 130 + r * (tileH * 0.7),
          'z': 1,
        });
      }
    }

    // Layer 2 (upper)
    for (int r = 0; r < 2; r++) {
      for (int c = 0; c < 4; c++) {
        coords.add({
          'x': 100 + c * (tileW * 0.75),
          'y': 180 + r * (tileH * 0.7),
          'z': 2,
        });
      }
    }

    // Layer 3 (top)
    for (int c = 0; c < 2; c++) {
      coords.add({'x': 135 + c * (tileW * 0.8), 'y': 220, 'z': 3});
    }

    return LevelLayout(
      coordinates: coords.take(72).toList(),
      tileCount: 72,
      sizeCategory: 'medium',
    );
  }

  /// Predefined large layout (for levels 8-12)
  factory LevelLayout.large() {
    const tileW = 50.0;
    const tileH = 70.0;
    final coords = <Map<String, double>>[];

    // Layer 0 (bottom)
    for (int r = 0; r < 7; r++) {
      for (int c = 0; c < 8; c++) {
        coords.add({
          'x': 25 + c * (tileW * 0.75),
          'y': 70 + r * (tileH * 0.65),
          'z': 0,
        });
      }
    }

    // Layer 1 (middle)
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < 6; c++) {
        coords.add({
          'x': 55 + c * (tileW * 0.75),
          'y': 110 + r * (tileH * 0.65),
          'z': 1,
        });
      }
    }

    // Layer 2 (top)
    for (int c = 0; c < 4; c++) {
      coords.add({'x': 90 + c * (tileW * 0.8), 'y': 180, 'z': 2});
    }

    return LevelLayout(
      coordinates: coords.take(90).toList(),
      tileCount: 90,
      sizeCategory: 'large',
    );
  }

  /// Get the appropriate layout for a given level
  factory LevelLayout.forLevel(int level) {
    if (level <= 3) {
      return LevelLayout.small();
    } else if (level <= 7) {
      return LevelLayout.medium();
    } else {
      return LevelLayout.large();
    }
  }
}
