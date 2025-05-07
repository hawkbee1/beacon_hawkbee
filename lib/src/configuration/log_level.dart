part of 'package:beacon_hawkbee/src/beacon_hawkbee_base.dart';

/// Log levels for the Beacon SDK.
enum LogLevel {
  /// No logging.
  none,

  /// Log fatal errors only.
  fatal,

  /// Log errors only.
  error,

  /// Log warnings and errors.
  warn,

  /// Log info messages, warnings, and errors.
  info,

  /// Log debug messages, info messages, warnings, and errors.
  debug,

  /// Log all messages.
  verbose;

  /// Whether this log level includes the given log level.
  bool includes(LogLevel other) {
    return index >= other.index;
  }
}
