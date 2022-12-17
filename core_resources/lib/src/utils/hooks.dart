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
/// future if it completes, or null otherwise
T? useFutureData<T>(Future<T> future) {
  final snapshot = useFuture(future);
  if (snapshot.hasData) {
    return snapshot.data;
  }
  return null;
}

/// [useStream] direcly returning the result of the
/// stream if it completes, or null otherwise
T? useStreamData<T>(Stream<T> stream) {
  final snapshot = useStream(stream);
  if (snapshot.hasData) {
    return snapshot.data;
  }
  return null;
}
