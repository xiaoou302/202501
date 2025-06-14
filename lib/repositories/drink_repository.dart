import 'package:shared_preferences/shared_preferences.dart';
import '../models/drink.dart';
import '../utils/helpers.dart';

class DrinkRepository {
  static const String _drinksKey = 'drinks';

  // 获取所有饮品记录
  Future<List<Drink>> getAllDrinks() async {
    final prefs = await SharedPreferences.getInstance();
    final drinksJson = prefs.getString(_drinksKey);

    if (drinksJson == null || drinksJson.isEmpty) {
      return [];
    }

    return Drink.fromJsonList(drinksJson);
  }

  // 获取今日饮品记录
  Future<List<Drink>> getTodayDrinks() async {
    final allDrinks = await getAllDrinks();
    final today = DateTimeHelper.startOfDay();
    final tomorrow = today.add(const Duration(days: 1));

    return allDrinks
        .where(
          (drink) => drink.time.isAfter(today) && drink.time.isBefore(tomorrow),
        )
        .toList();
  }

  // 保存所有饮品记录
  Future<void> saveDrinks(List<Drink> drinks) async {
    final prefs = await SharedPreferences.getInstance();
    final drinksJson = Drink.toJsonList(drinks);
    await prefs.setString(_drinksKey, drinksJson);
  }

  // 添加新的饮品记录
  Future<void> addDrink(Drink drink) async {
    final drinks = await getAllDrinks();
    drinks.add(drink);
    await saveDrinks(drinks);
  }

  // 删除饮品记录
  Future<void> removeDrink(Drink drink) async {
    final drinks = await getAllDrinks();
    drinks.removeWhere(
      (d) =>
          d.name == drink.name &&
          d.time.isAtSameMomentAs(drink.time) &&
          d.caffeine == drink.caffeine,
    );
    await saveDrinks(drinks);
  }

  // 更新饮品记录
  Future<void> updateDrink(Drink oldDrink, Drink newDrink) async {
    final drinks = await getAllDrinks();
    final index = drinks.indexWhere(
      (d) =>
          d.name == oldDrink.name &&
          d.time.isAtSameMomentAs(oldDrink.time) &&
          d.caffeine == oldDrink.caffeine,
    );

    if (index != -1) {
      drinks[index] = newDrink;
      await saveDrinks(drinks);
    }
  }

  // 清除所有饮品记录
  Future<void> clearAllDrinks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_drinksKey);
  }
}
