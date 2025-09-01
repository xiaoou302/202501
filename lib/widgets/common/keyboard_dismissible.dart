import 'package:flutter/material.dart';

/// A widget that dismisses the keyboard when tapped outside of input fields
class KeyboardDismissible extends StatelessWidget {
  /// The child widget
  final Widget child;

  const KeyboardDismissible({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
