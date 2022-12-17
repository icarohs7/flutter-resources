import 'package:flutter/material.dart';

extension CRAsyncSnapshotExtensions on AsyncSnapshot {
  bool get isNone => connectionState == ConnectionState.none;

  bool get isWaiting => connectionState == ConnectionState.waiting;

  bool get isActive => connectionState == ConnectionState.active;

  bool get isDone => connectionState == ConnectionState.done;

  bool get isError => hasError;
}