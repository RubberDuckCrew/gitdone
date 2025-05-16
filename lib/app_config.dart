class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  static final String flavor = const String.fromEnvironment(
    "FLAVOR",
    defaultValue: "development",
  );
}
