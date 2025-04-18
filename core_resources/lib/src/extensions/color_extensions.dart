import 'package:flutter/material.dart';

extension CRColorExtensions on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String? hexString) {
    if (hexString == null) return Colors.black;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// String is in the format "ffaabbcc" with an optional leading "#", according to the parameter
  /// [leadingHashSign].
  String toHex({bool leadingHashSign = true}) {
    final value = toARGB32();
    final alpha = (0xff000000 & value) >> 24,
        red = (value & 0x00ff0000) >> 16,
        green = (value & 0x0000ff00) >> 8,
        blue = value & 0x000000ff;

    return '${leadingHashSign ? '#' : ''}'
        '${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }

  /// Calculate brightness of the color,
  /// returning either [Brightness.dark]
  /// or [Brightness.light]
  Brightness get brightness => ThemeData.estimateBrightnessForColor(this);
}
