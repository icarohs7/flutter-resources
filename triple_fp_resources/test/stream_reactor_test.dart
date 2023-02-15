import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:triple_fp_resources/src/stream_reactor.dart';

void main() {
  Future pump() => Future.delayed(Duration(milliseconds: 100));

  test('eager stream reactor change value with stream', () async {
    //arrange
    final controller = StreamController();
    final stream = controller.stream;
    final reactor = stream.asRc(eagerSubscribe: true);
    //act
    controller.add('test');
    await pump();
    //assert
    expect(reactor.value, 'test');

    //act
    controller.add(10);
    await pump();
    //assert
    expect(reactor.value, 10);

    reactor.dispose();
  });

  test('lazy stream reactor change only when listened to', () async {
    //arrange
    final controller = StreamController();
    final stream = controller.stream;
    final reactor = stream.asRc(eagerSubscribe: false);
    //act
    controller.add('test');
    await pump();
    //assert
    expect(reactor.value, null);

    //arrange
    var count = 0;
    listener() => count++;
    reactor.addListener(listener);
    //act
    controller.add(1532);
    await pump();
    //assert
    expect(count, 2);
    expect(reactor.value, 1532);

    reactor.dispose();
  });

  test('non-nullable stream reactor with initial value', () async {
    //arrange
    final controller = StreamController<int>();
    final stream = controller.stream;
    //act
    final reactor = stream.asRcValue(10);
    //assert
    expect(reactor.value, 10);

    //arrange
    var count = 0;
    reactor.addListener(() => count++);
    //act
    controller.add(42);
    await pump();
    //assert
    expect(count, 1);
    expect(reactor.value, 42);

    reactor.dispose();
  });
}
