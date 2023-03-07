import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:triple_resources/src/store_extensions.dart';

import 'mocks.dart';

void main() {
  Future pump() => Future.delayed(Duration(milliseconds: 100));

  test('should execute future return either', () async {
    //arrange
    final completer = Completer<int>();
    final store = MockStore();
    //act
    store.executeFpEither(() async => right(MockState(number: await completer.future)));
    await pump();
    //assert
    expect(store.isLoading, true);
    expect(store.state, MockState());

    //act
    completer.complete(1532);
    await pump();
    //assert
    expect(store.isLoading, false);
    expect(store.state, MockState(number: 1532));
  });

  test('should execute future with error', () async {
    //arrange
    final completer = Completer<int>();
    final store = MockStore();
    //act
    store.executeFpEither(
      () => TaskEither.tryCatch(
        () async => MockState(number: await completer.future),
        (e, s) => MockFailure('failure $e'),
      ).run(),
    );
    await pump();
    //assert
    expect(store.isLoading, true);

    //act
    completer.completeError('failed');
    await pump();
    //assert
    expect(store.isLoading, false);
    expect(store.state, MockState());
    expect(store.error, MockFailure('failure failed'));
  });

  test('execute future without changing the state object', () async {
    //arrange
    final completer = Completer<Function()>();
    final store = MockStore();
    //act
    store.launchFpEither(() async => right((await completer.future)()));
    await pump();
    //assert
    expect(store.isLoading, true);

    //act
    var count = 0;
    completer.complete(() => count++);
    await pump();
    //assert
    expect(store.isLoading, false);
    expect(store.state, MockState());
    expect(store.error, null);
  });
}
