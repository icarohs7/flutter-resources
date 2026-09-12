import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('nullIfEmptyOrBlank', () {
    test('returns null for null', () {
      expect(nullIfEmptyOrBlank(null), isNull);
    });

    test('returns null for empty string', () {
      expect(nullIfEmptyOrBlank(''), isNull);
    });

    test('returns null for whitespace-only string', () {
      expect(nullIfEmptyOrBlank('   '), isNull);
    });

    test('returns value for non-blank string', () {
      expect(nullIfEmptyOrBlank('abc'), 'abc');
    });

    test('returns value when string has non-whitespace', () {
      expect(nullIfEmptyOrBlank(' a '), ' a ');
    });
  });

  group('nullIfEmpty', () {
    test('returns null for null', () {
      expect(nullIfEmpty<int>(null), isNull);
    });

    test('returns null for empty list', () {
      expect(nullIfEmpty<int>([]), isNull);
    });

    test('returns value for non-empty list', () {
      expect(nullIfEmpty([1, 2]), [1, 2]);
    });

    test('returns same list instance when non-empty', () {
      final list = [1];
      expect(nullIfEmpty(list), same(list));
    });
  });
}
