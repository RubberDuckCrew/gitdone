import "dart:async";
import "dart:developer" as dev;

import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/logger/logger_module.dart";

/// A default logger implementation that uses the Dart developer package for logging.
class DefaultLogger implements LoggerModule {
  @override
  void log(
    String message,
    String name,
    LogLevel logLevel, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
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
    String message,
    String name,
    Object? error, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    StackTrace? stackTrace,
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
    String message,
    String name, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
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
    String message,
    String name, {
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
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
