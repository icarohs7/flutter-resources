import 'dart:math';

import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create a new RxList', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    expect(list.value, [1, 2, 3]);
    expect(list.stream, emits([1, 2, 3]));
  });

  test('should combine two RxLists', () {
    final list1 = RxList<int>([1, 2, 3]);
    final list2 = RxList<int>([4, 5, 6]);
    final combined = list1 + list2;
    expect(combined, isA<RxList<int>>());
    expect(combined.value, [1, 2, 3, 4, 5, 6]);
    expect(combined.stream, emits([1, 2, 3, 4, 5, 6]));
  });

  test('should access an item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list[0], 1);
    expect(list[1], 2);
    expect(list[2], 3);
  });

  test('should set an item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    list[0] = 4;
    expect(list.value, [4, 2, 3]);
    expect(list.stream, emits([4, 2, 3]));
  });

  test('should add a new item to the list', () {
    final list = RxList<int>();
    expect(list, isA<RxList<int>>());
    expect(list.value, []);
    expect(list.stream, emits([]));
    list.add(1);
    expect(list.value, [1]);
    expect(list.stream, emits([1]));
  });

  test('should add all items to the list', () {
    final list = RxList<int>();
    expect(list, isA<RxList<int>>());
    expect(list.value, []);
    expect(list.stream, emits([]));
    list.addAll([1, 2, 3]);
    expect(list.value, [1, 2, 3]);
    expect(list.stream, emits([1, 2, 3]));
  });

  test('should return a map of the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.asMap(), {0: 1, 1: 2, 2: 3});
  });

  test('should clear the list', () {
    final list = RxList<int>([1, 2, 3]);
    list.clear();
    expect(list.value, []);
    expect(list.stream, emits([]));
  });

  test('should remove an item from the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.remove(2);
    expect(list.value, [1, 3]);
    expect(list.stream, emits([1, 3]));
  });

  test('should remove all items from the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.clear();
    expect(list.value, []);
    expect(list.stream, emits([]));
  });

  test('should fill a range of the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.fillRange(0, 2, 4);
    expect(list.value, [4, 4, 3]);
    expect(list.stream, emits([4, 4, 3]));
  });

  test('should set the first item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.first = 4;
    expect(list.value, [4, 2, 3]);
    expect(list.stream, emits([4, 2, 3]));
  });

  test('should return the list followed by another list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.followedBy([4, 5, 6]), [1, 2, 3, 4, 5, 6]);
  });

  test('should get range of items from the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.getRange(0, 2), [1, 2]);
  });

  test('should get index of item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.indexOf(2), 1);
  });

  test('should get the index of an item in the list with a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.indexWhere((item) => item == 2), 1);
  });

  test('should insert an item into the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.insert(1, 4);
    expect(list.value, [1, 4, 2, 3]);
    expect(list.stream, emits([1, 4, 2, 3]));
  });

  test('should insert all items into the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.insertAll(1, [4, 5, 6]);
    expect(list.value, [1, 4, 5, 6, 2, 3]);
    expect(list.stream, emits([1, 4, 5, 6, 2, 3]));
  });

  test('should return if list is empty', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.isEmpty, false);
    list.clear();
    expect(list.isEmpty, true);
  });

  test('should get the last index of an item in the list', () {
    final list = RxList<int>([1, 2, 3, 2]);
    expect(list.lastIndexOf(2), 3);
  });

  test('should get the last index of an item in the list with a condition', () {
    final list = RxList<int>([1, 2, 3, 2]);
    expect(list.lastIndexWhere((item) => item == 2), 3);
  });

  test('should set the length of the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.length = 2;
    expect(list.value, [1, 2]);
    expect(list.stream, emits([1, 2]));
  });

  test('should remove an item from the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.remove(2);
    expect(list.value, [1, 3]);
    expect(list.stream, emits([1, 3]));
  });

  test('should remove an item from the list at a given index', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.removeAt(1);
    expect(list.value, [1, 3]);
    expect(list.stream, emits([1, 3]));
  });

  test('should remove the last item from the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.removeLast();
    expect(list.value, [1, 2]);
    expect(list.stream, emits([1, 2]));
  });

  test('should remove a range of items from the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.removeRange(0, 2);
    expect(list.value, [3]);
    expect(list.stream, emits([3]));
  });

  test('should remove all items from the list that match a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.removeWhere((item) => item == 2);
    expect(list.value, [1, 3]);
    expect(list.stream, emits([1, 3]));
  });

  test('should replace a range of items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.replaceRange(0, 2, [4, 5, 6]);
    expect(list.value, [4, 5, 6, 3]);
    expect(list.stream, emits([4, 5, 6, 3]));
  });

  test('should retain all items in the list that match a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.retainWhere((item) => item == 2);
    expect(list.value, [2]);
    expect(list.stream, emits([2]));
  });

  test('should get the reversed list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.reversed, [3, 2, 1]);
  });

  test('should set all items in the list to a value', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.setAll(0, [4, 5, 6]);
    expect(list.value, [4, 5, 6]);
    expect(list.stream, emits([4, 5, 6]));
  });

  test('should set the items in the list within a given range', () {
    final list = RxList<int>([1, 2, 3, 4]);
    expect(list, isA<RxList<int>>());
    list.setRange(0, 3, [4, 5, 6]);
    expect(list.value, [4, 5, 6, 4]);
    expect(list.stream, emits([4, 5, 6, 4]));
  });

  test('should shuffle the items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.shuffle();
    final shuffleOptions = [
      [3, 2, 1],
      [2, 3, 1],
      [2, 1, 3],
      [3, 1, 2],
      [1, 3, 2],
      [1, 2, 3],
    ];
    expect(list.value, anyOf(shuffleOptions));
    expect(list.stream, emits(anyOf(shuffleOptions)));
  });

  test('should shuffle the items in the list with a random', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.shuffle(Random(1));
    final shuffleOptions = [
      [3, 2, 1],
      [2, 3, 1],
      [2, 1, 3],
      [3, 1, 2],
      [1, 3, 2],
      [1, 2, 3],
    ];
    expect(list.value, anyOf(shuffleOptions));
    expect(list.stream, emits(anyOf(shuffleOptions)));
  });

  test('should sort the items in the list', () {
    final list = RxList<int>([2, 3, 1]);
    expect(list, isA<RxList<int>>());
    list.sort();
    expect(list.value, [1, 2, 3]);
    expect(list.stream, emits([1, 2, 3]));
  });

  test('should sort the items in the list with a custom comparator', () {
    final list = RxList<int>([2, 3, 1]);
    expect(list, isA<RxList<int>>());
    list.sort((a, b) => b.compareTo(a));
    expect(list.value, [3, 2, 1]);
    expect(list.stream, emits([3, 2, 1]));
  });

  test('should get the sublist of items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.sublist(0, 2), [1, 2]);
  });

  test('should get sublist of items with a given type', () {
    final list = RxList<dynamic>([1, 'Hi', 2, false, 3]);
    expect(list.whereType<int>(), [1, 2, 3]);
  });

  test('should set the last item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list, isA<RxList<int>>());
    list.last = 4;
    expect(list.value, [1, 2, 4]);
    expect(list.stream, emits([1, 2, 4]));
  });

  test('should check if any item in the list matches a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.any((item) => item == 2), true);
    expect(list.any((item) => item == 4), false);
  });

  test('should cast the list to a different type', () {
    final list = RxList<int>([1, 2, 3]);
    final castedList = list.cast<num>();
    expect(castedList, isA<List<num>>());
    expect(castedList, <num>[1, 2, 3]);
  });

  test('should check if the list contains an item', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.contains(2), true);
    expect(list.contains(4), false);
  });

  test('should get an element at a given index', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.elementAt(1), 2);
  });

  test('should check if every item in the list matches a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.every((item) => item > 0), true);
    expect(list.every((item) => item < 3), false);
  });

  test('should get the first item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.first, 1);
  });

  test('should get the first item in the list that matches a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.firstWhere((item) => item == 2), 2);
  });

  test('should fold the items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.fold(0, (int previousValue, element) => previousValue + element), 6);
  });

  test('should iterate over each item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    var sum = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((item) => sum += item);
    expect(sum, 6);
  });

  test('should check if the list is empty', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.isEmpty, false);
    expect(list.isNotEmpty, true);
  });

  test('should join list into string', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.join(), '123');
  });

  test('should get the last item in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.last, 3);
  });

  test('should get the last item in the list that matches a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.lastWhere((item) => item == 2), 2);
  });

  test('should get the length of the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.length, 3);
  });

  test('should map the items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.map((item) => item * 2), [2, 4, 6]);
  });

  test('should reduce the items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.reduce((int value, element) => value + element), 6);
  });

  test('should check if the list contains a single item', () {
    final list = RxList<int>([1, 2, 3]);
    expect(() => list.single, throwsA(isA<StateError>()));
    final list2 = RxList<int>([1]);
    expect(list2.single, 1);
  });

  test('should check if the list contains a single item that matches a condition', () {
    final list = RxList<int>([1, 2, 3, 2]);
    expect(() => list.singleWhere((item) => item == 2), throwsA(isA<StateError>()));
    final list2 = RxList<int>([2]);
    expect(list2.singleWhere((item) => item == 2), 2);
    expect(list2.singleWhere((item) => item == 4, orElse: () => 3), 3);
  });

  test('should skip the first n items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.skip(1), [2, 3]);
  });

  test('should skip the first n items in the list while they match a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.skipWhile((item) => item < 3), [3]);
  });

  test('should get the first n items in the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.take(2), [1, 2]);
  });

  test('should get the first n items in the list while they match a condition', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.takeWhile((item) => item < 3), [1, 2]);
  });

  test('should convert the list to another list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.toList(), [1, 2, 3]);
  });

  test('should convert the list to a set', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.toSet(), {1, 2, 3});
  });

  test('should filter the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.where((item) => item > 1), [2, 3]);
  });

  test('should expand the list', () {
    final list = RxList<int>([1, 2, 3]);
    expect(list.expand((item) => [item, item * 2]), [1, 2, 2, 4, 3, 6]);
  });
}
