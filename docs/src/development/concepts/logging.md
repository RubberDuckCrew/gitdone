# Logging

Logging is an essential part of application development.

In this project, we do not use `dart:developer` directly, but instead our own wrapper: `package:gitdone/core/utils/logger.dart`. This wrapper encapsulates the functionality of `dart:developer` and provides a unified interface for logging messages with different levels.

This approach offers several advantages:

-   Logs can be structured, filtered, and analyzed more easily
-   Integration with IDE debugging tools is preserved
-   logging throughout the project is consistent and more streamlined than with external logging packages
-   You also benefit from better overview and filtering by different log levels, and native support in Dart for structured logging.

## Logging a Message

First, you need to import the `logger` utility from your project:

```dart
import "package:gitdone/core/utils/logger.dart";
```

Then, you need to define a `classId` that represents the context of your log messages. This is typically a string that identifies the class or module where the log is being generated.

```dart
static const String _classId = "com.GitDone.gitdone.*calling_file*";
```

Finally, you can log messages using the `Logger.log` method:

```dart
Logger.log(
  "This is a log message",
  classId,
  LogLevel.finest,
);
```

## Logging with Different Levels

You can log messages at different levels of severity using the `Logger.log` method. This allows you to categorize your log messages and filter them based on their importance.

### Defined Log Levels

| Level               | Value | Usage Example                                                                                                                                                                                                                |
| ------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `LogLevel.finest`   | 300   | The most detailed logging level.<br> Use this for extremely granular debugging information, such as tracing every iteration of a loop or very low-level operations that are rarely needed in production.                     |
| `LogLevel.detailed` | 400   | Very detailed debugging information.<br> Suitable for internal method calls, detailed state changes, or non-critical performance measurements.                                                                               |
| `LogLevel.general`  | 500   | General debugging information.<br> Use this to log successful function executions, non-critical events, or moderate detail useful during development.                                                                        |
| `LogLevel.config`   | 700   | Configuration and initialization information.<br> Ideal for logging system settings, environment setup, or initial application state at startup.                                                                             |
| `LogLevel.info`     | 800   | Standard operational messages indicating normal application behavior.<br> Use this for high-level events such as a user logging in, a file being successfully saved, or a background task completing.                        |
| `LogLevel.warning`  | 900   | Indicates a potential problem or something unexpected that did not cause the application to fail.<br> For example, an operation took longer than expected, or a resource is nearing a limit.                                 |
| `LogLevel.severe`   | 1000  | A serious failure that indicates a problem requiring attention, but which may not stop the application from running.<br> Examples include failed external service calls or unexpected exceptions during critical operations. |
| `LogLevel.shout`    | 1200  | The highest logging level, used for critical errors or emergencies.<br> Use this for unrecoverable failures such as data loss or system shutdowns.                                                                           |

To log errors, warnings or information, you can also use the `Logger.logError`, `Logger.logWarning`, or `Logger.logInfo` methods:

```dart
Logger.logError(
  "An error occurred",
  classId,
  error,
  stackTrace: stackTrace,
);

Logger.logWarning(
  "This is a warning message",
  classId,
);

Logger.logInfo(
  "This is an informational message",
  classId,
);
```
