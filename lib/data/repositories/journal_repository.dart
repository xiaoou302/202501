import '../models/journal_model.dart';
import '../datasources/mock_data.dart';

class JournalRepository {
  List<JournalModel> _journals = [];

  JournalRepository() {
    _journals = MockData.getJournals();
  }

  Future<List<JournalModel>> getJournals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _journals;
  }

  Future<void> addJournal(JournalModel journal) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _journals.insert(0, journal);
  }

  Future<void> deleteJournal(String journalId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _journals.removeWhere((j) => j.id == journalId);
  }
}
