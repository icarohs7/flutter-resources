///Return the result of invoking the
///given function or null if it throws
T runCatching<T>(T Function() fn) {
  try {
    return fn();
  } catch (_) {
    return null;
  }
}
