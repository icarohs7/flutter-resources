import 'dart:async';
import 'dart:collection';
import 'dart:math';

import '../../core_resources.dart';

/// A [List] that notifies its listeners when it changes through its [stream].
class RxList<T> implements List<T> {
  RxList([List<T>? list])
      : _list = list ?? <T>[],
        _controller = BehaviorSubject.seeded(list ?? <T>[]);

  final List<T> _list;

  final BehaviorSubject<List<T>> _controller;

  UnmodifiableListView<T> get value => UnmodifiableListView(_list);

  Stream<List<T>> get stream => _controller;

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  RxList<T> operator +(List<T> other) => RxList(_list + other);

  @override
  T operator [](int index) => _list[index];

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
    _controller.add(_list);
  }

  @override
  void add(T value) {
    _list.add(value);
    _controller.add(_list);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    _controller.add(_list);
  }

  @override
  Map<int, T> asMap() => _list.asMap();

  @override
  void clear() {
    _list.clear();
    _controller.add(_list);
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    _list.fillRange(start, end, fillValue);
    _controller.add(_list);
  }

  @override
  set first(T value) {
    _list.first = value;
    _controller.add(_list);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) => _list.followedBy(other);

  @override
  Iterable<T> getRange(int start, int end) => _list.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _list.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) => _list.indexWhere(test, start);

  @override
  void insert(int index, T element) {
    _list.insert(index, element);
    _controller.add(_list);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _list.insertAll(index, iterable);
    _controller.add(_list);
  }

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  int lastIndexOf(T element, [int? start]) => _list.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      _list.lastIndexWhere(test, start);

  @override
  set length(int newLength) {
    _list.length = newLength;
    _controller.add(_list);
  }

  @override
  bool remove(Object? value) {
    final result = _list.remove(value);
    if (result) _controller.add(_list);
    return result;
  }

  @override
  T removeAt(int index) {
    final result = _list.removeAt(index);
    _controller.add(_list);
    return result;
  }

  @override
  T removeLast() {
    final result = _list.removeLast();
    _controller.add(_list);
    return result;
  }

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    _controller.add(_list);
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _list.removeWhere(test);
    _controller.add(_list);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    _list.replaceRange(start, end, replacements);
    _controller.add(_list);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _list.retainWhere(test);
    _controller.add(_list);
  }

  @override
  Iterable<T> get reversed => _list.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) {
    _list.setAll(index, iterable);
    _controller.add(_list);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    _controller.add(_list);
  }

  @override
  void shuffle([Random? random]) {
    _list.shuffle(random);
    _controller.add(_list);
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _list.sort(compare);
    _controller.add(_list);
  }

  @override
  List<T> sublist(int start, [int? end]) => _list.sublist(start, end);

  @override
  Iterable<T> whereType<T>() => _list.whereType<T>();

  @override
  set last(T value) {
    _list.last = value;
    _controller.add(_list);
  }

  @override
  bool any(bool Function(T element) test) => _list.any(test);

  @override
  List<R> cast<R>() => _list.cast<R>();

  @override
  bool contains(Object? element) => _list.contains(element);

  @override
  T elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _list.every(test);

  @override
  T get first => _list.first;

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) =>
      _list.fold(initialValue, combine);

  @override
  void forEach(void Function(T element) action) {
    _list.forEach(action);
    _controller.add(_list);
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  T get last => _list.last;

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  int get length => _list.length;

  @override
  Iterable<R> map<R>(R Function(T e) toElement) => _list.map(toElement);

  @override
  T reduce(T Function(T value, T element) combine) => _list.reduce(combine);

  @override
  T get single => _list.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _list.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _list.skipWhile(test);

  @override
  Iterable<T> take(int count) => _list.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _list.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() => _list.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => _list.where(test);

  @override
  Iterable<R> expand<R>(Iterable<R> toElements(T element)) => _list.expand(toElements);
}
