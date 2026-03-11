class AstroTarget {
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final String palette; // e.g. "SHO", "RGB", "Ha"
  final double integrationHours;
  final int focalLength; // in mm
  final String cameraModel;

  // New enriched fields
  final String constellation;
  final String distance; // e.g. "1,344 ly"
  final String apparentMagnitude; // e.g. "+4.0"
  final String rightAscension; // e.g. "05h 35m 17s"
  final String declination; // e.g. "-05° 23′ 28″"
  final String bestSeason; // e.g. "Winter"

  // More fields for richer detail
  final String type; // e.g. "Emission Nebula", "Spiral Galaxy"
  final String size; // e.g. "65 x 60 arcmin"
  final String
  discoveryInfo; // e.g. "Discovered by Nicholas-Claude Fabri de Peiresc in 1610"

  const AstroTarget({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrl,
    required this.palette,
    required this.integrationHours,
    required this.focalLength,
    required this.cameraModel,
    this.constellation = 'Unknown',
    this.distance = 'Unknown',
    this.apparentMagnitude = 'Unknown',
    this.rightAscension = 'Unknown',
    this.declination = 'Unknown',
    this.bestSeason = 'Unknown',
    this.type = 'Unknown',
    this.size = 'Unknown',
    this.discoveryInfo = 'Unknown',
  });
}
