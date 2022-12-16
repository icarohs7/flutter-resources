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
