class WaterParameter {
  final DateTime timestamp;
  final double pH;
  final double temperature; // Celsius
  final double tds; // ppm
  final double co2Bps; // bubbles per second
  final double? kh; // Carbonate Hardness
  final double? gh; // General Hardness
  final double? ammonia; // NH3/NH4+
  final double? nitrite; // NO2-
  final double? nitrate; // NO3-

  WaterParameter({
    required this.timestamp,
    required this.pH,
    required this.temperature,
    required this.tds,
    required this.co2Bps,
    this.kh,
    this.gh,
    this.ammonia,
    this.nitrite,
    this.nitrate,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'pH': pH,
      'temperature': temperature,
      'tds': tds,
      'co2Bps': co2Bps,
      'kh': kh,
      'gh': gh,
      'ammonia': ammonia,
      'nitrite': nitrite,
      'nitrate': nitrate,
    };
  }

  factory WaterParameter.fromJson(Map<String, dynamic> json) {
    return WaterParameter(
      timestamp: DateTime.parse(json['timestamp']),
      pH: (json['pH'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      tds: (json['tds'] as num).toDouble(),
      co2Bps: (json['co2Bps'] as num).toDouble(),
      kh: (json['kh'] as num?)?.toDouble(),
      gh: (json['gh'] as num?)?.toDouble(),
      ammonia: (json['ammonia'] as num?)?.toDouble(),
      nitrite: (json['nitrite'] as num?)?.toDouble(),
      nitrate: (json['nitrate'] as num?)?.toDouble(),
    );
  }
}
