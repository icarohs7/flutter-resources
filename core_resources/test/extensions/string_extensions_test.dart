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

  test('should truncate string', () {
    const s1 = 'omai wa mou shindeiru';
    final s1t = s1.truncateTo(5);
    expect(s1t, equals('omai '));
    expect(s1t.length, equals(5));

    const s2 = 'nani!?';
    final s2t = s2.truncateTo(3, elipsis: true);
    expect(s2t, equals('nan...'));
    expect(s2t.length, equals(3 + 3));
  });

  test('should return substring after pattern', () {
    const s1 = 'kono Giorno Giovanna ni wa yume ga aru';
    final s1s = s1.afterLast('ni');
    final s1s2 = s1.afterLast('ni', patternIncluded: true);
    expect(s1s, equals(' wa yume ga aru'));
    expect(s1s2, equals('ni wa yume ga aru'));

    const s2 = 'nigerundayo Smokey';
    final s2s = s2.afterLast('Smokey');
    final s2s2 = s2.afterLast('Smokey', patternIncluded: true);
    expect(s2s, equals(''));
    expect(s2s2, equals('Smokey'));
  });
}
