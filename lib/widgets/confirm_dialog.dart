import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    this.cancelText = '取消',
    this.confirmText = '确认',
    this.confirmColor = Colors.red,
    required this.onConfirm,
  }) : super(key: key);

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = '取消',
    String confirmText = '确认',
    Color confirmColor = Colors.red,
    required VoidCallback onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF1A2238),
      title: Text(title, style: TextStyle(color: Color(0xFFE0E0E0))),
      content: Text(
        content,
        style: TextStyle(color: Color(0xFFE0E0E0).withOpacity(0.8)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText, style: TextStyle(color: Color(0xFF4FC1B9))),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop(true);
          },
          child: Text(confirmText, style: TextStyle(color: confirmColor)),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
