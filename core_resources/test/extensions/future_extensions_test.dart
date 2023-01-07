import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should run async code', () async {
    final result = await runAsync(() => Future.value(1));
    expect(result, 1);
  });

  test('should run async code and return value or fallback on error', () async {
    final f1 = await runAsyncOrDefault(1532, () => throw Exception('Test'));
    expect(f1, equals(1532));

    final f2 = await runAsyncOrDefault('nani!?', () => 'kono giorno giovanna niwa yume ga aru');
    expect(f2, equals('kono giorno giovanna niwa yume ga aru'));
  });

  test('should return future if it succeeds or log error', () async {
    var printed = '';
    late Object e;
    late StackTrace s;
    await runZoned(() async {
      final f1 = await Future.value(1).loggingErrors();
      expect(f1, equals(1));

      final f2 = Future.error(Exception('Test')).loggingErrors();
      expect(f2, throwsException);
      try {
        await f2;
      } catch (err, stack) {
        e = err;
        s = stack;
      }
    }, zoneSpecification: ZoneSpecification(print: (_, __, ___, message) => printed = message));

    expect(printed, equals('Error on future: null -> $e\n$s'));

    printed = '';
    await runZoned(() async {
      final f1 = await Future.value(1).loggingErrors(functionName: 'test');
      expect(f1, equals(1));

      final f2 = Future.error(Exception('Test')).loggingErrors(functionName: 'test');
      expect(f2, throwsException);
      try {
        await f2;
      } catch (err, stack) {
        e = err;
        s = stack;
      }
    }, zoneSpecification: ZoneSpecification(print: (_, __, ___, message) => printed = message));

    expect(printed, equals('Error on future: test -> $e\n$s'));

    printed = '';
    await runZoned(() async {
      final f1 = await Future.value(1).loggingErrors(errToString: (e, s) => 'Error: $e');
      expect(f1, equals(1));

      final f2 = Future.error(Exception('Test')).loggingErrors(errToString: (e, s) => 'Error? $e');
      expect(f2, throwsException);
      try {
        await f2;
      } catch (err, stack) {
        e = err;
        s = stack;
      }
    }, zoneSpecification: ZoneSpecification(print: (_, __, ___, message) => printed = message));

    expect(printed, equals('Error on future: null -> Error? $e'));
  });

  test('should turn future value into null if it\'s a failure', () async {
    final f1 = Future<int>(() => throw Exception());
    final r1 = await f1.orNull();
    expect(r1, isNull);

    final f2 = Future(() => 1532);
    final r2 = await f2.orNull();
    expect(r2, equals(1532));
  });

  test('should turn future value into fallback if it\'s a failure', () async {
    final f1 = Future<int>(() => throw Exception());
    final r1 = await f1.or(1532);
    expect(r1, equals(1532));

    final f2 = Future(() => 1532);
    final r2 = await f2.or(1532);
    expect(r2, equals(1532));
  });

  test('should turn future value into empty list if it\'s a failure', () async {
    final f1 = Future<List<int>>(() => throw Exception());
    final r1 = await f1.orEmpty();
    expect(r1, isEmpty);

    final f2 = Future(() => [24, 42, 1532]);
    final r2 = await f2.orEmpty();
    expect(r2, equals([24, 42, 1532]));
  });
}
