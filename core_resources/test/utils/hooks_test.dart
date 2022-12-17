import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('useValueStream test', (tester) async {
    final subject = 0.subject;

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final value = useValueStream(subject);
            return Text(value.toString());
          },
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    subject.add(1);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('useFutureData test', (tester) async {
    final completer = Completer<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final value = useFutureData(completer.future);
            return Text(value.toString());
          },
        ),
      ),
    );

    expect(find.text('null'), findsOneWidget);
    completer.complete(1);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('useMemoizedFutureData test', (tester) async {
    final subject = Future.value(0).subject;

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final future = useValueStream(subject);
            final value = useMemoizedFutureData(future);
            return Text(value.toString());
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    subject.add(Future.value(1));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('useStreamData test', (tester) async {
    final subject = BehaviorSubject<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final value = useStreamData(subject.stream);
            return Text(value.toString());
          },
        ),
      ),
    );

    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('null'), findsOneWidget);
    subject.add(1);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('1'), findsOneWidget);
    subject.add(2);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('useMemoizedStreamData test', (tester) async {
    final subject = 0.subject.subject;
    final subjectSubject = subject.value;

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final stream = useValueStream(subject);
            final value = useMemoizedStreamData(stream);
            return Text(value.toString());
          },
        ),
      ),
    );

    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subject.add(1.subject);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subjectSubject.add(2);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('2'), findsOneWidget);
  });
}
