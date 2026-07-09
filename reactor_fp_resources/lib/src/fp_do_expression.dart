import 'package:flutter/foundation.dart';

import 'fp/fp.dart';

/// Create a [TaskEither] using a syntax similar to Do notation.
///
/// `$` unwraps an [Either]; `$$` unwraps a [TaskEither].
TaskEither<L, R> taskEitherDo<L, R>(CRDoFunctionTaskEither<L, R> f) {
  return TaskEither<L, R>(() async {
    try {
      return Either.right(await f(_doEitherAdapter<L>(), _doTaskEitherAdapter<L>()));
    } on _TaskEitherThrow<L> catch (e) {
      return Either.left(e.value);
    }
  });
}

/// [taskEitherDo] running the computation on a separated isolate.
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

typedef DoEitherAdapter<L> = R Function<R>(Either<L, R>);
typedef DoTaskEitherAdapter<L> = Future<R> Function<R>(TaskEither<L, R>);

DoEitherAdapter<L> _doEitherAdapter<L>() =>
    <R>(Either<L, R> either) => either.getOrElse((l) => throw _TaskEitherThrow(l));

DoTaskEitherAdapter<L> _doTaskEitherAdapter<L>() => <R>(TaskEither<L, R> taskEither) =>
    taskEither.run().then((either) => either.getOrElse((l) => throw _TaskEitherThrow(l)));

typedef CRDoFunctionTaskEither<L, R> = Future<R> Function(
  DoEitherAdapter<L> $,
  DoTaskEitherAdapter<L> $$,
);
