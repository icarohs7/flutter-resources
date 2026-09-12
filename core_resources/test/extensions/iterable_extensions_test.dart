import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CRIterableExtensions', () {
    test('put() should replace element at given index', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.put(2, 10);
      expect(result.toList(), [1, 2, 10, 4, 5]);
    });

    test('put() should not modify original iterable', () {
      final list = [1, 2, 3, 4, 5];
      list.put(2, 10);
      expect(list, [1, 2, 3, 4, 5]);
    });

    test('put() should do nothing when index is out of bounds', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.put(10, 42);
      expect(result.toList(), [1, 2, 3, 4, 5]);
    });

    test('put() should add element when index is 0 and iterable is empty', () {
      final list = <int>[];
      final result = list.put(0, 42);
      expect(result.toList(), [42]);
    });

    test('hasCountElements returns true for empty iterable with count 0', () {
      expect([].hasCountElements(0), isTrue);
    });

    test('hasCountElements returns false for empty iterable with count > 0', () {
      expect([].hasCountElements(1), isFalse);
    });

    test('hasCountElements returns true when iterable has exactly the given count', () {
      expect([1, 2, 3].hasCountElements(3), isTrue);
    });

    test('hasCountElements returns false when iterable has fewer elements than count', () {
      expect([1, 2].hasCountElements(3), isFalse);
    });

    test('hasCountElements returns false when iterable has more elements than count', () {
      expect([1, 2, 3, 4].hasCountElements(3), isFalse);
    });

    test('hasCountElements returns true for single-element iterable with count 1', () {
      expect([42].hasCountElements(1), isTrue);
    });

    test('hasCountElements works with lazy iterables', () {
      final lazy = Iterable.generate(5, (i) => i);
      expect(lazy.hasCountElements(5), isTrue);
      expect(lazy.hasCountElements(4), isFalse);
      expect(lazy.hasCountElements(6), isFalse);
    });

    test('hasCountElements short-circuits on iterables larger than count', () {
      var iterationCount = 0;

      Iterable<int> counting() sync* {
        for (var i = 0; i < 100; i++) {
          iterationCount++;
          yield i;
        }
      }

      counting().hasCountElements(3);

      expect(iterationCount, 4);
    });
  });
}
