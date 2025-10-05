import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// A debug-mode logging utility that simplifies logging messages, errors and stack traces.
///
/// This function only logs in debug mode (when [kDebugMode] is true) and provides
/// convenient logging of both informational messages and error conditions.
///
/// Parameters:
/// - [object]: The message or object to log
/// - [error]: Optional error object to include in the log
/// - [stackTrace]: Optional stack trace to include in the log
/// - [zone]: Optional zone context (currently unused)
/// - [logger]: Optional logger instance. If not provided, uses [Logger.root]
///
/// The function behaves differently based on the provided parameters:
/// - If only [object] is provided, logs an INFO level message
/// - If [error] or [stackTrace] is provided, logs a SEVERE level message
void clog(Object? object, {Object? error, StackTrace? stackTrace, Zone? zone, Logger? logger}) {
  if (!kDebugMode) return;
  final log = logger ?? Logger.root;

  if (error != null || stackTrace != null) {
    log.severe(object, error, stackTrace);
    return;
  }

  log.info(object);
}
