import "dart:async";

import "package:gitdone/core/utils/logger.dart";

/// An abstract interface for a logger module.
abstract interface class LoggerModule {
  /// Logs a message with the specified level.
  void log(
    String message,
    String name,
    LogLevel logLevel, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs an error message.
  void logError(
    String message,
    String name,
    Object? error, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    StackTrace? stackTrace,
  });

  /// Logs a warning message.
  void logWarning(
    String message,
    String name, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs an info message.
  void logInfo(
    String message,
    String name, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  });
}
