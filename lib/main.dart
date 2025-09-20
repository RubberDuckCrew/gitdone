import "package:flutter/material.dart";
import "package:gitdone/app.dart";
import "package:gitdone/app_config.dart";
import "package:gitdone/core/settings_handler.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  await SettingsHandler().init();
  runApp(const App());
}
