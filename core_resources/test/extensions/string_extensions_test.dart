import 'package:core_resources/src/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should use alternate value if string is blank', () {
    final s1 = ' '.ifBlank(() => 'string one');
    final s2 = ''.ifBlank(() => 'string two');
    final s3 = 'Omai wa mou shindeiru!'.ifBlank(() => 'string three');

    expect(s1, equals('string one'));
    expect(s2, equals('string two'));
    expect(s3, equals('Omai wa mou shindeiru!'));
  });

  test('should use alternate value if string is empty', () {
    final s1 = ' '.ifEmpty(() => 'string one');
    final s2 = ''.ifEmpty(() => 'string two');
    final s3 = 'Omai wa mou shindeiru!'.ifEmpty(() => 'string three');

    expect(s1, equals(' '));
    expect(s2, equals('string two'));
    expect(s3, equals('Omai wa mou shindeiru!'));
  });
}
