import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../utils/constants.dart';
import 'caffeine_tracker_screen.dart';
import 'coupon_manager_screen.dart';
import 'color_generator_screen.dart';
import 'settings_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<CaffeineTrackerScreenState> _caffeineTrackerKey =
      GlobalKey<CaffeineTrackerScreenState>();
  final GlobalKey<CouponManagerScreenState> _couponManagerKey =
      GlobalKey<CouponManagerScreenState>();
  late final AnimationController _backgroundAnimationController;

  // 页面列表
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for background
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    // Initialize pages with keys
    _pages = [
      CaffeineTrackerScreen(key: _caffeineTrackerKey),
      CouponManagerScreen(key: _couponManagerKey),
      const ColorGeneratorScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  // 底部导航项
  final List<Map<String, dynamic>> _navItems = [
    {'icon': FontAwesomeIcons.mugHot, 'label': AppStrings.navCaffeine},
    {'icon': FontAwesomeIcons.ticket, 'label': AppStrings.navCoupons},
    {'icon': FontAwesomeIcons.palette, 'label': AppStrings.navColors},
    {'icon': FontAwesomeIcons.gear, 'label': AppStrings.navSettings},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),

          // 优化后的背景特效
          AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter: _EnhancedBackgroundPainter(
                  animation: _backgroundAnimationController.value,
                ),
                size: MediaQuery.of(context).size,
              );
            },
          ),

          // 当前页面
          _pages[_currentIndex],
        ],
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // 构建底部导航栏
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.deepSpace.withOpacity(0.95),
            AppColors.nebulaPurple.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.hologramPurple.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.hologramPurple,
        unselectedItemColor: AppColors.electricBlue,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: FaIcon(item['icon'], size: 18),
            activeIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.hologramPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.hologramPurple.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: FaIcon(item['icon'], size: 18),
            ),
            label: item['label'],
          );
        }).toList(),
      ),
    );
  }

  // 构建浮动操作按钮
  Widget _buildFab() {
    // 根据当前页面返回不同的FAB
    Widget fab;

    switch (_currentIndex) {
      case 0: // 咖啡因追踪
        fab = FloatingActionButton(
          onPressed: () {
            // 使用与咖啡因追踪页面相同的添加功能
            if (_caffeineTrackerKey.currentState != null) {
              _caffeineTrackerKey.currentState!.showAddDrinkDialog();
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.hologramPurple.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        );
        break;

      case 1: // 优惠券管理
        fab = FloatingActionButton(
          onPressed: () {
            // 添加新优惠券
            _showAddCouponDialog();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.hologramPurple.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        );
        break;

      case 2: // 配色生成器
        fab = FloatingActionButton(
          onPressed: () {
            // 导出当前配色方案，与右上角的导出按钮功能保持一致
            _exportCurrentColorScheme();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.hologramPurple.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(FontAwesomeIcons.fileExport,
                color: Colors.white, size: 24),
          ),
        );
        break;

      case 3: // 设置页面
        // 设置页面不需要FAB
        fab = const SizedBox.shrink();
        break;

      default:
        fab = const SizedBox.shrink();
    }

    return fab.animate().scale(duration: 300.ms, curve: Curves.easeOutBack);
  }

  // 显示添加优惠券对话框
  void _showAddCouponDialog() {
    // 使用GlobalKey调用CouponManagerScreen中的添加优惠券方法
    if (_couponManagerKey.currentState != null) {
      _couponManagerKey.currentState!.showAddCouponDialog();
    }
  }

  // 导出当前配色方案
  void _exportCurrentColorScheme() {
    // 通过全局键访问ColorGeneratorScreen的导出方法
    // 由于ColorGeneratorScreen没有使用GlobalKey，我们需要使用NotificationListener或其他方式
    // 这里我们使用简单的对话框展示，实际应用中可以通过Provider或其他状态管理方式实现
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.deepSpace,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.colorExportTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildExportItem('HEX', '#B967FF'),
              _buildExportItem('RGB', 'RGB(185, 103, 255)'),
              _buildExportItem('HSL', 'HSL(270, 100%, 70%)'),
              const SizedBox(height: 16),
              Text(
                AppStrings.colorCopyToClipboard,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建导出项
  Widget _buildExportItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nebulaPurple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              InkWell(
                onTap: () {
                  _copyColorValue(value);
                },
                child: Text(value,
                    style: const TextStyle(fontFamily: 'monospace')),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  _copyColorValue(value);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.hologramPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.content_copy,
                      size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 复制颜色值到剪贴板
  void _copyColorValue(String value) {
    Clipboard.setData(ClipboardData(text: value)).then((_) {
      _showEnhancedSnackBar(
        message: '已复制: $value',
        icon: Icons.content_copy,
        backgroundColor: AppColors.electricBlue.withOpacity(0.8),
      );
    });
  }

  // 显示增强的提示弹窗
  void _showEnhancedSnackBar({
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 8,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // 显示保存配色方案对话框
  void _showSaveColorSchemeDialog() {
    // 此处为占位，实际功能将在ColorGeneratorScreen中实现
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('保存配色方案'),
        content: const Text('这里将显示保存配色方案的表单'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}

// 优化后的背景效果绘制器
class _EnhancedBackgroundPainter extends CustomPainter {
  final double animation;

  _EnhancedBackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // 创建一个星空效果，更加高级和柔和
    _paintStarryBackground(canvas, size);
  }

  void _paintStarryBackground(Canvas canvas, Size size) {
    final random = math.Random(42); // 固定种子使位置稳定，但动画仍会改变

    // 绘制三种不同类型的星星：小亮点、中等亮度的星星和大亮星
    _drawSmallStars(canvas, size, random);
    _drawMediumStars(canvas, size, random);
    _drawLargeStars(canvas, size, random);
    _drawNebulae(canvas, size, random);
  }

  void _drawSmallStars(Canvas canvas, Size size, math.Random random) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // 绘制小星星 - 数量较多但不密集
    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // 使用动画值使星星微微闪烁
      final flickerSpeed = 2.0 + random.nextDouble() * 3;
      final flicker =
          (math.sin(animation * flickerSpeed * math.pi + i) + 1) / 2;

      final radius = 0.5 + random.nextDouble() * 0.5;
      paint.color = Colors.white.withOpacity(0.2 + flicker * 0.2);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawMediumStars(Canvas canvas, Size size, math.Random random) {
    // 绘制中等大小的星星 - 少量，带有柔和的光晕
    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // 使用动画值使星星缓慢闪烁
      final flickerSpeed = 0.8 + random.nextDouble() * 1.5;
      final flicker =
          (math.sin(animation * flickerSpeed * math.pi + i) + 1) / 2;

      // 内部亮点
      final innerRadius = 1.0 + random.nextDouble() * 0.5;
      final innerPaint = Paint()
        ..color = Colors.white.withOpacity(0.4 + flicker * 0.4)
        ..style = PaintingStyle.fill;

      // 外部光晕
      final outerRadius = innerRadius + 2.0 + random.nextDouble() * 2.0;
      final outerPaint = Paint()
        ..color = AppColors.electricBlue.withOpacity(0.05 + flicker * 0.1)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      canvas.drawCircle(Offset(x, y), outerRadius, outerPaint);
      canvas.drawCircle(Offset(x, y), innerRadius, innerPaint);
    }
  }

  void _drawLargeStars(Canvas canvas, Size size, math.Random random) {
    // 绘制几个较大的亮星 - 数量非常少，但更加明显
    final starColors = [
      AppColors.electricBlue,
      AppColors.hologramPurple,
      const Color(0xFFAED6F1), // 浅蓝色
      const Color(0xFFF9E79F), // 淡黄色
    ];

    for (int i = 0; i < 7; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // 缓慢闪烁
      final flickerSpeed = 0.3 + random.nextDouble() * 0.5;
      final flicker =
          (math.sin(animation * flickerSpeed * math.pi + i * 1.5) + 1) / 2;

      // 选择随机颜色
      final color = starColors[random.nextInt(starColors.length)];

      // 多层光晕效果
      final baseRadius = 1.5 + random.nextDouble();

      // 最外层光晕 (最模糊)
      final outerGlowPaint = Paint()
        ..color = color.withOpacity(0.05 + flicker * 0.05)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

      // 中间光晕
      final middleGlowPaint = Paint()
        ..color = color.withOpacity(0.1 + flicker * 0.1)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      // 内部光晕
      final innerGlowPaint = Paint()
        ..color = color.withOpacity(0.2 + flicker * 0.2)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      // 核心
      final corePaint = Paint()
        ..color = Colors.white.withOpacity(0.7 + flicker * 0.3)
        ..style = PaintingStyle.fill;

      // 绘制各层
      canvas.drawCircle(Offset(x, y), baseRadius * 8.0, outerGlowPaint);
      canvas.drawCircle(Offset(x, y), baseRadius * 4.0, middleGlowPaint);
      canvas.drawCircle(Offset(x, y), baseRadius * 2.0, innerGlowPaint);
      canvas.drawCircle(Offset(x, y), baseRadius, corePaint);
    }
  }

  void _drawNebulae(Canvas canvas, Size size, math.Random random) {
    // 添加几处柔和的星云状背景效果
    for (int i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // 随机选择颜色
      final colors = [
        AppColors.electricBlue,
        AppColors.hologramPurple,
        const Color(0xFF1A237E).withOpacity(0.05), // 深蓝色
        const Color(0xFF4A148C).withOpacity(0.05), // 深紫色
      ];
      final color = colors[random.nextInt(colors.length)];

      // 形成大型柔和区域
      final nebulaRadius = 100.0 + random.nextDouble() * 150.0;
      final nebulaPaint = Paint()
        ..color = color.withOpacity(0.03)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50.0);

      canvas.drawCircle(Offset(x, y), nebulaRadius, nebulaPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnhancedBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
