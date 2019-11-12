extension IterableExtensions<T> on Iterable<T> {
  ///Returns the element at the given [index]
  ///or null if the list doesn't contain the
  ///index
  T getOrNull(int index) {
    try {
      return elementAt(index);
    } on RangeError {
      return null;
    }
  }
}
