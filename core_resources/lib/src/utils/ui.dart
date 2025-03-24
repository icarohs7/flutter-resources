import 'package:flutter/material.dart';

///Create a material swatch with variations of
///a base color, credits to
///[Filip Veličković](https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3)
MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
  final swatch = <int, Color>{};
  final value = color.toARGB32();
  final r = (0x00ff0000 & value) >> 16;
  final g = (0x0000ff00 & value) >> 8;
  final b = (0x000000ff & value) >> 0;

  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromARGB(
      255,
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
    );
  }

  return MaterialColor(color.toARGB32(), swatch);
}
