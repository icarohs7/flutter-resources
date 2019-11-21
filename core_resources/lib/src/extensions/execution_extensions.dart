import 'package:flutter/material.dart';

///Return the result of invoking the
///given function or null if it throws
T runCatching<T>(T Function() fn) {
  try {
    return fn();
  } catch (_) {
    return null;
  }
}

///Measures the execution time of the given
///[operation]
BenchmarkedResult<T> measureTimeMillis<T>(T Function() operation) {
  final stopwatch = Stopwatch()..start();
  final result = operation();
  stopwatch.stop();
  return BenchmarkedResult(value: result, milliseconds: stopwatch.elapsedMilliseconds);
}

class BenchmarkedResult<T> {
  BenchmarkedResult({@required this.value, @required this.milliseconds});

  final T value;
  final int milliseconds;
}
