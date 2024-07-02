// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'dart:developer';

/// Print to the standart output only if the app is
/// not in debug mode
void clog(Object? object) {
  if (!kDebugMode) return;
  log('$object');
}
