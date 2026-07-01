import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/pet_activity.dart';
import '../../widgets/play/save_activity_dialog.dart';

class ActivityGuideScreen extends StatefulWidget {
  final PetActivity activity;

  const ActivityGuideScreen({super.key, required this.activity});

  @override
  State<ActivityGuideScreen> createState() => _ActivityGuideScreenState();
}

class _ActivityGuideScreenState extends State<ActivityGuideScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _uiTimer;

  void _toggleTimer() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _uiTimer?.cancel();
      } else {
        _stopwatch.start();
        _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {});
        });
      }
    });
  }

  void _finishActivity() {
    _stopwatch.stop();
    _uiTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SaveActivityDialog(
        gameName: widget.activity.title,
        recordedDuration: _stopwatch.elapsed,
      ),
    );
  }

  String _getFormattedTime() {
    final duration = _stopwatch.elapsed;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.activity.category,
          style: const TextStyle(
            color: AppColors.chestnutGray,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.cocoaBrown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 24),
                const Text(
                  'Step-by-step Guide',
                  style: TextStyle(
                    color: AppColors.cocoaBrown,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                ...widget.activity.steps.asMap().entries.map((entry) {
                  return _buildStepCard(entry.key + 1, entry.value);
                }),
                const SizedBox(height: 32),
              ],
            ),
          ),
          _buildTimerPanel(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.activity.bgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: widget.activity.color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: widget.activity.color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.creamWhite.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.chestnutGray.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              widget.activity.icon,
              color: widget.activity.color,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.activity.title,
            style: const TextStyle(
              color: AppColors.cocoaBrown,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            widget.activity.benefits,
            style: const TextStyle(
              color: AppColors.chestnutGray,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(int step, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warmGauze.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.chestnutGray.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.activity.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: TextStyle(
                  color: widget.activity.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                desc,
                style: const TextStyle(
                  color: AppColors.cocoaBrown,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
      decoration: BoxDecoration(
        color: AppColors.creamWhite.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: widget.activity.color.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.warmGauze,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Interaction Timer',
            style: TextStyle(
              color: AppColors.chestnutGray,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getFormattedTime(),
            style: TextStyle(
              color: _stopwatch.isRunning
                  ? widget.activity.color
                  : AppColors.cocoaBrown,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              fontFeatures: const [FontFeature.tabularFigures()],
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                label: _stopwatch.isRunning ? "Pause" : "Start",
                color: _stopwatch.isRunning
                    ? AppColors.chestnutGray
                    : widget.activity.color,
                onTap: _toggleTimer,
                isPrimary: true,
              ),
              if (_stopwatch.elapsed.inSeconds > 0) ...[
                const SizedBox(width: 16),
                _buildControlButton(
                  icon: Icons.check,
                  label: "Finish",
                  color: AppColors.warmSun,
                  onTap: _finishActivity,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isPrimary ? 32 : 24,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: isPrimary ? color : AppColors.creamWhite,
          borderRadius: BorderRadius.circular(28),
          border: isPrimary
              ? null
              : Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : color, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
