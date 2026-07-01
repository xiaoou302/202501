import 'package:flutter/material.dart';
import 'app.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().init();
  runApp(const PetShapeApp()); //hfhgfhgdgdgfdssdasd
}
