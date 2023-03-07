import 'dart:async';

import 'package:core_resources/core_resources.dart' hide Store;
import 'package:flutter/foundation.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';
import 'package:value_notifier_resources/value_notifier_resources.dart';

import 'disposable.dart';

/// Implementation of a triple [Store] using [Reactor] as its observable type
class ReactorStore<Error extends Object, State extends Object> extends Store<Error, State>
    implements Selectors<Reactor<Error?>, Reactor<State>, Reactor<bool>>, Disposable {
  late final _disposeList = <Disposer>[
    () async => _stateSubject.dispose(),
    () async => _errorSubject.dispose(),
    () async => _loadingSubject.dispose(),
  ];

  ReactorStore(super.initialState);

  late final _stateSubject = state.rc;
  late final _errorSubject = Rcn(error);
  late final _loadingSubject = Rc(isLoading);

  /// Reactor to watch just the state of the store
  @override
  Reactor<State> get selectState => _stateSubject;

  /// /// Reactor to watch just the error of the store
  @override
  Reactor<Error?> get selectError => _errorSubject;

  /// Reactor to watch just the loading state of the store
  @override
  Reactor<bool> get selectLoading => _loadingSubject;

  /// Call the function and invoke its [Disposer] when the store is about to be destroyed
  ///
  /// Useful to create subscriptions that will live with the store and will be cancelled
  /// when the store is disposed
  void addDisposable(Disposer Function() dispose) => _disposeList.add(dispose());

  /// Subscribe to the given [stream] and update the state according to its emissions
  ///
  /// Maps every emission of the given [stream] to a new [State] object through the
  /// [onData] parameter, updating the current state of the store to it
  ///
  /// If defined, on any error of the [stream] the [onError] parameter will be called
  /// and the returned [Error] object will be set as the error of the store
  ///
  /// Automatically cancels the subscription when the store is destroyed
  void connectStream<T>(
    Stream<T> stream,
    FutureOr<State> Function(T data) onData, {
    Error Function(Object, StackTrace)? onError,
  }) {
    addDisposable(() {
      final subscription = stream.listen(
        (data) async => update(await onData(data)),
        onError: onError == null
            ? null
            : (Object error, StackTrace stack) => setError(onError(error, stack)),
      );
      return subscription.cancel;
    });
  }

  /// Subscribe to the given [valueListenable] and update the state according to its emissions
  ///
  /// Maps every emission of the given [valueListenable] to a new [State] object through the
  /// [onData] parameter, updating the current state of the store to it
  ///
  /// Automatically cancels the subscription when the store is destroyed
  void connectValueListenable<T>(
    ValueListenable<T> valueListenable,
    State Function(T) onData,
  ) {
    addDisposable(() {
      void listener() => update(onData(valueListenable.value));
      valueListenable.addListener(listener);
      return () async => valueListenable.removeListener(listener);
    });
  }

  @override
  void propagate(Triple<Error, State> triple) {
    super.propagate(triple);
    if (triple.event == TripleEvent.state) {
      runCatching(() => _stateSubject.setValue(triple.state));
    } else if (triple.event == TripleEvent.error) {
      runCatching(() => _errorSubject.setValue(triple.error));
    } else if (triple.event == TripleEvent.loading) {
      runCatching(() => _loadingSubject.setValue(triple.isLoading));
    }
  }

  /// Add a listener to the store and returns the [Disposer] of the subscription
  @override
  Disposer observer({
    void Function(State state)? onState,
    void Function(bool isLoading)? onLoading,
    void Function(Error error)? onError,
  }) {
    final stateSub = onState == null ? null : selectState.listen((v, _) => onState(v));
    final loadingSub = onLoading == null ? null : selectLoading.listen((l, _) => onLoading(l));
    final errorSub = onError == null
        ? null
        : selectError.where((e) => e != null).listen((e, _) {
            if (e == null) return;
            onError(e);
          });

    return () async {
      stateSub?.cancel();
      loadingSub?.cancel();
      errorSub?.cancel();
    };
  }

  /// Add a listener to a part of the state and returns the [Disposer] of the subscription
  Disposer observeStateSelect<T>(T Function(State state) select, void Function(T value) onValue) {
    final sub = selectState.select(select).listen((v, sub) => onValue(v));
    return () async => sub.cancel();
  }

  @override
  Future destroy() async {
    for (final dispose in _disposeList) {
      await dispose().orNull();
    }
  }

  @override
  FutureOr onDispose() => destroy();
}

/// Hook to subscribe to a part of the state of a [store], defined by the [selector]
T useStoreSelect<T, S extends Object>(
    ReactorStore<dynamic, S> store, T Function(S state) selector) {
  final stream = useMemoized(() => store.selectState.select(selector));

  return useReactor(stream) ?? selector(store.state);
}

/// Hook to subscribe to all events emitted by the [store]
Store useStore<Store extends ReactorStore>(Store store) {
  useStoreLoading(store);
  useStoreState(store);
  useStoreError(store);

  return store;
}

/// Hook to subscribe to the complete state of the [store]
///
/// See also: [useStoreSelect] to subscribe to just a part of the state
S useStoreState<S extends Object>(ReactorStore<dynamic, S> store) {
  return useReactor(store.selectState) ?? store.state;
}

/// Hook to subscribe to the error state of the [store]
E? useStoreError<E extends Object>(ReactorStore<E, dynamic> store) {
  return useReactor<E?>(store.selectError) ?? store.error;
}

/// Hook to subscribe to the loading state of the [store]
bool useStoreLoading(ReactorStore store) {
  return useReactor(store.selectLoading) ?? store.isLoading;
}
