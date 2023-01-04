import 'package:flutter/material.dart';

extension CRAsyncSnapshotExtensions<T> on AsyncSnapshot<T> {
  bool get isNone => connectionState == ConnectionState.none;

  bool get isWaiting => connectionState == ConnectionState.waiting;

  bool get isActive => connectionState == ConnectionState.active;

  bool get isDone => connectionState == ConnectionState.done;

  bool get isError => hasError;

  R when<R>({
    required R Function() loading,
    required R Function(Object error, StackTrace stack) error,
    required R Function(T data) data,
    R Function()? none,
  }) {
    if (hasData) return data(this.data as T);
    if (isError) return error(this.error!, stackTrace!);
    if (isNone) return none?.call() ?? error(Exception('ConnectionState.none'), StackTrace.empty);
    return loading();
  }
}
