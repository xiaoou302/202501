import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/widgets/glass_panel.dart';

class TankWireframe extends StatelessWidget {
  final double fillPercentage; // 0.0 to 1.0
  final double netVolume;
  final double grossVolume;

  const TankWireframe({
    super.key,
    this.fillPercentage = 0.8,
    required this.netVolume,
    required this.grossVolume,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      height: 200,
      width: double.infinity,
      borderRadius: BorderRadius.circular(24),
      borderColor: AppColors.aquaCyan.withValues(alpha: 0.3),
      child: Stack(
        children: [
          // Grid Background
          CustomPaint(size: Size.infinite, painter: _GridPainter()),

          // Tank Box
          Center(
            child: Container(
              width: 160,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.mossMuted.withValues(alpha: 0.5),
                  width: 2,
                ),
                color: AppColors.trenchBlue.withValues(alpha: 0.3),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Water
                  FractionallySizedBox(
                    heightFactor: fillPercentage,
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.aquaCyan.withValues(alpha: 0.4),
                            AppColors.aquaCyan.withValues(alpha: 0.1),
                          ],
                        ),
                        border: Border(
                          top: BorderSide(
                            color: AppColors.aquaCyan.withValues(alpha: 0.8),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Hardscape Blob (Simplified)
                  Positioned(
                    left: 20,
                    bottom: 0,
                    child: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.trenchBlue,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                        border: Border.all(
                          color: AppColors.mossMuted.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Label
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.voidBlack.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.aquaCyan.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'NET VOL: ${netVolume.toStringAsFixed(1)}L (Gross ${grossVolume.toStringAsFixed(1)}L)',
                style: const TextStyle(
                  color: AppColors.aquaCyan,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.aquaCyan.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const step = 20.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
