import 'package:flutter/foundation.dart';

/// Print to the standart output only if the app is
/// not in debug mode
void clog(Object? object) {
  if (!kDebugMode) return;
  print(object);
}