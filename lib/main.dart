import "package:gitdone/app.dart";
import "package:gitdone/app_environment.dart";
import "package:gitdone/core/settings_handler.dart";
import "package:material_ui/material_ui.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnvironment.init();
  await SettingsHandler().init();
  runApp(const App());
}
