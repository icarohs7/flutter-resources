import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert object to material state property', () {
    const color = Colors.red;
    final materialStateProperty = color.materialProperty;
    expect(materialStateProperty.resolve({}), color);
  });

  test('should convert object to subject', () {
    const color = Colors.red;
    final subject = color.subject;
    expect(subject.value, color);
    expect(subject, emits(color));
    subject.value = Colors.blue;
    expect(subject.value, Colors.blue);
    expect(subject, emits(Colors.blue));
  });
}
