import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_resources/stream_resources.dart';

void main() {
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