import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseJsonInt', () {
    test('returns null for null', () {
      expect(parseJsonInt(null), isNull);
    });

    test('returns int unchanged', () {
      expect(parseJsonInt(42), 42);
    });

    test('truncates num to int', () {
      expect(parseJsonInt(3.9), 3);
    });

    test('parses numeric string', () {
      expect(parseJsonInt('17'), 17);
    });

    test('returns null for non-numeric string', () {
      expect(parseJsonInt('abc'), isNull);
    });

    test('returns null for unsupported types', () {
      expect(parseJsonInt(true), isNull);
    });
  });

  group('requiredJsonInt', () {
    test('returns parsed int', () {
      expect(requiredJsonInt('8'), 8);
    });

    test('throws FormatException when value is not int-compatible', () {
      expect(
        () => requiredJsonInt('nope'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Expected int-compatible JSON value, got nope (String)',
          ),
        ),
      );
    });
  });

  group('optionalJsonInt', () {
    test('returns 0 when parsing fails', () {
      expect(optionalJsonInt(null), 0);
      expect(optionalJsonInt('x'), 0);
    });

    test('returns parsed int when value is valid', () {
      expect(optionalJsonInt(5), 5);
    });
  });

  group('requiredJsonDateTime', () {
    test('parses ISO-8601 string as local DateTime', () {
      const raw = '2025-05-15T12:00:00.000Z';
      expect(requiredJsonDateTime(raw), DateTime.parse(raw).toLocal());
    });

    test('uses Object.toString for non-string values', () {
      final value = DateTime.utc(2024, 1, 2, 3, 4, 5);
      expect(requiredJsonDateTime(value), value.toLocal());
    });

    test('throws a field-specific FormatException for absent or malformed values', () {
      for (final value in [null, '', '   ', 'not-a-date']) {
        expect(
          () => requiredJsonDateTime(value, fieldName: 'order.created_at'),
          throwsA(
            isA<FormatException>().having(
              (error) => error.message,
              'message',
              contains('order.created_at'),
            ),
          ),
          reason: 'value: $value',
        );
      }
    });
  });
}
