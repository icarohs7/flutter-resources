part of core_resources;

class Lazy<T> {
  Lazy(this.builder);

  final T Function() builder;
  T _v;

  T get v => _v ?? _setV();

  T _setV() => _v = builder();
}
