import 'package:flutter/services.dart';

Future<void> showSystemOverlays() async {
  await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
}

Future<void> hideSystemOverlays() async => await SystemChrome.setEnabledSystemUIOverlays([]);
