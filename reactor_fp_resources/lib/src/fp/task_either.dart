import 'either.dart';
import 'function.dart';
import 'task.dart';

/// Asynchronous computation that yields [R] or fails with [L].
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
final class TaskEither<L, R> {
  final Future<Either<L, R>> Function() _run;

  const TaskEither(this._run);

  /// Lift a success value into a completed [TaskEither].
  factory TaskEither.of(R r) => TaskEither(() async => Either.of(r));

  /// Lift a success value into a completed [TaskEither].
  factory TaskEither.right(R right) => TaskEither.of(right);

  /// Lift a failure value into a completed [TaskEither].
  factory TaskEither.left(L left) => TaskEither(() async => Left(left));

  /// Wrap an existing [Either] as a completed [TaskEither].
  factory TaskEither.fromEither(Either<L, R> either) => TaskEither(() async => either);

  /// Run [run]; on success return [Right], on throw return [Left] from [onError].
  factory TaskEither.tryCatch(
    Future<R> Function() run,
    L Function(Object error, StackTrace stackTrace) onError,
  ) =>
      TaskEither(() async {
        try {
          return Right(await run());
        } catch (error, stack) {
          return Left(onError(error, stack));
        }
      });

  /// Map the [Right] value; [Left] is unchanged.
  TaskEither<L, C> map<C>(C Function(R r) f) => TaskEither(() => run().then((e) => e.map(f)));

  /// Map the [Left] value; [Right] is unchanged.
  TaskEither<C, R> mapLeft<C>(C Function(L l) f) =>
      TaskEither(() => run().then((e) => e.mapLeft(f)));

  /// Chain another [TaskEither] from the [Right] value; [Left] short-circuits.
  TaskEither<L, C> flatMap<C>(TaskEither<L, C> Function(R r) f) => TaskEither(
        () => run().then((either) => either.match(left, (r) => f(r).run())),
      );

  /// Discard the [Right] value and continue with [then].
  TaskEither<L, C> andThen<C>(TaskEither<L, C> Function() then) => flatMap((_) => then());

  /// Chain a synchronous [Either] from the [Right] value.
  TaskEither<L, C> chainEither<C>(Either<L, C> Function(R r) f) =>
      flatMap((r) => f(r).toTaskEither());

  /// Run [chain] for its effects; keep the original [R] (even if [chain] fails).
  TaskEither<L, R> chainFirst<C>(TaskEither<L, C> Function(R b) chain) =>
      flatMap((b) => chain(b).map((_) => b).orElse((_) => TaskEither.right(b)));

  /// On [Left], replace with the result of [orElse].
  TaskEither<TL, R> orElse<TL>(TaskEither<TL, R> Function(L l) orElse) => TaskEither(
        () async => (await run()).match(
          (l) => orElse(l).run(),
          (r) => TaskEither<TL, R>.right(r).run(),
        ),
      );

  /// Collapse to a [Task], mapping [Left] with [orElse].
  Task<R> getOrElse(R Function(L l) orElse) =>
      Task(() async => (await run()).match(orElse, identity));

  /// Pattern-match into a [Task] of [A].
  Task<A> match<A>(A Function(L l) onLeft, A Function(R r) onRight) =>
      Task(() => run().then((e) => e.match(onLeft, onRight)));

  /// Execute the computation.
  Future<Either<L, R>> run() => _run();

  /// Map each element with [f] and collect results in parallel.
  static TaskEither<E, List<B>> traverseListWithIndex<E, A, B>(
    List<A> list,
    TaskEither<E, B> Function(A a, int i) f,
  ) =>
      TaskEither(
        () async => Either.sequenceList(
          await Task.traverseListWithIndex(list, (a, i) => Task(() => f(a, i).run())).run(),
        ),
      );

  /// Map each element with [f] and collect results in parallel.
  static TaskEither<E, List<B>> traverseList<E, A, B>(
    List<A> list,
    TaskEither<E, B> Function(A a) f,
  ) =>
      traverseListWithIndex(list, (a, _) => f(a));

  /// Sequence a list of [TaskEither] in parallel.
  static TaskEither<E, List<A>> sequenceList<E, A>(List<TaskEither<E, A>> list) =>
      traverseList(list, identity);

  /// Map each element with [f] and collect results sequentially.
  ///
  /// Every task still runs; the first [Left] wins when results are sequenced.
  static TaskEither<E, List<B>> traverseListWithIndexSeq<E, A, B>(
    List<A> list,
    TaskEither<E, B> Function(A a, int i) f,
  ) =>
      TaskEither(
        () async => Either.sequenceList(
          await Task.traverseListWithIndexSeq(list, (a, i) => Task(() => f(a, i).run())).run(),
        ),
      );

  /// Map each element with [f] and collect results sequentially.
  static TaskEither<E, List<B>> traverseListSeq<E, A, B>(
    List<A> list,
    TaskEither<E, B> Function(A a) f,
  ) =>
      traverseListWithIndexSeq(list, (a, _) => f(a));

  /// Sequence a list of [TaskEither] sequentially.
  static TaskEither<E, List<A>> sequenceListSeq<E, A>(List<TaskEither<E, A>> list) =>
      traverseListSeq(list, identity);
}

/// Convert this [Either] into a completed [TaskEither].
extension EitherToTaskEither<L, R> on Either<L, R> {
  /// Wrap as [TaskEither.fromEither].
  TaskEither<L, R> toTaskEither() => TaskEither.fromEither(this);
}
