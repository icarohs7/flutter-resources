import 'package:fpdart/fpdart.dart';

import 'fp_dart_extensions.dart';

/// Utility to convert any function up to arity 5 to a [Unit]
Unit ignore([_, __, ___, ____, _____]) => unit;

/// Shortcut to create a [TaskEither.tryCatch]
///
/// Ignores the [error] and [stacktrace] of the exception and
/// returns the result of [onError] as the [Left] part on error
TaskEither<L, R> taskEitherCatch<L, R>(Future<R> Function() fn, L Function() onError) =>
    TaskEither.tryCatch(fn, (_, __) => onError());

/// Shortcut to create a [Either.tryCatch]
///
/// Ignores the [error] and [stacktrace] of the exception and
/// returns the result of [onError] as the [Left] part on error
Either<L, R> eitherCatch<L, R>(R Function() fn, L Function() onError) =>
    Either.tryCatch(fn, (_, __) => onError());

/// Shortcut to [TaskOption.tryCatch]
TaskOption<R> taskOptionCatch<R>(Future<R> Function() fn) => TaskOption.tryCatch(fn);

/// Convert the nullable result of the [Future] to a [Option]
TaskOption<R> taskOptionNullable<R>(Future<R?> Function() fn) =>
    Task(fn).map((a) => Option.fromNullable(a)).merge();
