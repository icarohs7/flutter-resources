import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('useMemoizedFuture test', (tester) async {
    final subject = ValueNotifier(Future.value(0));

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final future = useValueListenable(subject);
            final value = useMemoizedFuture(future);
            return Text(value.data.toString());
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    subject.value = Future.value(1);
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
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
    final subject = ValueNotifier(Future.value(0));

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final future = useValueListenable(subject);
            final value = useMemoizedFutureData(future);
            return Text(value.toString());
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    subject.value = Future.value(1);
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('useMemoizedStream test', (tester) async {
    final subject = ValueNotifier(StreamController()..add(0));
    final subjectSubject = subject.value;

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final stream = useValueListenable(subject);
            final value = useMemoizedStream(stream.stream);
            return Text(value.data.toString());
          },
        ),
      ),
    );

    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subject.value = StreamController()..add(1);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subjectSubject.add(2);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('2'), findsOneWidget);

    subjectSubject.close();
    subject.value.close();
  });

  testWidgets('useStreamData test', (tester) async {
    final subject = StreamController();

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

    subject.close();
  });

  testWidgets('useMemoizedStreamData test', (tester) async {
    final subject = ValueNotifier(StreamController()..add(0));
    final subjectSubject = subject.value;

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final stream = useValueListenable(subject);
            final value = useMemoizedStreamData(stream.stream);
            return Text(value.toString());
          },
        ),
      ),
    );

    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subject.value = (StreamController()..add(1));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subjectSubject.add(2);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('2'), findsOneWidget);

    subjectSubject.close();
    subject.value.close();
  });

  testWidgets('useMemoizedFuture with keys test', (tester) async {
    final key = ValueNotifier(0);
    final subject = ValueNotifier(Future.value(0));

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final keyValue = useValueListenable(key);
            final future = useValueListenable(subject);
            final value = useMemoizedFuture(future, [keyValue]);
            return Text(value.data.toString());
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    subject.value = Future.value(1);
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    key.value = 1;
    await tester.pump();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('useMemoizedFutureData with keys test', (tester) async {
    final key = ValueNotifier(0);
    final subject = ValueNotifier(Future.value(0));

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final keyValue = useValueListenable(key);
            final future = useValueListenable(subject);
            final value = useMemoizedFutureData(future, [keyValue]);
            return Text(value.toString());
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    subject.value = Future.value(1);
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    key.value = 1;
    await tester.pump();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('useMemoizedStream with keys test', (tester) async {
    final key = ValueNotifier(0);
    final subject = ValueNotifier(StreamController()..add(0));

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final keyValue = useValueListenable(key);
            final stream = useValueListenable(subject);
            final value = useMemoizedStream(stream.stream, [keyValue]);
            return Text(value.data.toString());
          },
        ),
      ),
    );

    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subject.value = StreamController()..add(1);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    key.value = 1;
    await tester.pump(Duration(milliseconds: 300));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('1'), findsOneWidget);

    subject.value.close();
  });

  testWidgets('useMemoizedStreamData with keys test', (tester) async {
    final key = ValueNotifier(0);
    final subject = ValueNotifier(StreamController()..add(0));

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final keyValue = useValueListenable(key);
            final stream = useValueListenable(subject);
            final value = useMemoizedStreamData(stream.stream, [keyValue]);
            return Text(value.toString());
          },
        ),
      ),
    );

    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    subject.value = StreamController()..add(1);
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('0'), findsOneWidget);
    key.value = 1;
    await tester.pump(Duration(milliseconds: 300));
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('1'), findsOneWidget);

    subject.value.close();
  });
}
