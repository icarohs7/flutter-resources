/// Return a [Right] wrapping [r].
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
Either<L, R> right<L, R>(R r) => Right<L, R>(r);

/// Return a [Left] wrapping [l].
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
Either<L, R> left<L, R>(L l) => Left<L, R>(l);

/// Represents a value of one of two possible types, [Left] or [Right].
///
/// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
sealed class Either<L, R> {
  const Either();

  /// Return a [Right] wrapping [r].
  factory Either.of(R r) => Right(r);

  /// Return a [Right] wrapping [r].
  factory Either.right(R r) => Right(r);

  /// Return a [Left] wrapping [l].
  factory Either.left(L l) => Left(l);

  /// If [r] is `null`, return [Left] from [onNull]; otherwise [Right].
  factory Either.fromNullable(R? r, L Function() onNull) =>
      r != null ? Either.of(r) : Either.left(onNull());

  /// Run [run]; on success return [Right], on throw return [Left] from [onError].
  factory Either.tryCatch(
    R Function() run,
    L Function(Object error, StackTrace stackTrace) onError,
  ) {
    try {
      return Either.of(run());
    } catch (e, s) {
      return Either.left(onError(e, s));
    }
  }

  /// Convert a `List<Either>` to a single [Either] of a list.
  ///
  /// Short-circuits on the first [Left].
  static Either<E, List<A>> sequenceList<E, A>(List<Either<E, A>> list) {
    final result = <A>[];
    for (final e in list) {
      switch (e) {
        case Left(:final value):
          return left(value);
        case Right(:final value):
          result.add(value);
      }
    }
    return right(result);
  }

  /// Map each element with [f] and [sequenceList] the results.
  static Either<E, List<B>> traverseList<E, A, B>(
    List<A> list,
    Either<E, B> Function(A a) f,
  ) =>
      sequenceList(list.map(f).toList());

  /// Map the [Right] value; [Left] is unchanged.
  Either<L, C> map<C>(C Function(R a) f);

  /// Map the [Left] value; [Right] is unchanged.
  Either<C, R> mapLeft<C>(C Function(L a) f);

  /// Chain another [Either] from the [Right] value; [Left] short-circuits.
  Either<L, C> flatMap<C>(Either<L, C> Function(R a) f);

  /// Discard the [Right] value and continue with [then].
  Either<L, R2> andThen<R2>(Either<L, R2> Function() then) => flatMap((_) => then());

  /// Pattern-match on [Left] / [Right].
  C match<C>(C Function(L l) onLeft, C Function(R r) onRight);

  /// Alias of [match].
  C fold<C>(C Function(L l) onLeft, C Function(R r) onRight) => match(onLeft, onRight);

  /// Return the [Right] value, or [orElse] applied to the [Left].
  R getOrElse(R Function(L l) orElse);

  /// [Right] value, or `null` when this is [Left].
  R? toNullable();

  /// [Left] value, or `null` when this is [Right].
  L? leftOrNull();

  /// Whether this is a [Left].
  bool isLeft();

  /// Whether this is a [Right].
  bool isRight();
}

/// Successful [Either] variant holding [value].
final class Right<L, R> extends Either<L, R> {
  final R _value;

  const Right(this._value);

  /// The wrapped success value.
  R get value => _value;

  @override
  Either<L, C> map<C>(C Function(R a) f) => Right<L, C>(f(_value));

  @override
  Either<C, R> mapLeft<C>(C Function(L a) f) => Right<C, R>(_value);

  @override
  Either<L, C> flatMap<C>(Either<L, C> Function(R a) f) => f(_value);

  @override
  C match<C>(C Function(L l) onLeft, C Function(R r) onRight) => onRight(_value);

  @override
  R getOrElse(R Function(L l) orElse) => _value;

  @override
  R? toNullable() => _value;

  @override
  L? leftOrNull() => null;

  @override
  bool isLeft() => false;

  @override
  bool isRight() => true;

  @override
  bool operator ==(Object other) => other is Right && other._value == _value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Right($_value)';
}

/// Failed [Either] variant holding [value].
final class Left<L, R> extends Either<L, R> {
  final L _value;

  const Left(this._value);

  /// The wrapped failure value.
  L get value => _value;

  @override
  Either<L, C> map<C>(C Function(R a) f) => Left<L, C>(_value);

  @override
  Either<C, R> mapLeft<C>(C Function(L a) f) => Left<C, R>(f(_value));

  @override
  Either<L, C> flatMap<C>(Either<L, C> Function(R a) f) => Left<L, C>(_value);

  @override
  C match<C>(C Function(L l) onLeft, C Function(R r) onRight) => onLeft(_value);

  @override
  R getOrElse(R Function(L l) orElse) => orElse(_value);

  @override
  R? toNullable() => null;

  @override
  L? leftOrNull() => _value;

  @override
  bool isLeft() => true;

  @override
  bool isRight() => false;

  @override
  bool operator ==(Object other) => other is Left && other._value == _value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Left($_value)';
}
