import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/coupon.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CouponCard({
    super.key,
    required this.coupon,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 计算到期天数
    final daysToExpiry = DateTimeHelper.daysBetween(
      DateTime.now(),
      coupon.expiryDate,
    );
    final isExpiringSoon = daysToExpiry <= 7 && daysToExpiry >= 0;
    final isExpired = daysToExpiry < 0;

    // 根据优惠券类别选择颜色
    Color categoryColor;
    switch (coupon.category) {
      case AppStrings.couponDining:
        categoryColor = AppColors.electricBlue;
        break;
      case AppStrings.couponShopping:
        categoryColor = AppColors.hologramPurple;
        break;
      case AppStrings.couponTravel:
        categoryColor = const Color(0xFFff4d94);
        break;
      case AppStrings.couponEntertainment:
        categoryColor = const Color(0xFFFF9800); // 橙色
        break;
      case AppStrings.couponHealth:
        categoryColor = const Color(0xFF4CAF50); // 绿色
        break;
      case AppStrings.couponEducation:
        categoryColor = const Color(0xFF2196F3); // 蓝色
        break;
      default:
        categoryColor = AppColors.electricBlue;
    }

    // 构建优惠券图标
    Widget buildIcon() {
      IconData iconData;
      switch (coupon.iconName) {
        case 'utensils':
          iconData = FontAwesomeIcons.utensils;
          break;
        case 'bag-shopping':
          iconData = FontAwesomeIcons.bagShopping;
          break;
        case 'plane':
          iconData = FontAwesomeIcons.plane;
          break;
        case 'coffee':
          iconData = FontAwesomeIcons.mugHot;
          break;
        case 'graduation-cap':
          iconData = FontAwesomeIcons.graduationCap;
          break;
        case 'heart':
          iconData = FontAwesomeIcons.heart;
          break;
        case 'film':
          iconData = FontAwesomeIcons.film;
          break;
        default:
          iconData = FontAwesomeIcons.ticket;
      }

      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [categoryColor, categoryColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(iconData, color: Colors.white, size: 18),
      );
    }

    // 构建到期标签
    Widget buildExpiryBadge() {
      if (coupon.isUsed) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Used',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else if (isExpired) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Expired',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else if (isExpiringSoon) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFff4d94).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$daysToExpiry ${AppStrings.couponDaysToExpire}',
            style: const TextStyle(
              color: Color(0xFFff7eb3),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 1.seconds)
            .then(delay: 1.seconds)
            .fadeOut(duration: 1.seconds);
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$daysToExpiry ${AppStrings.couponDaysToExpire}',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: categoryColor.withOpacity(0.3), width: 1),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              buildIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coupon.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: coupon.isUsed || isExpired
                                  ? Colors.grey
                                  : AppColors.textColor,
                            ),
                          ),
                        ),
                        if (coupon.barcode != null)
                          const Icon(
                            FontAwesomeIcons.barcode,
                            size: 14,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coupon.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: (coupon.isUsed || isExpired)
                            ? Colors.grey.withOpacity(0.7)
                            : AppColors.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              buildExpiryBadge(),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.textColor.withOpacity(0.5),
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
