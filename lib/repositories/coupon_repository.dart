import 'package:shared_preferences/shared_preferences.dart';
import '../models/coupon.dart';
import '../utils/helpers.dart';

class CouponRepository {
  static const String _couponsKey = 'coupons';

  // 获取所有优惠券
  Future<List<Coupon>> getAllCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    final couponsJson = prefs.getString(_couponsKey);

    if (couponsJson == null || couponsJson.isEmpty) {
      return [];
    }

    return Coupon.fromJsonList(couponsJson);
  }

  // 获取即将到期的优惠券（7天内）
  Future<List<Coupon>> getExpiringSoonCoupons() async {
    final allCoupons = await getAllCoupons();
    return allCoupons
        .where((coupon) =>
            !coupon.isUsed && coupon.isExpiringSoon && !coupon.isExpired)
        .toList();
  }

  // 保存所有优惠券
  Future<void> saveCoupons(List<Coupon> coupons) async {
    final prefs = await SharedPreferences.getInstance();
    final couponsJson = Coupon.toJsonList(coupons);
    await prefs.setString(_couponsKey, couponsJson);
  }

  // 添加新的优惠券
  Future<void> addCoupon(Coupon coupon) async {
    final coupons = await getAllCoupons();
    coupons.add(coupon);
    await saveCoupons(coupons);
  }

  // 删除优惠券
  Future<void> removeCoupon(Coupon coupon) async {
    final coupons = await getAllCoupons();
    coupons.removeWhere((c) =>
        c.title == coupon.title &&
        c.expiryDate.isAtSameMomentAs(coupon.expiryDate));
    await saveCoupons(coupons);
  }

  // 更新优惠券
  Future<void> updateCoupon(Coupon oldCoupon, Coupon newCoupon) async {
    final coupons = await getAllCoupons();
    final index = coupons.indexWhere(
      (c) =>
          c.title == oldCoupon.title &&
          c.expiryDate.isAtSameMomentAs(oldCoupon.expiryDate) &&
          c.category == oldCoupon.category,
    );

    if (index != -1) {
      coupons[index] = newCoupon;
      await saveCoupons(coupons);
    }
  }

  // 标记优惠券为已使用
  Future<void> markCouponAsUsed(Coupon coupon) async {
    final coupons = await getAllCoupons();
    final index = coupons.indexWhere((c) =>
        c.title == coupon.title &&
        c.expiryDate.isAtSameMomentAs(coupon.expiryDate));

    if (index != -1) {
      coupons[index] = coupon.copyWith(isUsed: true);
      await saveCoupons(coupons);
    }
  }

  // 按类别获取优惠券
  Future<List<Coupon>> getCouponsByCategory(String category) async {
    final allCoupons = await getAllCoupons();
    return allCoupons
        .where((coupon) =>
            coupon.category == category && !coupon.isUsed && !coupon.isExpired)
        .toList();
  }

  // 清除所有优惠券
  Future<void> clearAllCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_couponsKey);
  }

  // 获取已使用的优惠券
  Future<List<Coupon>> getUsedCoupons() async {
    final allCoupons = await getAllCoupons();
    return allCoupons.where((coupon) => coupon.isUsed).toList();
  }

  // 获取已过期的优惠券
  Future<List<Coupon>> getExpiredCoupons() async {
    final allCoupons = await getAllCoupons();
    return allCoupons
        .where((coupon) => coupon.isExpired && !coupon.isUsed)
        .toList();
  }

  // 获取有效的优惠券（未过期且未使用）
  Future<List<Coupon>> getActiveCoupons() async {
    final allCoupons = await getAllCoupons();
    return allCoupons
        .where((coupon) => !coupon.isExpired && !coupon.isUsed)
        .toList();
  }

  // 按条形码查找优惠券
  Future<Coupon?> findCouponByBarcode(String barcode) async {
    final allCoupons = await getAllCoupons();
    try {
      return allCoupons.firstWhere((coupon) => coupon.barcode == barcode);
    } catch (e) {
      return null;
    }
  }
}
