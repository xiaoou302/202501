import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'data/repositories/art_repository.dart';
import 'data/repositories/chat_repository.dart';
import 'data/repositories/journal_repository.dart';
import 'presentation/viewmodels/gallery_viewmodel.dart';
import 'presentation/viewmodels/chat_viewmodel.dart';
import 'presentation/viewmodels/journal_viewmodel.dart';
import 'presentation/screens/splash_screen.dart';

class MidnightGalleryApp extends StatelessWidget {
  const MidnightGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GalleryViewModel(ArtRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatViewModel(ChatRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => JournalViewModel(JournalRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'MeeMi',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
