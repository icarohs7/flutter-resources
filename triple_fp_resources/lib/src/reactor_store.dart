import 'dart:async';

import 'package:core_resources/core_resources.dart' hide Store;
import 'package:flutter/foundation.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:value_notifier_resources/value_notifier_resources.dart';

import 'disposable.dart';
import 'reactor.dart';

class ReactorStore<Error extends Object, State extends Object> extends Store<Error, State>
    implements Selectors<Reactor<Error?>, Reactor<State>, Reactor<bool>>, Disposable {
  late final _disposeList = <Disposer>[
    () async => _stateSubject.dispose(),
    () async => _errorSubject.dispose(),
    () async => _loadingSubject.dispose(),
  ];

  ReactorStore(super.initialState);

  late final _stateSubject = state.rc;
  late final _errorSubject = error.rc;
  late final _loadingSubject = isLoading.rc;

  @override
  Reactor<State> get selectState => _stateSubject;

  @override
  Reactor<Error?> get selectError => _errorSubject;

  @override
  Reactor<bool> get selectLoading => _loadingSubject;

  void addDisposable(Disposer Function() dispose) => _disposeList.add(dispose());

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

  void connectValueListenable<T>(
    ValueListenable<T> listenable,
    State Function(T) onData,
  ) {
    addDisposable(() {
      void listener() => update(onData(listenable.value));
      listenable.addListener(listener);
      return () async => listenable.removeListener(listener);
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
