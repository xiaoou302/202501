import 'package:flutter/material.dart';

/// 应用状态管理
class AppState extends ChangeNotifier {
  // 当前选中的底部导航索引
  int _currentIndex = 0;

  // 获取当前索引
  int get currentIndex => _currentIndex;

  // 设置当前索引
  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners(); //sdasdasdasda
    }
  }
}
