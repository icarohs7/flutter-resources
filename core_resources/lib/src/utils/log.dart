// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

/// Print to the standart output only if the app is
/// not in debug mode
void clog(Object? object, {Object? error, StackTrace? stackTrace, Zone? zone}) {
  if (!kDebugMode) return;
  log('$object', error: error, stackTrace: stackTrace, zone: zone);
}
