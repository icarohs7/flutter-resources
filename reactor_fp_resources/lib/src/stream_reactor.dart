import 'dart:async';

import 'package:flutter/foundation.dart';

import 'reactor.dart';

/// A [Reactor] that updates its values according to the emissions of a [Stream]
class StreamReactor<T> extends Reactor<T> {
  final bool _keepAlive;
  bool _initialized;
  StreamSubscription? _subscription;
  final Stream<T> stream;

  /// Create a [Reactor] from a stream
  ///
  /// If set to true, the [eagerSubscribe] parameter will make
  /// the reactor subscribe to the stream immediately and update
  /// its value on every emission, even if there are no listeners,
  /// only cancelling it when [dispose] is called
  ///
  /// If set to false (default), it will only create a subscription
  /// when there are listeners and dispose of it when there are no
  /// more
  StreamReactor(this.stream, {bool eagerSubscribe = false, required T initialValue})
      : _keepAlive = eagerSubscribe,
        _initialized = eagerSubscribe,
        super(initialValue) {
    if (eagerSubscribe) _subscribe();
  }

  void _update(T event) => value = event;

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
  }

  void _subscribe() {
    _unsubscribe();
    _subscription = stream.listen(_update);
  }

  @override
  void addListener(VoidCallback listener) {
    if (!_initialized) {
      _initialized = true;
      _subscribe();
    }
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners && !_keepAlive) {
      _initialized = false;
      _unsubscribe();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _unsubscribe();
  }
}

extension ReactorStreamX<T> on Stream<T> {
  /// Creates a [StreamReactor] from a [Stream]
  StreamReactor<T?> asRc({bool eagerSubscribe = false, T? initialValue}) =>
      StreamReactor(asBroadcastStream(),
          eagerSubscribe: eagerSubscribe, initialValue: initialValue);
}

extension ReactorStreamX2<T extends Object> on Stream<T> {
  /// Creates a non-nullable [StreamReactor] from a [Stream], requiring a initial value
  /// due to the asynchronous nature of streams
  StreamReactor<T> asRcValue(T initialValue, {bool eagerSubscribe = false}) =>
      StreamReactor(asBroadcastStream(),
          eagerSubscribe: eagerSubscribe, initialValue: initialValue);
}
