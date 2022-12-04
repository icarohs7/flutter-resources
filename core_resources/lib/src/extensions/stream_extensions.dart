import 'package:collection/collection.dart' show IterableExtension;

import '../../core_resources.dart';

extension ListStreamExtensions<T> on Stream<List<T>> {
  ///Apply the given filter to each list emitted by the stream
  Stream<List<T>> innerFilter(bool Function(T element) predicate) {
    return map((list) => list.where(predicate).toList());
  }

  ///Map each emitted list to the first item matching the given
  ///[predicate]
  Stream<T?> innerFirst(bool Function(T element) predicate) {
    return map((list) => list.firstWhereOrNull(predicate));
  }
}

extension CoreStreamExtensions<T> on Stream<T> {
  /// Convert each emission into a list aggregating
  /// all previous emissions plus the latest one
  Stream<List<T>> collect() async* {
    final items = <T>[];
    await for (final item in this) {
      items.add(item);
      yield items;
    }
  }

  /// [collect] with a initial value
  ValueStream<List<T>> collectValue() => collect().shareValueSeeded([]);
}
