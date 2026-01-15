import 'package:flutter/material.dart';
import '../../data/models/journal_model.dart';
import '../../data/repositories/journal_repository.dart';

class JournalViewModel extends ChangeNotifier {
  final JournalRepository _repository;
  
  List<JournalModel> _journals = [];
  bool _isLoading = false;
  bool _showMyCreations = true;

  JournalViewModel(this._repository) {
    // 延迟加载，避免在构造函数中调用异步方法
    Future.microtask(() => loadJournals());
  }

  List<JournalModel> get journals => _journals;
  bool get isLoading => _isLoading;
  bool get showMyCreations => _showMyCreations;

  List<JournalModel> get filteredJournals {
    if (_showMyCreations) {
      return _journals;
    }
    return _journals.where((j) => j.originalArtId != null).toList();
  }

  Future<void> loadJournals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _journals = await _repository.getJournals();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleView() {
    _showMyCreations = !_showMyCreations;
    notifyListeners();
  }

  Future<void> addJournal(JournalModel journal) async {
    try {
      await _repository.addJournal(journal);
      await loadJournals();
    } catch (e) {
      // Handle error
    }
  }
}
