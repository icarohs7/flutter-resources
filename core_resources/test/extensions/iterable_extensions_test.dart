import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SigeIterableExtensions', () {
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
  });
}
