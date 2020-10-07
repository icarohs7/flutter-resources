import 'dart:io';

import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create try instance without letting exceptions escape', () async {
    final f1 = Try<int>(() => throw FormatException());
    expect(f1.value, null);
    expect(f1.isValue, false);
    expect(f1.exception.runtimeType, FormatException);
    expect(f1.message, '');

    final f2 = Try<int>(() => 1532);
    expect(f2.value, 1532);
    expect(f2.isValue, true);
    expect(f2.exception, null);
    expect(f2.message, '');

    final f3 = await Try.async<int>(() async {
      await Future.delayed(Duration(milliseconds: 5));
      throw FormatException();
    });
    expect(f3.value, null);
    expect(f3.isValue, false);

    final f4 = await Try.async<int>(() async {
      await Future.delayed(Duration(milliseconds: 5));
      return 1532;
    });
    expect(f4.value, 1532);
    expect(f4.isValue, true);
  });

  test('should create try instances using multiple constructors', () {
    final f1 = Try.value(42);
    expect(f1.value, 42);
    expect(f1.isValue, true);
    expect(f1.exception, null);
    expect(f1.message, '');

    final f2 = Try.message('error');
    expect(f2.value, null);
    expect(f2.isValue, false);
    expect(f2.exception, null);
    expect(f2.message, 'error');

    final f3 = Try.exception(IntegerDivisionByZeroException());
    expect(f3.value, null);
    expect(f3.isValue, false);
    expect(f3.exception.runtimeType, IntegerDivisionByZeroException);
    expect(f3.message, '');
  });

  test('try operators should work', () {
    final f1 = Try.value(237);
    expect(f1.fold(() => 999, (a) => a - 10), 227);
    expect(f1.map((a) => a - 5), Try.value(232));
    expect(f1 | 99, 237);
    expect(f1.getOrElse(() => 99), 237);

    final f2 = Try<String>.exception(SocketException('error'));
    expect(f2.fold(() => 'hello', (a) => 'world'), 'hello');
    expect(f2.map((a) => 'world').value, null);
    expect(f2.map((a) => 'world').message, '');
    expect(f2.map((a) => 'world').exception.runtimeType, SocketException);
    expect(f2 | 'world', 'world');
    expect(f2.getOrElse(() => 'hello'), 'hello');
  });
}
