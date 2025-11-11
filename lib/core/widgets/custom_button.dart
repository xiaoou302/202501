import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.softCoral,
          side: const BorderSide(color: AppConstants.softCoral, width: 2),
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 16 : 32,
            vertical: isSmall ? 8 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          ),
        ),
        child: _buildContent(),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.softCoral,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 16 : 32,
          vertical: isSmall ? 8 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmall ? 16 : 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}
