import 'dart:async';

import 'package:drift/drift.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

/// Converts a Drift error and its stack trace into an application failure.
typedef DriftFailureMapper<F> = F Function(Object error, StackTrace stackTrace);

/// Failure-aware operations on a Drift database.
extension DriftDatabaseExtensions on GeneratedDatabase {
  /// Runs an arbitrary database operation and maps failures with [onError].
  TaskEither<F, T> tryRun<F, T>(
    FutureOr<T> Function() fn, {
    required DriftFailureMapper<F> onError,
  }) {
    return TaskEither.tryCatch(() async => await fn(), onError);
  }

  /// Runs a Drift batch and maps failures with [onError].
  TaskEither<F, Unit> tryBatch<F>(
    FutureOr<void> Function(Batch batch) runInBatch, {
    required DriftFailureMapper<F> onError,
  }) {
    return TaskEither.tryCatch(() async {
      await batch(runInBatch);
      return unit;
    }, onError);
  }

  /// Inserts one row, replacing an existing row by default.
  TaskEither<F, Unit> tryInsert<F, T extends Table, D>(
    TableInfo<T, D> table,
    Insertable<D> row, {
    InsertMode? mode,
    required DriftFailureMapper<F> onError,
  }) {
    return TaskEither.tryCatch(() async {
      await table.insertOne(row, mode: mode ?? InsertMode.insertOrReplace);
      return unit;
    }, onError);
  }

  /// Inserts multiple rows, replacing existing rows by default.
  TaskEither<F, Unit> tryInsertAll<F, T extends Table, D>(
    TableInfo<T, D> table,
    Iterable<Insertable<D>> rows, {
    InsertMode? mode,
    required DriftFailureMapper<F> onError,
  }) {
    return TaskEither.tryCatch(() async {
      await table.insertAll(rows, mode: mode ?? InsertMode.insertOrReplace);
      return unit;
    }, onError);
  }

  /// Updates rows matching [where] and maps failures with [onError].
  TaskEither<F, int> tryUpdate<F, T extends Table, D>(
    TableInfo<T, D> table, {
    required Expression<bool> Function(T tbl) where,
    required Insertable<D> newRow,
    required DriftFailureMapper<F> onError,
  }) {
    return TaskEither.tryCatch(() async {
      return (table.update()..where(where)).write(newRow);
    }, onError);
  }

  /// Deletes rows matching [where] and maps failures with [onError].
  TaskEither<F, int> tryDelete<F, T extends Table, D>(
    TableInfo<T, D> table, {
    required Expression<bool> Function(T tbl) where,
    required DriftFailureMapper<F> onError,
  }) {
    return TaskEither.tryCatch(() async {
      return (table.delete()..where(where)).go();
    }, onError);
  }

  /// Deletes every row from [table].
  TaskEither<F, int> tryDeleteAll<F, T extends Table, D>(
    TableInfo<T, D> table, {
    required DriftFailureMapper<F> onError,
  }) {
    return TaskEither.tryCatch(table.deleteAll, onError);
  }

  /// Replaces all rows in [table] within one transaction.
  TaskEither<F, Unit> tryReplaceAll<F, T extends Table, D>(
    TableInfo<T, D> table,
    Iterable<Insertable<D>> rows, {
    InsertMode? mode,
    required DriftFailureMapper<F> onError,
  }) {
    return tryBatch<F>((batch) {
      batch.deleteAll(table);
      batch.insertAll(table, rows, mode: mode ?? InsertMode.insertOrReplace);
    }, onError: onError);
  }

  /// Watches the first row matching [filter], or `null` when there is none.
  Stream<D?> streamSingle<T extends Table, D>(
    TableInfo<T, D> table,
    Expression<bool> Function(T tbl) filter,
  ) {
    return (select(table)
          ..where(filter)
          ..limit(1))
        .watchSingleOrNull();
  }
}

/// Batch helpers that operate without a failure wrapper.
extension DriftBatchExtensions on Batch {
  /// Deletes all rows and inserts [rows] in the current batch.
  void nReplaceAll<T extends Table, D>(TableInfo<T, D> table, Iterable<Insertable<D>> rows) {
    deleteAll(table);
    insertAll(table, rows);
  }
}

/// Failure-aware one-shot operations on a Drift query.
extension DriftSelectableExtensions<T> on Selectable<T> {
  /// Gets all rows and maps failures with [onError].
  TaskEither<F, List<T>> tryGet<F>({required DriftFailureMapper<F> onError}) =>
      TaskEither.tryCatch(get, onError);

  /// Gets one row and maps failures with [onError].
  TaskEither<F, T> tryGetSingle<F>({required DriftFailureMapper<F> onError}) =>
      TaskEither.tryCatch(getSingle, onError);
}
