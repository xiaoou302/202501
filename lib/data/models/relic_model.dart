class Relic {
  final String id;
  final String name;
  final String provenance;
  final String era;
  final String category;
  final String imageUrl;
  final String condition;
  final DateTime addedDate;
  
  // New Detail Fields
  final String story;
  final Map<String, String> techSpecs;
  final String year;

  Relic({
    required this.id,
    required this.name,
    required this.provenance,
    required this.era,
    required this.category,
    required this.imageUrl,
    required this.condition,
    required this.addedDate,
    required this.story,
    required this.techSpecs,
    required this.year,
  });

  // Factory for mock data (Updated to use index for variation if needed, 
  // but main data comes from repository now)
  factory Relic.mock(int index) {
    return Relic(
      id: '892-$index',
      name: 'Unknown Artifact',
      provenance: 'Unknown',
      era: 'Unknown',
      category: 'MISC',
      imageUrl: '',
      condition: 'Unknown',
      addedDate: DateTime.now(),
      story: 'No data available.',
      techSpecs: {},
      year: 'Unknown',
    );
  }
}
