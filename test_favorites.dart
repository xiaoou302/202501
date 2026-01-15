// 收藏功能测试脚本
// 这个文件用于验证收藏功能的核心逻辑

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lib/data/services/favorites_service.dart';
import 'lib/data/models/art_model.dart';

void main() {
  group('FavoritesService Tests', () {
    late FavoritesService favoritesService;
    late ArtModel testArt;

    setUp(() async {
      // 初始化测试环境
      SharedPreferences.setMockInitialValues({});
      favoritesService = FavoritesService();
      
      // 创建测试数据
      testArt = ArtModel(
        id: 'test1',
        title: 'Test Artwork',
        artistName: 'Test Artist',
        artistId: 'artist1',
        imageUrl: 'assets/test.jpg',
        categories: ['Oil Painting'],
        description: 'Test description',
        createdAt: DateTime.now(),
      );
    });

    test('应该能够添加收藏', () async {
      final result = await favoritesService.addFavorite(testArt);
      expect(result, true);
      
      final isFav = await favoritesService.isFavorite(testArt.id);
      expect(isFav, true);
    });

    test('应该能够获取收藏列表', () async {
      await favoritesService.addFavorite(testArt);
      
      final favorites = await favoritesService.getFavorites();
      expect(favorites.length, 1);
      expect(favorites.first.id, testArt.id);
    });

    test('应该能够删除收藏', () async {
      await favoritesService.addFavorite(testArt);
      
      final result = await favoritesService.removeFavorite(testArt.id);
      expect(result, true);
      
      final isFav = await favoritesService.isFavorite(testArt.id);
      expect(isFav, false);
    });

    test('应该能够切换收藏状态', () async {
      // 第一次切换：添加收藏
      var result = await favoritesService.toggleFavorite(testArt);
      expect(result, true);
      
      var isFav = await favoritesService.isFavorite(testArt.id);
      expect(isFav, true);
      
      // 第二次切换：取消收藏
      result = await favoritesService.toggleFavorite(testArt);
      expect(result, true);
      
      isFav = await favoritesService.isFavorite(testArt.id);
      expect(isFav, false);
    });

    test('不应该重复添加相同的收藏', () async {
      await favoritesService.addFavorite(testArt);
      final result = await favoritesService.addFavorite(testArt);
      
      expect(result, false);
      
      final favorites = await favoritesService.getFavorites();
      expect(favorites.length, 1);
    });

    test('应该能够清空所有收藏', () async {
      await favoritesService.addFavorite(testArt);
      await favoritesService.clearFavorites();
      
      final favorites = await favoritesService.getFavorites();
      expect(favorites.length, 0);
    });
  });
}
