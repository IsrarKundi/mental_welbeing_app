import 'package:flutter/foundation.dart';

/// Centralized logging service for the Mental Wellbeing app.
///
/// Provides structured logging with log levels that can be filtered
/// based on build mode (debug vs release).
enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  /// Minimum log level. In debug mode, shows all. In release, only warnings+.
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  /// Set the minimum log level for filtering
  static void setMinLevel(LogLevel level) => _minLevel = level;

  /// Log a debug message (development only)
  static void debug(String message, [Object? error]) {
    _log(LogLevel.debug, message, error);
  }

  /// Log an informational message
  static void info(String message, [Object? error]) {
    _log(LogLevel.info, message, error);
  }

  /// Log a warning message
  static void warning(String message, [Object? error]) {
    _log(LogLevel.warning, message, error);
  }

  /// Log an error message with optional error object and stack trace
  static void error(String message, [Object? error, StackTrace? stack]) {
    _log(LogLevel.error, message, error, stack);
  }

  static void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stack,
  ]) {
    if (level.index < _minLevel.index) return;

    final prefix = '[${level.name.toUpperCase()}]';
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);

    debugPrint('$timestamp $prefix $message');

    if (error != null) {
      debugPrint('  └─ Error: $error');
    }

    if (stack != null && level == LogLevel.error) {
      debugPrint('  └─ Stack:\n$stack');
    }
  }
}
