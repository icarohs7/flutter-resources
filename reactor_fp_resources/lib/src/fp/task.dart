import 'function.dart';

/// Asynchronous computation that yields a value of type [A] and never fails.
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
final class Task<A> {
  final Future<A> Function() _run;

  const Task(this._run);

  /// Lift [a] into a completed [Task].
  factory Task.of(A a) => Task(() async => a);

  /// Map the result of this [Task].
  Task<B> map<B>(B Function(A a) f) => Task(() => run().then(f));

  /// Chain another [Task] from the result.
  Task<B> flatMap<B>(Task<B> Function(A a) f) => Task(() => run().then((v) => f(v).run()));

  /// Discard the result and continue with [then].
  Task<B> andThen<B>(Task<B> Function() then) => flatMap((_) => then());

  /// Execute the computation.
  Future<A> run() => _run();

  /// Run each mapped [Task] in [list] in parallel (order preserved).
  static Task<List<B>> traverseListWithIndex<A, B>(
    List<A> list,
    Task<B> Function(A a, int i) f,
  ) =>
      Task(() => Future.wait(List.generate(list.length, (i) => f(list[i], i).run())));

  /// Run each mapped [Task] in [list] in parallel.
  static Task<List<B>> traverseList<A, B>(List<A> list, Task<B> Function(A a) f) =>
      traverseListWithIndex(list, (a, _) => f(a));

  /// Run each mapped [Task] in [list] in sequence.
  static Task<List<B>> traverseListWithIndexSeq<A, B>(
    List<A> list,
    Task<B> Function(A a, int i) f,
  ) =>
      Task(() async {
        final collect = <B>[];
        for (var i = 0; i < list.length; i++) {
          collect.add(await f(list[i], i).run());
        }
        return collect;
      });

  /// Run each mapped [Task] in [list] in sequence.
  static Task<List<B>> traverseListSeq<A, B>(List<A> list, Task<B> Function(A a) f) =>
      traverseListWithIndexSeq(list, (a, _) => f(a));

  /// Sequence a list of [Task] in parallel.
  static Task<List<A>> sequenceList<A>(List<Task<A>> list) => traverseList(list, identity);

  /// Sequence a list of [Task] sequentially.
  static Task<List<A>> sequenceListSeq<A>(List<Task<A>> list) => traverseListSeq(list, identity);
}
