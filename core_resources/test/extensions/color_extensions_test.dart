import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert hex code string to color', () {
    final c1 = ColorExtensions.fromHex('dadada');
    final c2 = ColorExtensions.fromHex('#DADADA');
    expect(c1, equals(c2));
    expect(c1.value, equals(c2.value));
    expect(c1, equals(Color(0xffdadada)));
    expect(c1.value, equals(0xffdadada));
  });

  test('should calculate brightness of color', () {
    expect(Color(0xFF000000).brightness, Brightness.dark);
    expect(Color(0xFFFFFFFF).brightness, Brightness.light);
    expect(Color(0xFFFF0000).brightness, Brightness.dark);
    expect(Color(0xFF00FF00).brightness, Brightness.light);
    expect(Color(0xFF0000FF).brightness, Brightness.dark);
    expect(Color(0xFFFF00FF).brightness, Brightness.dark);
    expect(Color(0xFF00FFFF).brightness, Brightness.light);
    expect(Color(0xFFFFFF00).brightness, Brightness.light);
  });
}
