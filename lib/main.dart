import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'data/repositories/relic_repository.dart';

void main() {
  runApp(const RueApp());
}

class RueApp extends StatelessWidget {
  const RueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => RelicRepository()),
      ],
      child: MaterialApp(
        title: 'Rue',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
