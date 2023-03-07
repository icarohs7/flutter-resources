// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:triple_resources/triple_resources.dart';
import 'package:value_notifier_resources/value_notifier_resources.dart';

import 'mocks.dart';

void main() {
  Future pump() => Future.delayed(Duration(milliseconds: 100));

  group('store class', () {
    test('change states', () async {
      //arrange
      final store = MockStore();
      final newState = MockState(description: 'Hello, World!');
      //act
      store.update(newState);
      //assert
      expect(store.state, newState);
    });

    test('change error', () async {
      //arrange
      final store = MockStore();
      final newError = MockFailure('Hello, Error');
      expect(store.error, isNull);
      //act
      store.setError(newError);
      //assert
      expect(store.error, newError);
    });

    test('change loading', () async {
      //arrange
      final store = MockStore();
      expect(store.isLoading, false);
      //act
      store.setLoading(true);
      //assert
      expect(store.isLoading, true);
    });

    test('state, error and loading are observable', () {
      //arrange
      final store = MockStore();
      var stateCount = 0;
      var errorCount = 0;
      var loadingCount = 0;
      //act
      final subs = [
        store.selectState.listen((_, __) => stateCount++),
        store.selectError.listen((_, __) => errorCount++),
        store.selectLoading.listen((_, __) => loadingCount++),
      ];
      //assert
      expect(stateCount, 0);
      expect(errorCount, 0);
      expect(loadingCount, 0);

      //act
      store.update(MockState(description: '1'));
      store.update(MockState(description: '2'));
      store.setError(MockFailure('E1'));
      store.setError(MockFailure('E2'));
      store.setError(MockFailure('E3'));
      store.setLoading(true);
      //assert
      expect(stateCount, 2);
      expect(errorCount, 3);
      expect(loadingCount, 1);

      subs.forEach((element) => element.cancel());
    });

    test('observer method', () async {
      //arrange
      final store = MockStore();
      var stateCount = 0;
      var errorCount = 0;
      var loadingCount = 0;
      //act
      final dispose = store.observer(
        onState: (_) => stateCount++,
        onError: (_) => errorCount++,
        onLoading: (_) => loadingCount++,
      );
      //assert
      expect(stateCount, 0);
      expect(errorCount, 0);
      expect(loadingCount, 0);

      //act
      store.update(MockState(description: '1'));
      store.update(MockState(description: '2'));
      store.setError(MockFailure('E1'));
      store.setError(MockFailure('E2'));
      store.setError(MockFailure('E3'));
      store.setLoading(true);
      //assert
      expect(stateCount, 2);
      expect(errorCount, 3);
      expect(loadingCount, 1);

      dispose();
    });

    test('connect stream', () async {
      //arrange
      final store = MockStore();
      final controller = StreamController<int>();
      var canceled = 0;
      final stream = controller.stream.doOnCancel(() => canceled++);
      //act
      store.connectStream(stream, (data) => MockState(description: '$data'));
      controller.add(1532);
      await pump();
      //assert
      expect(store.state, MockState(description: '1532'));

      //act
      expect(canceled, 0);
      await store.onDispose();
      //assert
      expect(canceled, 1);
    });

    test('connect stream with error', () async {
      //arrange
      final store = MockStore();
      final controller = StreamController<int>();
      var canceled = 0;
      final stream = controller.stream.doOnCancel(() => canceled++);
      //act
      store.connectStream(
        stream,
        (data) => MockState(description: '$data'),
        onError: (e, s) => MockFailure('it failed with $e'),
      );
      controller.addError('deadge');
      await pump();
      //assert
      expect(store.state, MockState());
      expect(store.error, MockFailure('it failed with deadge'));
    });

    test('connect valueListenable', () async {
      //arrange
      final store = MockStore();
      final listenable = ValueNotifier(0);
      //act
      store.connectValueListenable(listenable, (data) => MockState(description: '$data'));
      listenable.value = 1532;
      //assert
      expect(store.state, MockState(description: '1532'));

      //act
      expect(listenable.hasListeners, true);
      await store.onDispose();
      //assert
      expect(listenable.hasListeners, false);
    });

    test('observe just part of the state', () async {
      //arrange
      final store = MockStore();
      var stateCount = 0;
      //act
      final dispose = store.observeStateSelect((state) => state.number, (value) => stateCount++);
      store.update(MockState(number: 1532));
      //assert
      expect(stateCount, 1);

      //act
      store.update(store.state.copyWith(description: '?????'));
      //assert
      expect(stateCount, 1);

      //act
      store.update(store.state.copyWith(number: 42));
      //assert
      expect(stateCount, 2);

      dispose();
    });
  });

  group('hooks', () {
    createStore() => MockStore();
    createWidget(Widget Function(BuildContext context) builder) {
      return MaterialApp(home: HookBuilder(builder: builder));
    }

    testWidgets('useStore', (tester) async {
      //arrange
      final store = createStore();
      //act
      await tester.pumpWidget(createWidget((context) {
        final s = useStore(store);

        return Column(
          children: [
            Text('${s.state}'),
            Text('${s.error}'),
            Text('${s.isLoading}'),
          ],
        );
      }));
      //assert
      expect(find.text(',0'), findsOneWidget);
      expect(find.text('null'), findsOneWidget);
      expect(find.text('false'), findsOneWidget);

      //act
      store.update(MockState(description: 'Hello', number: 1532));
      await tester.pump();
      //assert
      expect(find.text('Hello,1532'), findsOneWidget);
      expect(find.text('null'), findsOneWidget);
      expect(find.text('false'), findsOneWidget);

      //act
      store.setError(MockFailure('Hello Failure'));
      await tester.pump();
      //assert
      expect(find.text('Hello,1532'), findsOneWidget);
      expect(find.text('Hello Failure'), findsOneWidget);
      expect(find.text('false'), findsOneWidget);

      //act
      store.setLoading(true);
      await tester.pump();
      //assert
      expect(find.text('Hello,1532'), findsOneWidget);
      expect(find.text('Hello Failure'), findsOneWidget);
      expect(find.text('true'), findsOneWidget);
    });

    testWidgets('useStoreSelect', (tester) async {
      //arrange
      final store = createStore();
      var builds = 0;
      //act
      await tester.pumpWidget(createWidget((context) {
        final v = useStoreSelect(store, (state) => state.number);
        builds++;

        return Column(children: [Text('$v')]);
      }));
      //assert
      expect(builds, 1);
      expect(find.text('0'), findsOneWidget);

      //act
      store.update(store.state.copyWith(description: 'Hello'));
      await tester.pump();
      //assert
      expect(builds, 1);
      expect(find.text('0'), findsOneWidget);

      //act
      store.update(store.state.copyWith(number: 1532));
      await tester.pump();
      //assert
      expect(builds, 2);
      expect(find.text('1532'), findsOneWidget);
    });
  });
}
