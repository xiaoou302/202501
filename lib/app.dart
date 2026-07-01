import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'screens/common/care_screen.dart';

class PetShapeApp extends StatelessWidget {
  const PetShapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const CareScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        );
      },
    );
  }
}
