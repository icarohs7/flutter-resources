import 'dart:async';

import 'package:async/async.dart';

/// Wrap the given future result into a Result instance
Future<Result<T>> runCatchingAsync<T>(FutureOr<T> Function() fn) async {
  try {
    return Result.value(await fn());
  } catch (e) {
    return Result.error(e);
  }
}

extension FutureExtensions<T> on Future<T> {
  Future<T> loggingErrors([String Function(dynamic e) errToString]) {
    return Future.microtask(() async {
      try {
        return await this;
      } catch (e) {
        print("Error on future: ${errToString?.call(e) ?? e}");
        rethrow;
      }
    });
  }
}
