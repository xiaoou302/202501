import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputUtils {
  // Character length limits
  static const int titleMaxLength = 30; // Title max length
  static const int descriptionMaxLength = 500; // Description max length
  static const int nameMaxLength = 20; // Name max length

  // Input formatters
  static final TextInputFormatter titleFormatter =
      LengthLimitingTextInputFormatter(titleMaxLength);
  static final TextInputFormatter descriptionFormatter =
      LengthLimitingTextInputFormatter(descriptionMaxLength);
  static final TextInputFormatter nameFormatter =
      LengthLimitingTextInputFormatter(nameMaxLength);

  // Validators
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    if (value.length > titleMaxLength) {
      return 'Title cannot exceed $titleMaxLength characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    if (value.length > descriptionMaxLength) {
      return 'Description cannot exceed $descriptionMaxLength characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (value.length > nameMaxLength) {
      return 'Name cannot exceed $nameMaxLength characters';
    }
    return null;
  }

  // Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

// Scaffold that automatically hides keyboard when tapping outside input fields
class DismissKeyboardScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  const DismissKeyboardScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => InputUtils.hideKeyboard(context),
      child: Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
