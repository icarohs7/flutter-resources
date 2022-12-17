import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

/// A [Hook] that returns the value of a [ValueStream] and updates
/// each time it emits a new event
T useValueStream<T>(
  ValueStream<T> stream, {
  bool preserveState = true,
}) {
  final snapshot = useStream(stream, preserveState: preserveState);
  return snapshot.data ?? stream.value;
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
