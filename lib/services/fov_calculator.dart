import 'dart:math' as math;

class FovResult {
  final double widthDegrees;
  final double heightDegrees;

  FovResult(this.widthDegrees, this.heightDegrees);

  String get formattedDegrees =>
      '${widthDegrees.toStringAsFixed(2)}° x ${heightDegrees.toStringAsFixed(2)}°';
  
  String get formattedArcmin =>
      '${(widthDegrees * 60).toStringAsFixed(0)}\' x ${(heightDegrees * 60).toStringAsFixed(0)}\'';
}

class FovCalculator {
  static FovResult calculate(
    double sensorWidth,
    double sensorHeight,
    double focalLength,
  ) {
    if (focalLength <= 0) return FovResult(0, 0);

    final wRad = 2 * math.atan(sensorWidth / (2 * focalLength));
    final hRad = 2 * math.atan(sensorHeight / (2 * focalLength));

    final wDeg = wRad * (180 / math.pi);
    final hDeg = hRad * (180 / math.pi);

    return FovResult(wDeg, hDeg);
  }

  static String calculateFovString(
    double sensorWidth,
    double sensorHeight,
    double focalLength,
  ) {
    final result = calculate(sensorWidth, sensorHeight, focalLength);
    return result.formattedDegrees;
  }
}
