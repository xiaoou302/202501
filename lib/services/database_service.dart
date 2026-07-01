import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_record.dart';
import '../models/journal_entry.dart';
import '../models/play_session.dart';
import '../models/moment.dart';
import '../utils/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  SharedPreferences? _prefs;
  final ValueNotifier<int> journalUpdateNotifier = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Scan Records
  Future<List<ScanRecord>> getScanRecords() async {
    final List<String> items =
        _prefs?.getStringList(AppConstants.scanStorageKey) ?? [];
    return items.map((e) => ScanRecord.fromJson(e)).toList();
  }

  Future<void> saveScanRecord(ScanRecord record) async {
    final records = await getScanRecords();
    records.add(record);
    await _prefs?.setStringList(
      AppConstants.scanStorageKey,
      records.map((e) => e.toJson()).toList(),
    );
  }

  // Journal Entries
  Future<List<JournalEntry>> getJournalEntries() async {
    final List<String> items =
        _prefs?.getStringList(AppConstants.journalStorageKey) ?? [];
    return items.map((e) => JournalEntry.fromJson(e)).toList();
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    final entries = await getJournalEntries();
    entries.add(entry);
    await _prefs?.setStringList(
      AppConstants.journalStorageKey,
      entries.map((e) => e.toJson()).toList(),
    );
    journalUpdateNotifier.value++;
  }

  Future<void> updateJournalEntry(JournalEntry updatedEntry) async {
    final entries = await getJournalEntries();
    final index = entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      entries[index] = updatedEntry;
      await _prefs?.setStringList(
        AppConstants.journalStorageKey,
        entries.map((e) => e.toJson()).toList(),
      );
      journalUpdateNotifier.value++;
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    final entries = await getJournalEntries();
    entries.removeWhere((e) => e.id == id);
    await _prefs?.setStringList(
      AppConstants.journalStorageKey,
      entries.map((e) => e.toJson()).toList(),
    );
    journalUpdateNotifier.value++;
  }

  // Play Sessions
  Future<List<PlaySession>> getPlaySessions() async {
    final List<String> items =
        _prefs?.getStringList(AppConstants.playStorageKey) ?? [];
    return items.map((e) => PlaySession.fromJson(e)).toList();
  }

  Future<void> savePlaySession(PlaySession session) async {
    final sessions = await getPlaySessions();
    sessions.add(session);
    await _prefs?.setStringList(
      AppConstants.playStorageKey,
      sessions.map((e) => e.toJson()).toList(),
    );
  }

  // Moments
  Future<List<Moment>> getMoments() async {
    final List<String> items =
        _prefs?.getStringList(AppConstants.momentStorageKey) ?? [];
    return items.map((e) => Moment.fromJson(e)).toList();
  }

  Future<void> saveMoment(Moment moment) async {
    final moments = await getMoments();
    moments.add(moment);
    await _prefs?.setStringList(
      AppConstants.momentStorageKey,
      moments.map((e) => e.toJson()).toList(),
    );
  }
}
