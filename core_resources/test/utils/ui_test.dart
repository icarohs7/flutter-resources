import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('createMaterialColor', () {
    const c1 = Color(0xFF174378);
    final m1 = createMaterialColor(c1);

    expect(m1, isNotNull);
    expect(m1.value, c1.value);
    expect(m1[50]!.value, equals(Color(0xFF7F98B5).value));
    expect(m1[100]!.value, equals(Color(0xFF748EAE).value));
    expect(m1[200]!.value, equals(Color(0xFF5D7BA1).value));
    expect(m1[300]!.value, equals(Color(0xFF456993).value));
    expect(m1[400]!.value, equals(Color(0xFF2E5685).value));
    expect(m1[500]!.value, equals(Color(0xFF174378).value));
    expect(m1[600]!.value, equals(Color(0xFF153C6C).value));
    expect(m1[700]!.value, equals(Color(0xFF123660).value));
    expect(m1[800]!.value, equals(Color(0xFF102F54).value));
    expect(m1[900]!.value, equals(Color(0xFF0E2848).value));
  });
}
