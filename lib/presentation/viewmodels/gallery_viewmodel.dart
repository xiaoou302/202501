import 'package:flutter/material.dart';
import '../../data/models/art_model.dart';
import '../../data/repositories/art_repository.dart';

class GalleryViewModel extends ChangeNotifier {
  final ArtRepository _repository;
  
  List<ArtModel> _arts = [];
  List<String> _selectedCategories = ['All'];
  bool _isLoading = false;
  String? _error;

  GalleryViewModel(this._repository) {
    // 延迟加载，避免在构造函数中调用异步方法
    Future.microtask(() => loadArts());
  }

  List<ArtModel> get arts => _arts;
  List<String> get selectedCategories => _selectedCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadArts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _arts = await _repository.getGalleryArts(categories: _selectedCategories);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    if (category == 'All') {
      _selectedCategories = ['All'];
    } else {
      _selectedCategories.remove('All');
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
        if (_selectedCategories.isEmpty) {
          _selectedCategories = ['All'];
        }
      } else {
        _selectedCategories.add(category);
      }
    }
    loadArts();
  }

  Future<void> addToCollection(String artId) async {
    try {
      await _repository.addToCollection(artId);
      await loadArts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
