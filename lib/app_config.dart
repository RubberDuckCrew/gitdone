import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  /// The flavor of the app. This is set by the build system.
  static final String flavor = appFlavor ?? "unknown flavor";

  /// The commit hash on which the app was built. This is set by the build system.
  static final String gitCommit = const bool.hasEnvironment("GIT_COMMIT")
      ? const String.fromEnvironment("GIT_COMMIT").substring(0, 7)
      : "uncommitted";

  /// App version defined in pubspec.yaml
  static late final String version;

  /// Build number defined in pubspec.yaml
  static late final String buildNumber;

  /// App name defined in build.gradle
  static late final String appName;

  /// Package name defined in build.gradle
  static late final String packageName;

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
    appName = info.appName;
    packageName = info.packageName;
  }
}
