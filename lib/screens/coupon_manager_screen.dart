import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/coupon.dart';
import '../repositories/coupon_repository.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/coupon_card.dart';

class CouponManagerScreen extends StatefulWidget {
  const CouponManagerScreen({super.key});

  @override
  CouponManagerScreenState createState() => CouponManagerScreenState();
}

class CouponManagerScreenState extends State<CouponManagerScreen>
    with SingleTickerProviderStateMixin {
  final CouponRepository _couponRepository = CouponRepository();
  List<Coupon> _allCoupons = [];
  List<Coupon> _expiringSoonCoupons = [];
  Map<String, List<Coupon>> _categorizedCoupons = {};
  bool _isLoading = true;

  // 筛选状态
  String _filterStatus = AppStrings.couponActive; // 'Active', 'Used', 'Expired'

  // 分类标签
  final List<String> _categories = [
    AppStrings.couponDining,
    AppStrings.couponShopping,
    AppStrings.couponTravel,
    AppStrings.couponEntertainment,
    AppStrings.couponHealth,
    AppStrings.couponEducation,
  ];

  // 当前选中的分类
  String _selectedCategory = AppStrings.couponDining;

  // 动画控制器
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadCoupons();

    // 初始化动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 加载优惠券数据
  Future<void> _loadCoupons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Coupon> filteredCoupons;

      // 根据筛选状态获取不同的优惠券列表
      switch (_filterStatus) {
        case AppStrings.couponActive:
          filteredCoupons = await _couponRepository.getActiveCoupons();
          break;
        case AppStrings.couponUsed:
          filteredCoupons = await _couponRepository.getUsedCoupons();
          break;
        case AppStrings.couponExpired:
          filteredCoupons = await _couponRepository.getExpiredCoupons();
          break;
        default:
          filteredCoupons = await _couponRepository.getActiveCoupons();
      }

      final allCoupons = await _couponRepository.getAllCoupons();
      final expiringSoonCoupons =
          await _couponRepository.getExpiringSoonCoupons();

      // 按类别分类优惠券
      final categorizedCoupons = <String, List<Coupon>>{};
      for (final category in _categories) {
        categorizedCoupons[category] = filteredCoupons
            .where((coupon) => coupon.category == category)
            .toList();
      }

      setState(() {
        _allCoupons = allCoupons;
        _expiringSoonCoupons = expiringSoonCoupons;
        _categorizedCoupons = categorizedCoupons;
        _isLoading = false;
      });
    } catch (e) {
      // 处理错误
      debugPrint('加载优惠券数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 添加优惠券
  Future<void> _addCoupon(Coupon coupon) async {
    try {
      await _couponRepository.addCoupon(coupon);
      _loadCoupons(); // 重新加载数据
    } catch (e) {
      debugPrint('添加优惠券失败: $e');
    }
  }

  // 删除优惠券
  Future<void> _deleteCoupon(Coupon coupon) async {
    try {
      await _couponRepository.removeCoupon(coupon);
      _loadCoupons(); // 重新加载数据
    } catch (e) {
      debugPrint('删除优惠券失败: $e');
    }
  }

  // 标记优惠券为已使用
  Future<void> _markCouponAsUsed(Coupon coupon) async {
    try {
      await _couponRepository.markCouponAsUsed(coupon);
      _loadCoupons(); // 重新加载数据
    } catch (e) {
      debugPrint('标记优惠券失败: $e');
    }
  }

  // 显示添加优惠券对话框
  void showAddCouponDialog({String? scannedBarcode}) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final expiryDateController = TextEditingController();
    final barcodeController = TextEditingController(text: scannedBarcode ?? '');
    String selectedCategory = _categories.first;
    String selectedIcon = 'utensils';
    DateTime? selectedDate;

    // 表单验证Key
    final formKey = GlobalKey<FormState>();

    // 图标选项
    final iconOptions = {
      'utensils': FontAwesomeIcons.utensils,
      'bag-shopping': FontAwesomeIcons.bagShopping,
      'plane': FontAwesomeIcons.plane,
      'coffee': FontAwesomeIcons.mugHot,
      'graduation-cap': FontAwesomeIcons.graduationCap,
      'heart': FontAwesomeIcons.heart,
      'film': FontAwesomeIcons.film,
    };

    // 根据类别自动选择图标
    Map<String, String> categoryToIconMap = {
      AppStrings.couponDining: 'utensils',
      AppStrings.couponShopping: 'bag-shopping',
      AppStrings.couponTravel: 'plane',
      AppStrings.couponEntertainment: 'film',
      AppStrings.couponHealth: 'heart',
      AppStrings.couponEducation: 'graduation-cap',
    };

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // 选择日期
            Future<void> _selectDate(BuildContext context) async {
              // Dismiss keyboard before showing date picker
              FocusManager.instance.primaryFocus?.unfocus();

              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ??
                    DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                  expiryDateController.text = DateFormat(
                    'yyyy-MM-dd',
                  ).format(picked);
                });
              }
            }

            return GestureDetector(
              // Dismiss keyboard when tapping anywhere on the dialog
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: AlertDialog(
                backgroundColor: AppColors.deepSpace,
                title: const Text('Add Coupon'),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 标题输入
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Coupon Title',
                            border: OutlineInputBorder(),
                            hintText: 'Enter coupon title',
                          ),
                          maxLength: 30, // 限制最大长度
                          textInputAction: TextInputAction.next, // 点击下一步
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            if (value.length < 2) {
                              return 'Title must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 描述输入
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Coupon Description',
                            border: OutlineInputBorder(),
                            hintText: 'Enter coupon description',
                          ),
                          maxLines: 2,
                          maxLength: 100, // 限制最大长度
                          textInputAction: TextInputAction.next, // 点击下一步
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.length < 5) {
                              return 'Description must be at least 5 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 到期日期选择
                        TextFormField(
                          controller: expiryDateController,
                          decoration: InputDecoration(
                            labelText: 'Expiry Date',
                            border: const OutlineInputBorder(),
                            hintText: 'Select expiry date',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          readOnly: true, // 设置为只读，不允许手动输入
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an expiry date';
                            }
                            return null;
                          },
                          onTap: () => _selectDate(context), // 点击文本框也能打开日期选择器
                        ),
                        const SizedBox(height: 16),

                        // 条码输入
                        if (scannedBarcode != null)
                          TextFormField(
                            controller: barcodeController,
                            decoration: InputDecoration(
                              labelText: 'Barcode',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(FontAwesomeIcons.barcode),
                                onPressed: () {
                                  // 可以添加重新扫描的功能
                                  Navigator.pop(context);
                                  scanCoupon();
                                },
                              ),
                            ),
                            readOnly: true, // 设置为只读，不允许手动输入
                          ),
                        if (scannedBarcode != null) const SizedBox(height: 16),

                        // 类别选择
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // Dismiss keyboard when changing dropdown
                              FocusManager.instance.primaryFocus?.unfocus();

                              setState(() {
                                selectedCategory = newValue;
                                // 根据类别自动选择图标
                                selectedIcon =
                                    categoryToIconMap[newValue] ?? 'ticket';
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 图标选择
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Select Icon'),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              children: iconOptions.entries.map((entry) {
                                final isSelected = entry.key == selectedIcon;
                                return InkWell(
                                  onTap: () {
                                    // Dismiss keyboard when selecting icon
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    setState(() {
                                      selectedIcon = entry.key;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.hologramPurple
                                              .withOpacity(0.3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.hologramPurple
                                            : Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Icon(
                                      entry.value,
                                      color: isSelected
                                          ? AppColors.hologramPurple
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Dismiss keyboard before validation
                      FocusManager.instance.primaryFocus?.unfocus();

                      // 验证表单
                      if (formKey.currentState?.validate() != true) {
                        return;
                      }

                      // 创建新的优惠券
                      final coupon = Coupon(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        expiryDate: selectedDate!,
                        category: selectedCategory,
                        iconName: selectedIcon,
                        barcode: barcodeController.text.isNotEmpty
                            ? barcodeController.text
                            : null,
                      );

                      _addCoupon(coupon);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 扫描优惠券
  Future<void> scanCoupon() async {
    // 先收起键盘
    FocusManager.instance.primaryFocus?.unfocus();

    // 这里是扫描优惠券的逻辑，实际应用中需要集成扫码库
    // 例如 flutter_barcode_scanner 或 mobile_scanner

    // 模拟扫描结果
    await Future.delayed(const Duration(seconds: 1));

    // 显示扫描结果对话框
    if (!mounted) return;

    final scannedCode = "SCANNED_CODE_${DateTime.now().millisecondsSinceEpoch}";

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        // 确保点击对话框任何位置都能收起键盘
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AlertDialog(
          backgroundColor: AppColors.deepSpace,
          title: Text(
            AppStrings.couponScan,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.nebulaPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  FontAwesomeIcons.qrcode,
                  size: 50,
                  color: AppColors.hologramPurple,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Scan successful! Barcode: $scannedCode",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showAddCouponDialog(scannedBarcode: scannedCode);
              },
              child: Text(AppStrings.couponAdd),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // 底部不需要安全区域，因为有底部导航栏
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, // 确保即使点击空白区域也能触发
        onTap: () {
          // 点击非输入区域时收起键盘
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.hologramPurple,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题栏
                    _buildHeader(),
                    const SizedBox(height: 20),

                    // 优惠券轨道
                    _buildCouponOrbit(),
                    const SizedBox(height: 24),

                    // 状态筛选器
                    _buildStatusFilter(),
                    const SizedBox(height: 20),

                    // 类别选择器
                    _buildCategorySelector(),
                    const SizedBox(height: 20),

                    // 即将到期的优惠券
                    if (_filterStatus == AppStrings.couponActive)
                      _buildExpiringSoonCoupons(),
                    if (_filterStatus == AppStrings.couponActive)
                      const SizedBox(height: 16),

                    // 当前类别的优惠券
                    _buildCategorizedCoupons(),
                  ],
                ),
        ),
      ),
    );
  }

  // 构建标题栏
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          AppStrings.couponTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // 构建优惠券轨道
  Widget _buildCouponOrbit() {
    return Center(
      child: Container(
        width: 260,
        height: 260,
        decoration: UIHelper.glassDecoration(
          radius: 130,
          opacity: 0.05,
          borderColor: AppColors.hologramPurple.withOpacity(0.2),
          borderWidth: 1.5,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 轨道背景
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.hologramPurple.withOpacity(0.4),
                  width: 1,
                ),
              ),
            ),

            // 轨道光晕效果
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricBlue.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),

            // 优惠券卫星
            ..._buildCouponSatellites(),
          ],
        ),
      ),
    );
  }

  // 构建优惠券卫星
  List<Widget> _buildCouponSatellites() {
    // 为每个类别选择一个优惠券作为卫星
    final satellites = <Widget>[];

    // 计算卫星位置的辅助函数
    Widget buildSatellite(String category, double angle) {
      final coupons = _categorizedCoupons[category] ?? [];
      if (coupons.isEmpty) return const SizedBox.shrink();

      // 选择第一个优惠券
      final coupon = coupons.first;

      // 计算位置
      final radius = 110.0; // 轨道半径，调整为更小的值
      final x = radius * cos(angle);
      final y = radius * sin(angle);

      // 根据类别选择图标
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

      // 根据类别选择颜色
      Color categoryColor;
      switch (category) {
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

      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // 计算动画角度
          final animatedAngle =
              angle + _animationController.value * 2 * 3.14159;
          final animatedX = radius * cos(animatedAngle);
          final animatedY = radius * sin(animatedAngle);

          return Positioned(
            left: 130 + animatedX - 30, // 中心点偏移，调整卫星大小
            top: 130 + animatedY - 30, // 中心点偏移，调整卫星大小
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                width: 60, // 减小卫星大小
                height: 60, // 减小卫星大小
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.8),
                      AppColors.deepSpace.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: categoryColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: categoryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(iconData, color: categoryColor, size: 22),
              ),
            ),
          );
        },
      );
    }

    // 为每个类别创建一个卫星
    for (int i = 0; i < _categories.length; i++) {
      final angle = 2 * 3.14159 * i / _categories.length;
      satellites.add(buildSatellite(_categories[i], angle));
    }

    return satellites;
  }

  // 构建状态筛选器
  Widget _buildStatusFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip(AppStrings.couponActive),
          const SizedBox(width: 8),
          _buildFilterChip(AppStrings.couponUsed),
          const SizedBox(width: 8),
          _buildFilterChip(AppStrings.couponExpired),
        ],
      ),
    );
  }

  // 构建筛选选项
  Widget _buildFilterChip(String status) {
    final isSelected = _filterStatus == status;
    return Expanded(
      child: InkWell(
        onTap: () {
          // 收起键盘
          FocusScope.of(context).unfocus();

          setState(() {
            _filterStatus = status;
            _loadCoupons(); // 重新加载数据
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.electricBlue.withOpacity(0.2),
                      AppColors.hologramPurple.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.hologramPurple
                  : AppColors.hologramPurple.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              status,
              style: TextStyle(
                color: isSelected
                    ? AppColors.hologramPurple
                    : AppColors.textColor.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 构建类别选择器
  Widget _buildCategorySelector() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: _categories.map((category) {
            // 获取该类别的优惠券数量
            final coupons = _categorizedCoupons[category] ?? [];
            final count = coupons.length;

            // 判断是否为当前选中的类别
            final isSelected = category == _selectedCategory;

            // 根据类别选择颜色
            Color categoryColor;
            switch (category) {
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

            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  // 收起键盘
                  FocusScope.of(context).unfocus();

                  setState(() {
                    _selectedCategory = category;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              categoryColor.withOpacity(0.2),
                              AppColors.deepSpace.withOpacity(0.5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? categoryColor
                          : AppColors.hologramPurple.withOpacity(0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: categoryColor.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? categoryColor
                              : AppColors.textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? categoryColor.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? categoryColor.withOpacity(0.7)
                                : AppColors.textColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 构建即将到期的优惠券
  Widget _buildExpiringSoonCoupons() {
    if (_expiringSoonCoupons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(16),
      decoration: UIHelper.glassDecoration(
        radius: 20,
        opacity: 0.05,
        borderColor: const Color(0xFFff4d94).withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.hourglassHalf,
                size: 16,
                color: Color(0xFFff4d94),
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.couponExpiringSoon,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFff7eb3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._expiringSoonCoupons.take(2).map((coupon) {
            return CouponCard(
              coupon: coupon,
              onTap: () => _showCouponDetails(coupon),
              onDelete: () => _deleteCoupon(coupon),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 构建分类优惠券
  Widget _buildCategorizedCoupons() {
    final coupons = _categorizedCoupons[_selectedCategory] ?? [];

    // 根据类别选择颜色
    Color categoryColor;
    switch (_selectedCategory) {
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

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(16),
        decoration: UIHelper.glassDecoration(
          radius: 20,
          opacity: 0.05,
          borderColor: categoryColor.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(_selectedCategory),
                      size: 16,
                      color: categoryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedCategory,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${coupons.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: categoryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: coupons.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getEmptyStateIcon(),
                            size: 48,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getEmptyStateMessage(),
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: coupons.length,
                      itemBuilder: (context, index) {
                        final coupon = coupons[index];
                        return CouponCard(
                          coupon: coupon,
                          onTap: () => _showCouponDetails(coupon),
                          onDelete: () => _deleteCoupon(coupon),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取空状态图标
  IconData _getEmptyStateIcon() {
    switch (_filterStatus) {
      case AppStrings.couponActive:
        return FontAwesomeIcons.ticket;
      case AppStrings.couponUsed:
        return FontAwesomeIcons.checkDouble;
      case AppStrings.couponExpired:
        return FontAwesomeIcons.hourglassEnd;
      default:
        return FontAwesomeIcons.ticket;
    }
  }

  // 获取空状态消息
  String _getEmptyStateMessage() {
    switch (_filterStatus) {
      case AppStrings.couponActive:
        return 'No ${_selectedCategory} coupons available';
      case AppStrings.couponUsed:
        return 'No used ${_selectedCategory} coupons';
      case AppStrings.couponExpired:
        return 'No expired ${_selectedCategory} coupons';
      default:
        return 'No ${_selectedCategory} coupons';
    }
  }

  // 获取类别图标
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case AppStrings.couponDining:
        return FontAwesomeIcons.utensils;
      case AppStrings.couponShopping:
        return FontAwesomeIcons.bagShopping;
      case AppStrings.couponTravel:
        return FontAwesomeIcons.plane;
      case AppStrings.couponEntertainment:
        return FontAwesomeIcons.film;
      case AppStrings.couponHealth:
        return FontAwesomeIcons.heart;
      case AppStrings.couponEducation:
        return FontAwesomeIcons.graduationCap;
      default:
        return FontAwesomeIcons.ticket;
    }
  }

  // 显示优惠券详情
  void _showCouponDetails(Coupon coupon) {
    // 先收起键盘
    FocusManager.instance.primaryFocus?.unfocus();

    // 根据类别选择颜色
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
        categoryColor = const Color(0xFFFF9800);
        break;
      case AppStrings.couponHealth:
        categoryColor = const Color(0xFF4CAF50);
        break;
      case AppStrings.couponEducation:
        categoryColor = const Color(0xFF2196F3);
        break;
      default:
        categoryColor = AppColors.electricBlue;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          // 确保点击底部表单任何位置都能收起键盘
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.deepSpace,
                  AppColors.nebulaPurple.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Text(
                  coupon.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
                const SizedBox(height: 8),

                // 描述
                Text(
                  coupon.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 到期日期
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Expiry Date: ${DateFormat('yyyy-MM-dd').format(coupon.expiryDate)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 类别
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_getCategoryIcon(coupon.category),
                        size: 16, color: categoryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Category: ${coupon.category}',
                      style: TextStyle(color: categoryColor),
                    ),
                  ],
                ),

                // 条形码信息（如果有）
                if (coupon.barcode != null) ...[
                  const SizedBox(height: 24),
                  // 显示条形码
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            FontAwesomeIcons.barcode,
                            size: 60,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coupon.barcode!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // 操作按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: Text(AppStrings.couponDelete),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        _deleteCoupon(coupon);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(AppStrings.couponUse),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor.withOpacity(0.2),
                        foregroundColor: categoryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        _markCouponAsUsed(coupon);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
