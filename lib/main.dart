import 'package:flutter/material.dart';
import 'package:gitdone/app.dart';
import 'package:gitdone/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  runApp(const App());
}
