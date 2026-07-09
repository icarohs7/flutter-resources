/// Returns the given [a].
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
T identity<T>(T a) => a;

/// Returns the given [a], wrapped in [Future.value].
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
Future<T> identityFuture<T>(T a) => Future.value(a);
