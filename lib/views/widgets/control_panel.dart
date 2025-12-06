import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../../core/constants.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 8,
            top: 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.sandalwood,
                AppColors.sandalwood.withOpacity(0.95),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  icon: Icons.shuffle,
                  label: AppStrings.shuffle,
                  count: viewModel.shuffleCount,
                  onTap: viewModel.manualShuffle,
                  isDisabled: viewModel.shuffleCount <= 0,
                  color: AppColors.jadeBlue,
                ),
                _buildButton(
                  icon: Icons.swap_horiz,
                  label: 'Swap',
                  count: viewModel.swapHandCount,
                  onTap: viewModel.swapHandTile,
                  isDisabled: viewModel.swapHandCount <= 0,
                  color: AppColors.jadeGreen,
                ),
                _buildButton(
                  icon: viewModel.isPaused ? Icons.play_arrow : Icons.pause,
                  label: viewModel.isPaused ? 'Resume' : 'Pause',
                  onTap: viewModel.togglePause,
                  isDisabled: false,
                  color: AppColors.vermillion,
                  isPauseButton: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    int? count,
    VoidCallback? onTap,
    bool isDisabled = false,
    required Color color,
    bool isPauseButton = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: isDisabled
                      ? LinearGradient(
                          colors: [
                            Colors.grey.shade600,
                            Colors.grey.shade700,
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                        ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDisabled
                        ? Colors.grey.shade500
                        : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    if (!isDisabled)
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: isDisabled
                      ? Colors.grey.shade400
                      : AppColors.ivory,
                  size: 22,
                ),
              ),
              // Count badge
              if (count != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: count > 0
                            ? [AppColors.vermillion, const Color(0xFFD32F2F)]
                            : [Colors.grey.shade600, Colors.grey.shade700],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.ivory, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 22,
                      minHeight: 22,
                    ),
                    child: Center(
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: AppColors.ivory,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDisabled
                  ? Colors.grey.shade700.withOpacity(0.3)
                  : color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isDisabled
                    ? Colors.grey.shade500
                    : AppColors.ivory.withOpacity(0.9),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
