import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';

import 'fp/fp.dart' as fp;
import 'fp/fp.dart' show Either, Task, TaskEither, Unit, left, right;

/// Merge [Task] and [Either] into a single [TaskEither].
extension CRTaskOfEitherExtensions<L, R> on Task<Either<L, R>> {
  /// Flatten `Task<Either<L, R>>` into [TaskEither].
  TaskEither<L, R> merge() => TaskEither(run);
}

/// Collapses [Either] failures to nullable values.
extension EitherOrNullExtension<L, R> on Either<L, R> {
  /// Returns the right value, or `null` when this is a [Left].
  R? orNull() => toNullable();
}

/// Collapses [TaskEither] failures to nullable [Future] values.
extension TaskEitherOrNullExtension<L, R> on TaskEither<L, R> {
  /// Runs this task and returns the right value, or `null` on [Left].
  Future<R?> orNull() async => (await run()).orNull();
}

/// Convenience helpers for [TaskEither] used across apps.
extension TaskEitherExtensions<L, R> on TaskEither<L, R> {
  /// Toggle [loadingObservable] while this task runs.
  TaskEither<L, R> withLoading(ValueNotifier<bool> loadingObservable) {
    return TaskEither(() async {
      try {
        loadingObservable.value = true;
        return await run();
      } finally {
        loadingObservable.value = false;
      }
    });
  }

  /// Run [op] on success, ignore its result, keep the original value.
  TaskEither<L, R> andThenRun(void Function(R) op) {
    return flatMap((r) {
      return TaskEither(() async {
        runCatching(() => op(r));
        return right(r);
      });
    });
  }

  /// Async variant of [andThenRun].
  TaskEither<L, R> andThenRunF(Future<void> Function(R) op) {
    return flatMap((r) {
      return TaskEither(() async {
        await op(r).orNull();
        return right(r);
      });
    });
  }

  /// Fail with [onTimeout] if [run] exceeds [timeout].
  TaskEither<L, R> withTimeout(Duration timeout, L Function() onTimeout) {
    return TaskEither(() async {
      return await run().timeout(timeout, onTimeout: () => left(onTimeout()));
    });
  }

  /// Log elapsed time via [clog] using [label].
  TaskEither<L, R> withTiming(String label) {
    return TaskEither(() async {
      final stopwatch = Stopwatch()..start();
      try {
        final result = await run();
        stopwatch.stop();
        clog('[$label] completed in ${stopwatch.elapsedMilliseconds}ms');
        return result;
      } catch (e) {
        stopwatch.stop();
        clog('[$label] failed in ${stopwatch.elapsedMilliseconds}ms');
        rethrow;
      }
    });
  }

  /// Run this [TaskEither] on an isolate via [compute].
  TaskEither<L, R> moveToIsolate() => TaskEither(() => compute((_) => run(), 0));
}

/// Convenience helpers for [Task].
extension TaskExtensions<R> on Task<R> {
  /// Continue with an async [then] after this [Task] completes.
  Task<B> andThenF<B>(Future<B> Function() then) => andThen(() => Task(() => then()));

  /// Run async [op] on success, ignore its result, keep the original value.
  Task<R> andThenRunF(Future<void> Function(R) op) {
    return flatMap((r) {
      return Task(() async {
        await op(r).orNull();
        return r;
      });
    });
  }

  /// Toggle [loadingObservable] while this task runs.
  Task<R> withLoading(ValueNotifier<bool> loadingObservable) {
    return Task(() async {
      try {
        loadingObservable.value = true;
        return await run();
      } finally {
        loadingObservable.value = false;
      }
    });
  }
}

/// Convert a completed [Future] of `void` into [Unit].
extension FutureVoidExtensions on Future<void> {
  /// Map completion to [unit].
  Future<Unit> get unit => then((_) => fp.unit);
}

/// Change the return type of a nullary void function to [Unit].
extension VoidFnExtensions0 on void Function() {
  /// Wrap so the function returns [unit].
  Unit Function() get unit => () {
        this();
        return fp.unit;
      };
}

/// Change the return type of a unary void function to [Unit].
extension VoidFnExtensions1<A> on void Function(A) {
  /// Wrap so the function returns [unit].
  Unit Function(A) get unit => (a) {
        this(a);
        return fp.unit;
      };
}

/// Change the return type of a binary void function to [Unit].
extension VoidFnExtensions2<A, B> on void Function(A, B) {
  /// Wrap so the function returns [unit].
  Unit Function(A, B) get unit => (a, b) {
        this(a, b);
        return fp.unit;
      };
}

/// Change the return type of a nullary async void function to [Future]<[Unit]>.
extension FutureVoidFnExtensions0 on Future<void> Function() {
  /// Wrap so the function returns [unit].
  Future<Unit> Function() get unit => () async {
        await this();
        return fp.unit;
      };
}

/// Change the return type of a unary async void function to [Future]<[Unit]>.
extension FutureVoidFnExtensions1<A> on Future<void> Function(A) {
  /// Wrap so the function returns [unit].
  Future<Unit> Function(A) get unit => (a) async {
        await this(a);
        return fp.unit;
      };
}

/// Change the return type of a binary async void function to [Future]<[Unit]>.
extension FutureVoidFnExtensions2<A, B> on Future<void> Function(A, B) {
  /// Wrap so the function returns [unit].
  Future<Unit> Function(A, B) get unit => (a, b) async {
        await this(a, b);
        return fp.unit;
      };
}
