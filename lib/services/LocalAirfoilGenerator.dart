import 'dart:math';
import 'dart:ui' as ui;

class AirfoilGeometry {
  final double chordLength;
  final double maxCamber;
  final List<Map<String, double>> upperSurface;
  final List<Map<String, double>> lowerSurface;

  AirfoilGeometry({
    required this.chordLength,
    required this.maxCamber,
    required this.upperSurface,
    required this.lowerSurface,
  });
}

class NACAAirfoilPreset {
  final String name;
  final int m;
  final int p;
  final int t;
  final String description;

  const NACAAirfoilPreset({
    required this.name,
    required this.m,
    required this.p,
    required this.t,
    required this.description,
  });
}

class LocalAirfoilGenerator {
  static const List<NACAAirfoilPreset> presets = [
    NACAAirfoilPreset(
      name: 'NACA 0012',
      m: 0,
      p: 0,
      t: 12,
      description: '对称翼型，通用',
    ),
    NACAAirfoilPreset(
      name: 'NACA 2412',
      m: 2,
      p: 4,
      t: 12,
      description: '低弯度，适合低速飞行',
    ),
    NACAAirfoilPreset(
      name: 'NACA 2415',
      m: 2,
      p: 4,
      t: 15,
      description: '低弯度，较厚',
    ),
    NACAAirfoilPreset(
      name: 'NACA 4412',
      m: 4,
      p: 4,
      t: 12,
      description: '中等弯度，高升力',
    ),
    NACAAirfoilPreset(
      name: 'NACA 4415',
      m: 4,
      p: 4,
      t: 15,
      description: '中等弯度，较厚',
    ),
    NACAAirfoilPreset(
      name: 'NACA 6412',
      m: 6,
      p: 4,
      t: 12,
      description: '高弯度，最大升力',
    ),
    NACAAirfoilPreset(
      name: 'NACA 23012',
      m: 2,
      p: 3,
      t: 12,
      description: '五位数翼型，高效',
    ),
    NACAAirfoilPreset(
      name: 'NACA 23015',
      m: 2,
      p: 3,
      t: 15,
      description: '五位数翼型，较厚',
    ),
    NACAAirfoilPreset(
      name: 'NACA 24012',
      m: 2,
      p: 4,
      t: 12,
      description: '低阻力翼型',
    ),
    NACAAirfoilPreset(
      name: 'NACA 63-212',
      m: 6,
      p: 3,
      t: 12,
      description: '层流翼型',
    ),
    NACAAirfoilPreset(
      name: 'NACA 64-212',
      m: 6,
      p: 4,
      t: 12,
      description: '层流翼型，高升力',
    ),
    NACAAirfoilPreset(
      name: 'NACA 65-212',
      m: 6,
      p: 5,
      t: 12,
      description: '层流翼型，低阻力',
    ),
    NACAAirfoilPreset(
      name: 'NACA 0009',
      m: 0,
      p: 0,
      t: 9,
      description: '薄对称翼型，高速',
    ),
    NACAAirfoilPreset(
      name: 'NACA 0015',
      m: 0,
      p: 0,
      t: 15,
      description: '厚对称翼型',
    ),
    NACAAirfoilPreset(
      name: 'NACA 14012',
      m: 1,
      p: 4,
      t: 12,
      description: '极低弯度翼型',
    ),
  ];

  static AirfoilGeneratorResult generateNACAAirfoil({
    int m = 2,
    int p = 4,
    int t = 12,
    int numPoints = 20,
  }) {
    final maxCamber = m / 100.0;
    final maxCamberPos = p / 10.0;
    final maxThickness = t / 100.0;

    final upperSurface = <Map<String, double>>[];
    final lowerSurface = <Map<String, double>>[];

    for (int i = 0; i <= numPoints; i++) {
      final x = i / numPoints;
      final yt = _thicknessDistribution(x, maxThickness);

      if (x == 0) {
        upperSurface.add({'x': 0.0, 'y': yt});
        lowerSurface.add({'x': 0.0, 'y': -yt});
      } else {
        final yc = _camberLine(x, maxCamber, maxCamberPos);
        final dyc = _camberLineDerivative(x, maxCamber, maxCamberPos);
        final theta = atan(dyc);

        final xu = x - yt * sin(theta);
        final yu = yc + yt * cos(theta);
        final xl = x + yt * sin(theta);
        final yl = yc - yt * cos(theta);

        upperSurface.add({'x': xu, 'y': yu});
        lowerSurface.add({'x': xl, 'y': yl});
      }
    }

    return AirfoilGeneratorResult(
      chordLength: 150.0 + (m * 10.0),
      maxCamber: maxCamber * 100,
      upperSurface: upperSurface,
      lowerSurface: lowerSurface,
    );
  }

  static List<AirfoilGeneratorResult> generateMultipleAirfoils({
    int numPoints = 20,
  }) {
    return presets.map((preset) {
      return generateNACAAirfoil(
        m: preset.m,
        p: preset.p,
        t: preset.t,
        numPoints: numPoints,
      );
    }).toList();
  }

  static AirfoilGeneratorResult analyzeImageAndSelectAirfoil(ui.Image image) {
    final seed = _calculateImageHash(image);
    final random = _seededRandom(seed);

    final m = (random() * 6).floor();
    final pOptions = [3, 4, 5];
    final p = pOptions[(random() * 3).floor()];
    final tOptions = [9, 12, 15];
    final t = tOptions[(random() * 3).floor()];

    return generateNACAAirfoil(
      m: m,
      p: p,
      t: t,
      numPoints: 20,
    );
  }

  static int _calculateImageHash(ui.Image image) {
    return (image.width * 31 + image.height * 17) % 1000000;
  }

  static double Function() _seededRandom(int seed) {
    var s = seed;
    return () {
      s = (s * 1103515245 + 12345) & 0x7fffffff;
      return (s % 10000) / 10000.0;
    };
  }

  static AirfoilGeneratorResult generateRandomAirfoil({int numPoints = 20}) {
    final random = _seededRandom(DateTime.now().millisecondsSinceEpoch);

    final m = (random() * 6).floor();
    final pOptions = [3, 4, 5];
    final p = pOptions[(random() * 3).floor()];
    final tOptions = [9, 12, 15];
    final t = tOptions[(random() * 3).floor()];

    return generateNACAAirfoil(
      m: m,
      p: p,
      t: t,
      numPoints: numPoints,
    );
  }

  static double _camberLine(double x, double m, double p) {
    if (x < p) {
      return m / (p * p) * (2 * p * x - x * x);
    } else {
      return m / ((1 - p) * (1 - p)) * ((1 - 2 * p) + 2 * p * x - x * x);
    }
  }

  static double _camberLineDerivative(double x, double m, double p) {
    if (x < p) {
      return 2 * m / (p * p) * (p - x);
    } else {
      return 2 * m / ((1 - p) * (1 - p)) * (p - x);
    }
  }

  static double _thicknessDistribution(double x, double t) {
    return 5 *
        t *
        (0.2969 * sqrt(x) -
            0.1260 * x -
            0.3516 * x * x +
            0.2843 * x * x * x -
            0.1015 * x * x * x * x);
  }
}

class AirfoilGeneratorResult {
  final double chordLength;
  final double maxCamber;
  final List<Map<String, double>> upperSurface;
  final List<Map<String, double>> lowerSurface;

  AirfoilGeneratorResult({
    required this.chordLength,
    required this.maxCamber,
    required this.upperSurface,
    required this.lowerSurface,
  });
}
