import 'package:flutter/services.dart';

Future<void> showSystemOverlays() async {
  await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
}

Future<void> hideTopSystemOverlay() async {
  await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
}

Future<void> hideSystemOverlays() async => await SystemChrome.setEnabledSystemUIOverlays([]);
