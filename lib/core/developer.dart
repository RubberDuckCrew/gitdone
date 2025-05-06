import 'dart:async';
import 'dart:developer' as dev;

/// Enum representing different logging levels specified in the gitdone Wiki.
///
/// See: https://github.com/RubberDuckCrew/gitdone/wiki/Logging-in-Flutter-using-developer-Package#suggested-log-levels
enum LogLevel {
  /// **Finest**
  ///
  /// The most detailed logging level.
  /// Use this for extremely granular debugging information, such as tracing every iteration of a loop
  /// or very low-level operations that are rarely needed in production.
  finest(300),

  /// **Finer**
  ///
  /// Very detailed debugging information.
  /// Suitable for internal method calls, detailed state changes, or non-critical performance measurements.
  finer(400),

  /// **Fine**
  ///
  /// General debugging information.
  /// Use this to log successful function executions, non-critical events, or moderate detail useful during development.
  fine(500),

  /// **Config**
  ///
  /// Configuration and initialization information.
  /// Ideal for logging system settings, environment setup, or initial application state at startup.
  config(700),

  /// **Info**
  ///
  /// Standard operational messages indicating normal application behavior.
  /// Use this for high-level events such as a user logging in, a file being successfully saved, or a background task completing.
  info(800),

  /// **Warning**
  ///
  /// Indicates a potential problem or something unexpected that did not cause the application to fail.
  /// For example, an operation took longer than expected, or a resource is nearing a limit.
  warning(900),

  /// **Severe**
  ///
  /// A serious failure that indicates a problem requiring attention, but which may not stop the application from running.
  /// Examples include failed external service calls or unexpected exceptions during critical operations.
  severe(1000),

  /// **Shout**
  ///
  /// The highest logging level, used for critical errors or emergencies.
  /// Use this for unrecoverable failures such as data loss or system shutdowns.
  shout(1200);

  final int _value;
  const LogLevel(this._value);

  int get logLevel => _value;
}

class Developer {
  /// Logs a message with the specified level, time, sequence number, name,
  /// zone, error, and stack trace.
  /// @param message The message to log.
  /// @param name The name of the file logging the message. Example: "com.GitDone.gitdone.core.models.github_oauth_model"
  static void log(String message, String name, LogLevel level,
      {DateTime? time,
      int? sequenceNumber,
      Zone? zone,
      Object? error,
      StackTrace? stackTrace}) {
    int logLevel = level.logLevel;
    dev.log(message,
        time: time,
        sequenceNumber: sequenceNumber,
        name: name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
        level: logLevel);
  }

  /// Logs a error with time, sequence number, name,
  /// zone, error, and stack trace.
  static void logError(String message, String name,
      {DateTime? time,
      int? sequenceNumber,
      Zone? zone,
      Object? error,
      StackTrace? stackTrace}) {
    log(
        message,
        time: time,
        sequenceNumber: sequenceNumber,
        name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
        LogLevel.severe);
  }

  /// Logs a warning with time, sequence number, name,
  /// zone, error, and stack trace.
  static void logWarning(String message, String name,
      {DateTime? time,
      int? sequenceNumber,
      Zone? zone,
      Object? error,
      StackTrace? stackTrace}) {
    log(
        message,
        time: time,
        sequenceNumber: sequenceNumber,
        name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
        LogLevel.warning);
  }

  /// Logs a info message with time, sequence number, name,
  /// zone, error, and stack trace.
  static void logInfo(String message, String name,
      {DateTime? time,
      int? sequenceNumber,
      Zone? zone,
      Object? error,
      StackTrace? stackTrace}) {
    log(
        message,
        time: time,
        sequenceNumber: sequenceNumber,
        name,
        zone: zone,
        error: error,
        stackTrace: stackTrace,
        LogLevel.info);
  }
}
