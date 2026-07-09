import 'fp/fp.dart';

/// Utility to convert any function up to arity 5 to a [Unit].
Unit ignore([_, __, ___, ____, _____]) => unit;

/// Shortcut to create a [TaskEither.tryCatch].
///
/// Ignores the error/stacktrace and returns [onError] as [Left].
TaskEither<L, R> taskEitherCatch<L, R>(Future<R> Function() fn, L Function() onError) =>
    TaskEither.tryCatch(fn, (_, __) => onError());

/// Shortcut to create a [Either.tryCatch].
///
/// Ignores the error/stacktrace and returns [onError] as [Left].
Either<L, R> eitherCatch<L, R>(R Function() fn, L Function() onError) =>
    Either.tryCatch(fn, (_, __) => onError());
