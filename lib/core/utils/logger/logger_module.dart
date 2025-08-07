import "dart:async";

import "package:gitdone/core/utils/logger.dart";

/// An abstract interface for a logger module.
abstract interface class LoggerModule {
  /// Logs a message with the specified level.
  void log(
    final String message,
    final String name,
    final LogLevel logLevel, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final Object? error,
    final StackTrace? stackTrace,
  });

  /// Logs an error message.
  void logError(
    final String message,
    final String name,
    final Object? error, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final StackTrace? stackTrace,
  });

  /// Logs a warning message.
  void logWarning(
    final String message,
    final String name, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final Object? error,
    final StackTrace? stackTrace,
  });

  /// Logs an info message.
  void logInfo(
    final String message,
    final String name, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final Object? error,
    final StackTrace? stackTrace,
  });
}
