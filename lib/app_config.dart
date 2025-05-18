class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  /// The flavor of the app. This is set by the build system.
  static final String flavor =
      const String.fromEnvironment("FLAVOR", defaultValue: "development");

  /// The commit hash on which the app was built. This is set by the build system.
  static final String gitCommit =
      const String.fromEnvironment("GIT_COMMIT", defaultValue: "uncommitted")
          .substring(0, 7);
}
