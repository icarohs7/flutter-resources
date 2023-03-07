import 'package:fpdart/fpdart.dart';

extension CRTaskOfEitherExtensions<L, R> on Task<Either<L, R>> {
  /// Merge the [Task] and [Either] containers in a single [TaskEither]
  TaskEither<L, R> merge() => TaskEither(run);
}

extension CRTaskOfOptionExtensions<R> on Task<Option<R>> {
  /// Merge the [Task] and [Option] containers in a single [TaskOption]
  TaskOption<R> merge() => TaskOption(run);
}

extension CRTaskOptionExtensions<R> on TaskOption<R> {
  /// Map the value of the task catching any errors
  ///
  /// Caught errors will make this [TaskOption] a [None]
  TaskOption<C> catchMap<C>(Future<C> Function(R r) mapper) =>
      flatMap((r) => TaskOption.tryCatch(() => mapper(r)));

  /// Pattern matching to convert a [TaskOption] to a [TaskEither].
  ///
  /// When this [TaskOption] returns a [None], the result will be a [Left] created from [onNone]
  /// Otherwise the result will be a [Right] created from [onSome]
  TaskEither<L, R2> matchEither<L, R2>(L Function() onNone, R2 Function(R r) onSome) =>
      match<Either<L, R2>>(() => left(onNone()), (r) => right(onSome(r))).merge();
}
