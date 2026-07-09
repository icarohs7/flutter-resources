/// Used instead of `void` when a successful computation has no value.
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
final class Unit {
  static const _unit = Unit._instance();
  const Unit._instance();

  @override
  String toString() => '()';
}

/// The single [Unit] value.
const unit = Unit._unit;
