import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert hex code string to color', () {
    expect(CRColorExtensions.fromHex('#102030').toHex(), Color(0xFF102030).toHex());
    expect(CRColorExtensions.fromHex('#FF102030').toHex(), Color(0xFF102030).toHex());
    expect(CRColorExtensions.fromHex('#ff102030').toHex(), Color(0xFF102030).toHex());
    expect(CRColorExtensions.fromHex('#ffabcdef').toHex(), Color(0xFFAbCdEf).toHex());
  });

  test('should convert color to hexadecimal representation', () {
    expect(Color(0xFF102030).toHex(), '#ff102030');
    expect(Color(0xFF102030).toHex(leadingHashSign: false), 'ff102030');
    expect(Color(0xAA553197).toHex(leadingHashSign: false), 'aa553197');
    expect(Color(0x59FFFFFF).toHex(leadingHashSign: false), '59ffffff');
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
