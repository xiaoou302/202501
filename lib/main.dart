import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final container = ProviderContainer();
  await container.read(storageServiceProvider).init();

  runApp(
    UncontrolledProviderScope(container: container, child: const GlimApp()),
  );
}
