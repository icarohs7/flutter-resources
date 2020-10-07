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

  test('try operators should work', () async {
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
    
    final f3 = Try.value(1532);
    expect(f3.flatMap((b) => Try.value(b * 2)), Try.value(3064));

    final f4 = Try<int>.message('error');
    expect(f4.flatMap((b) => Try.value(b * 15)), Try<int>.message('error'));

    final f5 = Try.value(Try.value(995));
    expect(f5.flatten(), Try.value(995));

    final f6 = Try(() {
      throw HandshakeException();
      return Try.value(997);
    });
    expect(f6.flatten().message, Try<int>.exception(HandshakeException()).message);
    expect(f6.flatten().exception.runtimeType, HandshakeException);
    expect(f6.flatten().value, Try<int>.exception(HandshakeException()).value);

    final f7 = Try(() => Try.exception(FileSystemException()));
    expect(f7.flatten().message, Try<int>.exception(FileSystemException()).message);
    expect(f7.flatten().exception.runtimeType, FileSystemException);
    expect(f7.flatten().value, Try<int>.exception(FileSystemException()).value);

    final f8 = Try.async(() async {
      Future.delayed(Duration(milliseconds: 5));
      throw HandshakeException();
      return Try.value(997);
    });
    expect((await f8.flatten()).message, Try.exception(HandshakeException()).message);
    expect((await f8.flatten()).exception.runtimeType, HandshakeException);
    expect((await f8.flatten()).value, Try.exception(HandshakeException()).value);

    final f9 = Try.async(() async {
      Future.delayed(Duration(milliseconds: 5));
      return Try.exception(FileSystemException());
    });
    expect((await f9.flatten()).message, Try.exception(FileSystemException()).message);
    expect((await f9.flatten()).exception.runtimeType, FileSystemException);
    expect((await f9.flatten()).value, Try.exception(FileSystemException()).value);
  });
}
