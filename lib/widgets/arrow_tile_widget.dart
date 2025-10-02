import 'package:flutter/material.dart';
import '../models/arrow_tile.dart';
import '../utils/constants.dart';

/// Widget for displaying and interacting with an arrow tile
class ArrowTileWidget extends StatefulWidget {
  /// The arrow tile model
  final ArrowTile tile;

  /// Whether the tile can be clicked
  final bool canBeClicked;

  /// Callback when the tile is clicked
  final Function(ArrowTile) onTileClicked;

  /// Whether to show error animation
  final bool showError;

  /// 是否处于方向修改模式
  final bool isInDirectionChangeMode;

  /// 是否被选中用于修改方向
  final bool isSelectedForDirectionChange;

  const ArrowTileWidget({
    Key? key,
    required this.tile,
    required this.canBeClicked,
    required this.onTileClicked,
    this.showError = false,
    this.isInDirectionChangeMode = false,
    this.isSelectedForDirectionChange = false,
  }) : super(key: key);

  @override
  State<ArrowTileWidget> createState() => _ArrowTileWidgetState();
}

class _ArrowTileWidgetState extends State<ArrowTileWidget>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _hoverController;
  late AnimationController _flyController;
  late AnimationController _errorController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _scaleAnimation;
  late Animation<double> _flyAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<Color?> _glowColorAnimation;

  // State flags
  bool _isFlying = false;
  bool _isError = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();

    // Hover animation for subtle feedback
    _hoverController = AnimationController(
      duration: AnimationDurations.short,
      vsync: this,
    );

    // Flying animation when tile is clicked
    _flyController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Error animation when tile can't be clicked
    _errorController = AnimationController(
      duration: AnimationDurations.short,
      vsync: this,
    );

    // Continuous pulse animation for available tiles
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation for hover effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );

    // Flying animation with easing
    _flyAnimation = CurvedAnimation(
      parent: _flyController,
      curve: Curves.easeOutExpo,
    );

    // Rotation animation during flight
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _flyController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Fade out animation during flight
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _flyController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // Shake animation for errors
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -5.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0), weight: 1),
    ]).animate(_errorController);

    // Glow color animation for available tiles
    _glowColorAnimation =
        ColorTween(
          begin: widget.tile.color.withOpacity(0.3),
          end: widget.tile.color.withOpacity(0.8),
        ).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        );

    // Start pulsing animation if tile can be clicked
    if (widget.canBeClicked) {
      _pulseController.repeat(reverse: true);
    }

    // Animation completion handlers
    _flyController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlying = false;
        });
      }
    });

    _errorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isError = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(ArrowTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showError && !_isError) {
      _showErrorAnimation();
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _flyController.dispose();
    _errorController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _showErrorAnimation() {
    setState(() {
      _isError = true;
    });

    // Play the error shake animation
    _errorController.forward().then((_) {
      if (mounted) {
        _errorController.reset();
      }
    });
  }

  void _handleTap() {
    // 如果箭头正在飞行，不处理点击
    if (_isFlying) return;

    // 如果处于方向修改模式，只调用回调而不触发飞行动画
    if (widget.isInDirectionChangeMode) {
      // Add a small scale animation for feedback
      _hoverController.forward().then((_) => _hoverController.reverse());
      widget.onTileClicked(widget.tile);
      return;
    }

    // 正常游戏模式下的点击处理
    if (widget.canBeClicked) {
      // Stop the pulse animation
      _pulseController.stop();

      setState(() {
        _isFlying = true;
      });

      // Start the flying animation
      _flyController.forward();

      // Call the callback
      widget.onTileClicked(widget.tile);
    } else {
      _showErrorAnimation();
    }
  }

  // Handle hover state for better UX
  void _handleHoverChanged(bool isHovering) {
    if (_isHovering != isHovering && !_isFlying && !widget.tile.isRemoved) {
      setState(() {
        _isHovering = isHovering;
      });

      if (isHovering) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile.isRemoved) {
      return _buildRemovedTileDot();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _hoverController,
        _flyController,
        _errorController,
        _pulseController,
      ]),
      builder: (context, child) {
        // Calculate the flying transform based on animation progress
        final Matrix4 flyTransform = _isFlying
            ? _getFlyingTransform(widget.tile.direction, _flyAnimation.value)
            : Matrix4.identity();

        // Apply rotation during flight
        if (_isFlying) {
          final rotationFactor =
              widget.tile.direction == ArrowDirection.left ||
                  widget.tile.direction == ArrowDirection.right
              ? _rotateAnimation.value
              : -_rotateAnimation.value;

          flyTransform.rotateZ(rotationFactor);
        }

        // Apply error shake animation
        final Matrix4 errorTransform = _isError
            ? (Matrix4.identity()..translate(_shakeAnimation.value, 0.0))
            : Matrix4.identity();

        // Combine transformations
        final Matrix4 combinedTransform = Matrix4.identity()
          ..scale(_scaleAnimation.value)
          ..multiply(flyTransform)
          ..multiply(errorTransform);

        return MouseRegion(
          onEnter: (_) => _handleHoverChanged(true),
          onExit: (_) => _handleHoverChanged(false),
          child: GestureDetector(
            onTap: _handleTap,
            child: Opacity(
              opacity: _isFlying ? _fadeAnimation.value : 1.0,
              child: Transform(
                transform: combinedTransform,
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isInDirectionChangeMode
                        ? widget.tile.color.withOpacity(0.9)
                        : widget.tile.color,
                    borderRadius: BorderRadius.circular(
                      UIConstants.tileBorderRadius,
                    ),
                    border: widget.isSelectedForDirectionChange
                        ? Border.all(color: Colors.white, width: 3)
                        : widget.isInDirectionChangeMode
                        ? Border.all(color: AppColors.accentCoral, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: UIConstants.defaultShadowBlur,
                        offset: const Offset(
                          0,
                          UIConstants.defaultShadowOffset,
                        ),
                      ),
                      // Add glow effect for clickable tiles
                      if (widget.canBeClicked &&
                          !_isFlying &&
                          !widget.isInDirectionChangeMode)
                        BoxShadow(
                          color:
                              _glowColorAnimation.value ??
                              widget.tile.color.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      if (widget.isInDirectionChangeMode)
                        BoxShadow(
                          color: AppColors.accentCoral.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: widget.isSelectedForDirectionChange
                              ? 3
                              : 1,
                        ),
                      if (_isHovering &&
                          !_isFlying &&
                          !widget.isInDirectionChangeMode)
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.tile.color.withOpacity(0.9),
                        widget.tile.color,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getArrowIcon(widget.tile.direction),
                      color: Colors.white,
                      size: 28,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRemovedTileDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Center(
          child: Container(
            width: 16 * value,
            height: 16 * value,
            decoration: BoxDecoration(
              color: widget.tile.color.withOpacity(0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.tile.color.withOpacity(0.3),
                  blurRadius: 8 * value,
                  spreadRadius: 2 * value,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              gradient: RadialGradient(
                colors: [Colors.white, widget.tile.color],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  Matrix4 _getFlyingTransform(ArrowDirection direction, double progress) {
    // Calculate the distance based on the animation progress
    final distance = 400.0 * progress;

    switch (direction) {
      case ArrowDirection.up:
        return Matrix4.translationValues(0, -distance, 0);
      case ArrowDirection.down:
        return Matrix4.translationValues(0, distance, 0);
      case ArrowDirection.left:
        return Matrix4.translationValues(-distance, 0, 0);
      case ArrowDirection.right:
        return Matrix4.translationValues(distance, 0, 0);
    }
  }

  IconData _getArrowIcon(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return Icons.arrow_upward;
      case ArrowDirection.down:
        return Icons.arrow_downward;
      case ArrowDirection.left:
        return Icons.arrow_back;
      case ArrowDirection.right:
        return Icons.arrow_forward;
    }
  }
}
