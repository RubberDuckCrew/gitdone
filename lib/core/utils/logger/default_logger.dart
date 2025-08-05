import "dart:async";
import "dart:developer" as dev;

import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/logger/logger_module.dart";

/// A default logger implementation that uses the Dart developer package for logging.
class DefaultLogger implements LoggerModule {
  @override
  void log(
    final String message,
    final String name,
    final LogLevel logLevel, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    dev.log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
      level: logLevel.logLevel,
    );
  }

  @override
  void logError(
    final String message,
    final String name,
    final Object? error, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final StackTrace? stackTrace,
  }) {
    log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
      LogLevel.severe,
    );
  }

  @override
  void logInfo(
    final String message,
    final String name, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
      LogLevel.info,
    );
  }

  @override
  void logWarning(
    final String message,
    final String name, {
    final DateTime? time,
    final int? sequenceNumber,
    final Zone? zone,
    final Object? error,
    final StackTrace? stackTrace,
  }) {
    log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
      LogLevel.warning,
    );
  }
}
