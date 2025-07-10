import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// 灵动岛状态提示组件
class DynamicIsland extends StatelessWidget {
  final String message;
  final IconData icon;
  final bool isVisible;
  final Duration duration;
  final VoidCallback? onTap;

  const DynamicIsland({
    Key? key,
    required this.message,
    required this.icon,
    this.isVisible = true,
    this.duration = const Duration(seconds: 3),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Visibility(
        visible: isVisible,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
            ),
            width: 126,
            height: 37,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 14, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message,
                          style: AppStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 灵动岛控制器
class DynamicIslandController {
  final BuildContext context;
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;
  Timer? _timer;

  DynamicIslandController(this.context);

  /// 显示灵动岛
  void show({
    required String message,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    if (_isVisible) {
      _hide();
    }

    _overlayEntry = OverlayEntry(
      builder:
          (context) => DynamicIsland(
            message: message,
            icon: icon,
            isVisible: true,
            duration: duration,
            onTap: onTap,
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;

    _timer = Timer(duration, () {
      _hide();
    });
  }

  /// 隐藏灵动岛
  void _hide() {
    _timer?.cancel();
    _timer = null;

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    _isVisible = false;
  }

  /// 释放资源
  void dispose() {
    _hide();
  }
}
 