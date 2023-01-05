import 'package:core_resources/src/extensions/value_listenable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:functional_listener/functional_listener.dart';

void main() {
  test('mapEvent', () {
    var count = 0;
    final v = ValueNotifier(1);
    final mapped = v.mapEvent((i) => i.toString());
    mapped.listen((_, __) => count++);
    expect(mapped.value, '1');
    v.value = 3;
    v.value = 2;
    expect(mapped.value, '2');
    expect(count, 2);
  });

  test('whereEvent', () {
    var count = 0;
    final v = ValueNotifier(1);
    final filtered = v.whereEvent((i) => i % 2 == 0);
    filtered.listen((_, __) => count++);
    expect(filtered.value, 1);
    v.value = 2;
    expect(filtered.value, 2);
    v.value = 3;
    expect(filtered.value, 2);
    v.value = 4;
    expect(filtered.value, 4);
    expect(count, 2);
  });
}
