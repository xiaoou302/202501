import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Keyword widget with animations
class KeywordWidget extends StatefulWidget {
  final String word;
  final bool isKeyword;
  final bool isSaved;
  final bool shouldFade;
  final VoidCallback? onTap;

  const KeywordWidget({
    super.key,
    required this.word,
    this.isKeyword = false,
    this.isSaved = false,
    this.shouldFade = false,
    this.onTap,
  });

  @override
  State<KeywordWidget> createState() => _KeywordWidgetState();
}

class _KeywordWidgetState extends State<KeywordWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.isKeyword && !widget.isSaved) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(KeywordWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isKeyword && !widget.isSaved) {
      if (!_glowController.isAnimating) {
        _glowController.repeat(reverse: true);
      }
    } else {
      _glowController.stop();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSaved) {
      return _buildSavedKeyword();
    } else if (widget.isKeyword) {
      return _buildGlowingKeyword();
    } else if (widget.shouldFade) {
      return _buildFadingWord();
    } else {
      return _buildNormalWord();
    }
  }

  Widget _buildSavedKeyword() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Text(
        widget.word,
        style: const TextStyle(
          color: AppColors.accentBlue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildGlowingKeyword() {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Text(
            widget.word,
            style: TextStyle(
              color: Color.lerp(
                AppColors.accentBlue,
                AppColors.accentBlue.withOpacity(0.6),
                _glowController.value,
              ),
              fontWeight: FontWeight.w500,
              fontSize: 20,
              height: 1.6,
              shadows: [
                Shadow(
                  color: AppColors.accentBlue.withOpacity(
                    0.3 + (_glowController.value * 0.4),
                  ),
                  blurRadius: 8 + (_glowController.value * 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFadingWord() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 5),
      opacity: widget.shouldFade ? 0.0 : 1.0,
      child: Text(
        widget.word,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 20,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildNormalWord() {
    return Text(
      widget.word,
      style: const TextStyle(
        color: AppColors.textDark,
        fontSize: 20,
        height: 1.6,
      ),
    );
  }
}
