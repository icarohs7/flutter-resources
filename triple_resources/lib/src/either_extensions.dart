import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

extension CREitherExtensions<L extends Object, R extends Object> on Either<L, R> {
  /// Convert a [Either] from fpdart to a [EitherAdapter] usable by
  /// the [Store] of the triple package
  EitherAdapter<L, R> toTripleEither() => FpDartEitherAdapter(this);
}

/// Adapter to use [Either] from fpdart in a triple [Store]
class FpDartEitherAdapter<L extends Object, R extends Object> extends EitherAdapter<L, R> {
  final Either<L, R> either;

  FpDartEitherAdapter(this.either);

  @override
  T fold<T>(T Function(L l) leftF, T Function(R l) rightF) => either.fold(leftF, rightF);
}
