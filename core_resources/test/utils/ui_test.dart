import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('createMaterialColor', () {
    const c1 = Color(0xFF174378);
    final m1 = createMaterialColor(c1);

    expect(m1, isNotNull);
    expect(m1.toARGB32(), c1.toARGB32());
    expect(m1[50]!.toARGB32(), equals(Color(0xFF7F98B5).toARGB32()));
    expect(m1[100]!.toARGB32(), equals(Color(0xFF748EAE).toARGB32()));
    expect(m1[200]!.toARGB32(), equals(Color(0xFF5D7BA1).toARGB32()));
    expect(m1[300]!.toARGB32(), equals(Color(0xFF456993).toARGB32()));
    expect(m1[400]!.toARGB32(), equals(Color(0xFF2E5685).toARGB32()));
    expect(m1[500]!.toARGB32(), equals(Color(0xFF174378).toARGB32()));
    expect(m1[600]!.toARGB32(), equals(Color(0xFF153C6C).toARGB32()));
    expect(m1[700]!.toARGB32(), equals(Color(0xFF123660).toARGB32()));
    expect(m1[800]!.toARGB32(), equals(Color(0xFF102F54).toARGB32()));
    expect(m1[900]!.toARGB32(), equals(Color(0xFF0E2848).toARGB32()));
  });
}
