import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// [useFuture] while remembering the first future
/// instance and retaining it
AsyncSnapshot<T> useMemoizedFuture<T>(Future<T> future) {
  final memoizedFuture = useMemoized(() => future);
  final snapshot = useFuture(memoizedFuture);
  return snapshot;
}

/// [useFuture] direcly returning the result of the
/// future if it's completed, or null otherwise
T? useFutureData<T>(Future<T> future) {
  final snapshot = useFuture(future);
  if (snapshot.hasData) {
    return snapshot.data;
  }
  return null;
}

/// Memoizes the given [future] and returns its result
/// if it's completed, or null otherwise
T? useMemoizedFutureData<T>(Future<T> future) {
  final memoizedFuture = useMemoized(() => future);
  final data = useFutureData(memoizedFuture);
  return data;
}

/// [useStream] while remembering the first stream
/// instance and retaining it
AsyncSnapshot<T> useMemoizedStream<T>(Stream<T> stream) {
  final memoizedStream = useMemoized(() => stream);
  final snapshot = useStream(memoizedStream);
  return snapshot;
}

/// [useStream] direcly returning the emitted values
/// or null when there are none
T? useStreamData<T>(Stream<T> stream) {
  final snapshot = useStream(stream);
  if (snapshot.hasData) {
    return snapshot.data;
  }
  return null;
}

/// Memoizes the given [stream] and returns the emitted values
/// or null when there are none
T? useMemoizedStreamData<T>(Stream<T> stream) {
  final memoizedStream = useMemoized(() => stream);
  final data = useStreamData(memoizedStream);
  return data;
}
