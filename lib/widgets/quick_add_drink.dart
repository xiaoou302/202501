import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/drink.dart';
import '../utils/constants.dart';

class QuickAddDrink extends StatelessWidget {
  final Function(Drink) onDrinkAdded;

  const QuickAddDrink({
    super.key,
    required this.onDrinkAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.deepSpace.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: AppColors.hologramPurple.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Add',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Common Drinks',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildQuickAddButton(
                  'Americano',
                  FontAwesomeIcons.mugHot,
                  AppColors.electricBlue,
                  240,
                ),
                _buildQuickAddButton(
                  'Latte',
                  FontAwesomeIcons.mugHot,
                  const Color(0xFF9c6dff),
                  300,
                ),
                _buildQuickAddButton(
                  'Espresso',
                  FontAwesomeIcons.mugSaucer,
                  AppColors.hologramPurple,
                  60,
                ),
                _buildQuickAddButton(
                  'Black Tea',
                  FontAwesomeIcons.mugSaucer,
                  const Color(0xFFff7070),
                  250,
                ),
                _buildQuickAddButton(
                  'Green Tea',
                  FontAwesomeIcons.glassWater,
                  const Color(0xFF80ff80),
                  300,
                ),
                _buildQuickAddButton(
                  'Energy Drink',
                  FontAwesomeIcons.bolt,
                  const Color(0xFFff4d94),
                  330,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddButton(
    String drinkName,
    IconData icon,
    Color color,
    int volume,
  ) {
    // 获取咖啡因含量
    final caffeinePerMl = CaffeineConstants.caffeineContent[drinkName] ?? 0;
    final caffeine = (volume * caffeinePerMl).round();

    // 获取饮品分类
    final category = CaffeineConstants.drinkCategories[drinkName] ?? 'Other';

    return _AnimatedQuickAddButton(
      drinkName: drinkName,
      icon: icon,
      color: color,
      volume: volume,
      caffeine: caffeine,
      category: category,
      onTap: () {
        final drink = Drink(
          name: drinkName,
          volume: volume,
          caffeine: caffeine,
          time: DateTime.now(),
          icon: CaffeineConstants.drinkIcons[drinkName] ?? 'mug-hot',
          category: category,
        );
        onDrinkAdded(drink);
      },
    );
  }
}

class _AnimatedQuickAddButton extends StatefulWidget {
  final String drinkName;
  final IconData icon;
  final Color color;
  final int volume;
  final int caffeine;
  final String category;
  final VoidCallback onTap;

  const _AnimatedQuickAddButton({
    required this.drinkName,
    required this.icon,
    required this.color,
    required this.volume,
    required this.caffeine,
    required this.category,
    required this.onTap,
  });

  @override
  State<_AnimatedQuickAddButton> createState() =>
      _AnimatedQuickAddButtonState();
}

class _AnimatedQuickAddButtonState extends State<_AnimatedQuickAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (!_isPressed) {
          _controller.forward(from: 0.3);
        }
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!_isPressed) {
          _controller.reverse(from: 0.5);
        }
      },
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedback.lightImpact(); // 触觉反馈
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (_isHovered) {
            _controller.reverse(from: 0.7).then((_) {
              widget.onTap();
              _controller.forward(from: 0.3);
            });
          } else {
            _controller.reverse().then((_) => widget.onTap());
          }
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          if (_isHovered) {
            _controller.reverse(from: 0.7);
          } else {
            _controller.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 90,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: _isPressed
                      ? widget.color.withOpacity(0.3)
                      : _isHovered
                          ? AppColors.nebulaPurple.withOpacity(0.6)
                          : AppColors.nebulaPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.color.withOpacity(_isPressed
                        ? 0.8
                        : _isHovered
                            ? 0.7
                            : 0.3),
                    width: _isPressed
                        ? 2.0
                        : _isHovered
                            ? 1.5
                            : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(_isPressed
                          ? 0.4
                          : _isHovered
                              ? 0.3
                              : _opacityAnimation.value),
                      blurRadius: _isPressed
                          ? 18
                          : _isHovered
                              ? 15
                              : 10,
                      spreadRadius: _isPressed
                          ? 2
                          : _isHovered
                              ? 1
                              : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color,
                            _isPressed
                                ? widget.color.withOpacity(0.9)
                                : _isHovered
                                    ? widget.color.withOpacity(0.8)
                                    : widget.color.withOpacity(0.7)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(_isPressed
                                ? 0.6
                                : _isHovered
                                    ? 0.4
                                    : 0.2),
                            blurRadius: _isPressed
                                ? 15
                                : _isHovered
                                    ? 12
                                    : 8,
                            spreadRadius: _isPressed
                                ? 3
                                : _isHovered
                                    ? 2
                                    : 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: _isPressed ? 18 : 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.drinkName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _isPressed || _isHovered
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _isPressed
                            ? widget.color
                            : _isHovered
                                ? widget.color.withOpacity(0.9)
                                : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.volume}ml · ${widget.caffeine}mg',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(_isPressed
                            ? 1.0
                            : _isHovered
                                ? 0.9
                                : 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
