import 'package:flutter/material.dart';
import '../../core/constants.dart';

class SageMessage extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const SageMessage({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 48,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.antiqueGold.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🧙‍♂️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.ivory,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                color: Colors.white.withOpacity(0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
