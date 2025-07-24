import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  static const String _storageKey = 'journal_entries';

  // Save a journal entry
  Future<void> saveEntry(JournalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_storageKey) ?? [];

    // Check if entry already exists (for updates)
    final existingIndex = entriesJson.indexWhere((json) {
      final Map<String, dynamic> entryMap = jsonDecode(json);
      return entryMap['id'] == entry.id;
    });

    // Convert entry to JSON string
    final entryJson = jsonEncode(entry.toJson());

    if (existingIndex >= 0) {
      // Update existing entry
      entriesJson[existingIndex] = entryJson;
    } else {
      // Add new entry
      entriesJson.add(entryJson);
    }

    await prefs.setStringList(_storageKey, entriesJson);
  }

  // Get all journal entries
  Future<List<JournalEntry>> getAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_storageKey) ?? [];

    // Convert JSON strings to JournalEntry objects
    return entriesJson.map((json) {
        final Map<String, dynamic> entryMap = jsonDecode(json);
        return JournalEntry.fromJson(entryMap);
      }).toList()
      // Sort by date (newest first)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get a single entry by ID
  Future<JournalEntry?> getEntryById(String id) async {
    final entries = await getAllEntries();
    try {
      return entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  // Delete a journal entry
  Future<void> deleteEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_storageKey) ?? [];

    // Filter out the entry with matching ID
    final filteredEntries = entriesJson.where((json) {
      final Map<String, dynamic> entryMap = jsonDecode(json);
      return entryMap['id'] != id;
    }).toList();

    await prefs.setStringList(_storageKey, filteredEntries);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final entry = await getEntryById(id);
    if (entry != null) {
      final updatedEntry = entry.copyWith(isFavorite: !entry.isFavorite);
      await saveEntry(updatedEntry);
    }
  }

  // Get favorite entries
  Future<List<JournalEntry>> getFavoriteEntries() async {
    final entries = await getAllEntries();
    return entries.where((entry) => entry.isFavorite).toList();
  }

  // Search entries by text
  Future<List<JournalEntry>> searchEntries(String query) async {
    if (query.isEmpty) return getAllEntries();

    final entries = await getAllEntries();
    final lowercaseQuery = query.toLowerCase();

    return entries.where((entry) {
      final textMatch = entry.text.toLowerCase().contains(lowercaseQuery);
      final titleMatch =
          entry.title?.toLowerCase().contains(lowercaseQuery) ?? false;

      return textMatch || titleMatch;
    }).toList();
  }

  // Get entries by mood
  Future<List<JournalEntry>> getEntriesByMood(String mood) async {
    final entries = await getAllEntries();
    return entries.where((entry) => entry.mood == mood).toList();
  }

  // Get entries by tag
  Future<List<JournalEntry>> getEntriesByTag(String tag) async {
    final entries = await getAllEntries();
    return entries.where((entry) => entry.tags.contains(tag)).toList();
  }

  // Get all unique tags
  Future<List<String>> getAllTags() async {
    final entries = await getAllEntries();
    final Set<String> uniqueTags = {};

    for (final entry in entries) {
      uniqueTags.addAll(entry.tags);
    }

    return uniqueTags.toList();
  }

  // Get all unique moods
  Future<List<String>> getAllMoods() async {
    final entries = await getAllEntries();
    final Set<String> uniqueMoods = {};

    for (final entry in entries) {
      if (entry.mood != null) {
        uniqueMoods.add(entry.mood!);
      }
    }

    return uniqueMoods.toList();
  }
}
