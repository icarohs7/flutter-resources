import 'dart:async';

import 'package:async/async.dart';
import 'package:core_resources/core_resources.dart';

///Run the given operation asynchronously
Future<T> runAsync<T>(FutureOr<T> Function() fn) => Future(() async => await fn());

///Wrap the given future result into a Result instance
Future<Result<T>> runCatchingAsync<T>(FutureOr<T> Function() fn) async {
  try {
    return Result.value(await fn());
  } catch (e) {
    return Result.error(e);
  }
}

///Return the result of the given operation or the [fallback] if
///the operation throws
Future<T> runAsyncOrDefault<T>(T fallback, FutureOr<T> Function() fn) async {
  try {
    return await fn();
  } catch (e) {
    return fallback;
  }
}

extension FutureExtensions<T> on Future<T> {
  ///Intercepts errors thrown on the execution
  ///of the given future, logging them and rethrowing
  Future<T> loggingErrors({
    String Function(dynamic e) errToString,
    String Function(dynamic e) loggingFn,
  }) {
    return runAsync(() async {
      try {
        return await this;
      } catch (e) {
        loggingFn?.invoke(e) ?? print('Error on future: ${errToString?.call(e) ?? e}');
        rethrow;
      }
    });
  }

  ///Map the internal value of the future to itself if
  ///it's a success or null if it's a failure
  Future<T> orNull() {
    return runAsyncOrDefault(null, () => this);
  }

  ///Map the internal value of the future to itself if
  ///it's a success or [fallback] if it's a failure
  Future<T> or(T fallback) {
    return runAsyncOrDefault(fallback, () => this);
  }
}
