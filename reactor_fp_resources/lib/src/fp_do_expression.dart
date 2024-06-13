import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

/// Create a [TaskEither] using a syntax similar to the [Do] notation in functional languages
///
/// example:
///
/// ```dart
/// TaskEither<Failure, String> getFileContents() { ... }
///
/// Either<Failure, String> getProcessedDataSync(String contents) { ... }
///
/// Either<Failure, Unit> storeData(String data) { ... }
///
/// // $ and $$ will return the result of the given Either and TaskEither, respectively
/// // or fail with the Left result of that respective Either/TaskEither
/// final TaskEither<Failure, Unit> result = taskEitherDo(($, $$) async {
///   final fileContents = await $$(getFileContents()); // $$ returns a Future<T> (use await)
///
///   final processedData = $(getProcessedDataSync()); // $ returns T (synchronous)
///
///   return $(storeData(processedData));
/// });
/// ```
TaskEither<L, R> taskEitherDo<L, R>(CRDoFunctionTaskEither<L, R> f) {
  return TaskEither<L, R>(() async {
    try {
      return Either.right(await f(_doEitherAdapter<L>(), _doTaskEitherAdapter<L>()));
    } on _TaskEitherThrow<L> catch (e) {
      return Either.left(e.value);
    }
  });
}

/// [taskEitherDo] running the computation on a
/// separated isolate
TaskEither<L, R> taskEitherDoBg<L, R>(CRDoFunctionTaskEither<L, R> f) {
  return TaskEither<L, R>(() {
    return compute((_) async {
      try {
        return Either.right(await f(_doEitherAdapter<L>(), _doTaskEitherAdapter<L>()));
      } on _TaskEitherThrow<L> catch (e) {
        return Either.left(e.value);
      }
    }, 0);
  });
}

class _TaskEitherThrow<L> {
  final L value;

  const _TaskEitherThrow(this.value);
}

typedef _DoAdapterEither<L> = R Function<R>(Either<L, R>);
typedef _DoAdapterTaskEither<L> = Future<R> Function<R>(TaskEither<L, R>);

_DoAdapterEither<L> _doEitherAdapter<L>() =>
    <R>(Either<L, R> either) => either.getOrElse((l) => throw _TaskEitherThrow(l));

_DoAdapterTaskEither<L> _doTaskEitherAdapter<L>() => <R>(TaskEither<L, R> taskEither) =>
    taskEither.run().then((either) => either.getOrElse((l) => throw _TaskEitherThrow(l)));

typedef CRDoFunctionTaskEither<L, R> = Future<R> Function(
  _DoAdapterEither<L> $,
  _DoAdapterTaskEither<L> $$,
);
