import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class IOSStatusBar extends StatelessWidget {
  const IOSStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: AppConstants.offWhite,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: const [
              Icon(Icons.signal_cellular_4_bar, color: AppConstants.offWhite, size: 16),
              SizedBox(width: 8),
              Icon(Icons.wifi, color: AppConstants.offWhite, size: 16),
              SizedBox(width: 8),
              Icon(Icons.battery_full, color: AppConstants.offWhite, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
