import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CRAsyncSnapshotExtensions', (tester) async {
    final snapshot = AsyncSnapshot<int>.withData(ConnectionState.done, 1);
    expect(snapshot.isNone, false);
    expect(snapshot.isWaiting, false);
    expect(snapshot.isActive, false);
    expect(snapshot.isDone, true);
    expect(snapshot.isError, false);

    final snapshot2 = AsyncSnapshot<int>.withError(ConnectionState.done, Exception());
    expect(snapshot2.isNone, false);
    expect(snapshot2.isWaiting, false);
    expect(snapshot2.isActive, false);
    expect(snapshot2.isDone, true);
    expect(snapshot2.isError, true);

    final snapshot3 = AsyncSnapshot<int>.nothing();
    expect(snapshot3.isNone, true);
    expect(snapshot3.isWaiting, false);
    expect(snapshot3.isActive, false);
    expect(snapshot3.isDone, false);
    expect(snapshot3.isError, false);

    final snapshot4 = AsyncSnapshot<int>.waiting();
    expect(snapshot4.isNone, false);
    expect(snapshot4.isWaiting, true);
    expect(snapshot4.isActive, false);
    expect(snapshot4.isDone, false);
    expect(snapshot4.isError, false);

    final snapshot5 = AsyncSnapshot<int>.withData(ConnectionState.active, 1);
    expect(snapshot5.isNone, false);
    expect(snapshot5.isWaiting, false);
    expect(snapshot5.isActive, true);
    expect(snapshot5.isDone, false);
    expect(snapshot5.isError, false);
  });
}
