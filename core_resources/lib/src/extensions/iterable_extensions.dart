extension CRIterableExtensions<T> on Iterable<T> {
  /// Replace the element at [index] with [value]
  /// inside a new iterable, without changing the original one.
  /// Does nothing if index is out of bounds, except when
  /// index is 0 and the iterable is empty.
  Iterable<T> put(int index, T value) sync* {
    for (final (elementIndex, oldValue) in indexed) {
      yield elementIndex == index ? value : oldValue;
    }

    if (index == 0 && isEmpty) yield value;
  }

  /// Returns `true` only if this iterable contains exactly [elemCount] elements.
  ///
  /// Iterates at most [elemCount] + 1 elements, so it short-circuits on
  /// iterables larger than [elemCount] without consuming the full sequence.
  bool hasCountElements(int elemCount) {
    return take(elemCount + 1).length == elemCount;
  }
}
