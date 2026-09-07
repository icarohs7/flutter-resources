/// Used instead of `void` when a successful computation has no value.
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
final class const Unit._instance() {
  static const _unit = Unit._instance();

  @override
  String toString() => '()';
}

/// The single [Unit] value.
const unit = Unit._unit;
