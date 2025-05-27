// This is necessary to ensure that the app can be built with different
// configurations based on the environment, such as development, staging,
// or production.
// ignore_for_file: do_not_use_environment

import "package:flutter/services.dart";
import "package:package_info_plus/package_info_plus.dart";

/// Configuration class for the GitDone application.
class AppConfig {
  /// Singleton-Instance of the AppConfig class.
  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();

  /// The flavor of the app. This is set by the build system.
  static const String flavor = appFlavor ?? "unknown flavor";

  /// The commit hash on which the app was built. This is set by the
  /// build system.
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

  /// Initializes the app configuration by fetching package information.
  static Future<void> init() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
    appName = info.appName;
    packageName = info.packageName;
  }
}
