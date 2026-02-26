import 'package:shared_preferences/shared_preferences.dart';
import '../models/relic_model.dart';
import '../../core/constants/strings.dart';

class RelicRepository {
  static const String _deletedRelicsKey = 'deleted_relic_ids';

  Future<List<String>> _getDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_deletedRelicsKey) ?? [];
  }

  Future<void> deleteRelic(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final deletedIds = prefs.getStringList(_deletedRelicsKey) ?? [];
    if (!deletedIds.contains(id)) {
      deletedIds.add(id);
      await prefs.setStringList(_deletedRelicsKey, deletedIds);
    }
  }

  Future<List<Relic>> getRelics() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final deletedIds = await _getDeletedIds();
    List<Relic> relics = [];

    // --- WATCHES (13 Items) ---
    for (int i = 1; i <= 13; i++) {
      relics.add(Relic(
        id: 'W-892-${100 + i}',
        name: _getWatchName(i),
        provenance: _getProvenance(i),
        era: _getEra(i),
        category: AppStrings.categoryWatches,
        imageUrl: 'assets/b/b$i.jpg',
        condition: 'Needs Polishing',
        addedDate: DateTime.now().subtract(Duration(days: i * 2)),
        year: (1850 + i * 3).toString(),
        story: "This timepiece was acquired from a retired train conductor who claimed it never lost a second during his 40 years of service on the Trans-Continental Railway. The casing bears scratches that resemble a map of the old coastline.",
        techSpecs: {
          "Movement": "Mechanical Wind",
          "Jewels": "${15 + (i % 5)} Jewels",
          "Case Material": i % 2 == 0 ? "Sterling Silver" : "Brass Alloy",
          "Diameter": "${40 + (i % 10)}mm",
        },
      ));
    }

    // --- CAMERAS (12 Items) ---
    for (int i = 1; i <= 12; i++) {
      relics.add(Relic(
        id: 'C-741-${200 + i}',
        name: _getCameraName(i),
        provenance: _getProvenance(i + 20),
        era: _getEra(i + 10),
        category: AppStrings.categoryCameras,
        imageUrl: 'assets/xj/xj$i.jpg',
        condition: 'Shutter Jammed',
        addedDate: DateTime.now().subtract(Duration(days: i * 3)),
        year: (1920 + i * 2).toString(),
        story: "Found in a dusty attic in Paris, this camera still contained a roll of undeveloped film. The previous owner was a street photographer known for capturing the foggy mornings of the industrial district.",
        techSpecs: {
          "Lens": "50mm f/3.5",
          "Shutter Speed": "1/10 - 1/200",
          "Film Format": "120 Roll Film",
          "Bellows": "Leather",
        },
      ));
    }

    // --- PENS (12 Items) ---
    for (int i = 1; i <= 12; i++) {
      relics.add(Relic(
        id: 'P-305-${300 + i}',
        name: _getPenName(i),
        provenance: _getProvenance(i + 40),
        era: _getEra(i + 20),
        category: AppStrings.categoryPens,
        imageUrl: 'assets/gb/gb$i.jpg',
        condition: 'Nib Bent',
        addedDate: DateTime.now().subtract(Duration(days: i * 4)),
        year: (1900 + i * 4).toString(),
        story: "A writer's companion that has drafted over a dozen unpublished manuscripts. The nib has adapted perfectly to the heavy hand of its original owner, a poet who wrote exclusively by candlelight.",
        techSpecs: {
          "Nib Material": "14k Gold",
          "Filling System": "Lever Filler",
          "Body Material": "Celluloid",
          "Length": "${12 + (i % 3)}cm",
        },
      ));
    }

    // Filter out deleted items
    return relics.where((r) => !deletedIds.contains(r.id)).toList();
  }

  Future<List<Relic>> searchRelics(String query) async {
    final all = await getRelics();
    return all.where((e) => e.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Helpers for variety
  String _getWatchName(int index) {
    const names = [
      "Navigator's Chronometer", "Railway Regulator", "Gentleman's Pocket Watch", 
      "Officer's Field Watch", "Astronomer's Dial", "Steam-Gauge Timepiece",
      "Victorian Hunter Case", "Maritime Deck Watch", "Engineer's Chronograph",
      "Aviator's Prototype", "Doctor's Pulsometer", "Explorer's Compass Watch",
      "Industrialist's Timekeeper"
    ];
    return names[(index - 1) % names.length];
  }

  String _getCameraName(int index) {
    const names = [
      "Optical Box Model A", "Portrait Bellows Camera", "Field Reporter's Lens",
      "Studio Master V2", "Rangefinder Prototype", "Stereoscopic Viewer",
      "Compact Folding Camera", "Reflex Mirror Box", "Panoramic Horizon",
      "Candid Shooter", "Nocturnal Lens System", "Pressman's Flash Camera"
    ];
    return names[(index - 1) % names.length];
  }

  String _getPenName(int index) {
    const names = [
      "Scholar's Fountain Pen", "Diplomat's Signer", "Calligrapher's Quill",
      "Architect's Draughtsman", "Traveler's Safety Pen", "Marble-Vein Celluloid",
      "Obsidian Desk Pen", "Royal Correspondence", "Telegram Writer",
      "Sketching Stylus", "Accounting Ledger Pen", "Poet's Inspiration"
    ];
    return names[(index - 1) % names.length];
  }

  String _getProvenance(int seed) {
    const cities = ["London", "Paris", "Vienna", "Berlin", "New York", "Chicago", "Boston", "San Francisco"];
    return cities[seed % cities.length];
  }

  String _getEra(int seed) {
    if (seed % 3 == 0) return "LATE 19TH";
    if (seed % 3 == 1) return "EARLY 20TH";
    return "VICTORIAN";
  }
}
