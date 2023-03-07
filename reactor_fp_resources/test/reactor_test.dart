import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';
import 'package:value_notifier_resources/value_notifier_resources.dart';

void main() {
  test('reduce method', () {
    //arrange
    var count = 0;
    final reactor = Rc(10);
    final sub = reactor.listen((_, __) => count++);
    //act
    reactor.reduce((state) => state * 42);
    //assert
    expect(count, 1);
    expect(reactor.value, 420);
    sub.cancel();
  });

  test('Rcn', () {
    //arrange
    final reactor1 = Rcn(10);
    final reactor2 = Rcn<String?>(null);
    //assert
    expect(reactor1, isA<Reactor<int?>>());
    expect(reactor1.value, 10);
    expect(reactor2, isA<Reactor<String?>>());
    expect(reactor2.value, null);
  });

  test('rc extension of T', () {
    //arrange
    final reactor1 = 10.rc;
    final reactor2 = 'hello'.rc;
    //assert
    expect(reactor1, isA<Reactor<int>>());
    expect(reactor1.value, 10);
    expect(reactor2, isA<Reactor<String>>());
    expect(reactor2.value, 'hello');
  });

  testWidgets('useReactor hook', (tester) async {
    //arrange
    final reactor = Rc(1532);
    await tester.pumpWidget(MaterialApp(home: HookBuilder(builder: (context) {
      final value = useReactor(reactor);
      return Text('$value');
    })));
    //assert
    expect(find.text('1532'), findsOneWidget);

    //act
    reactor.setValue(999);
    await tester.pump();
    //assert
    expect(find.text('999'), findsOneWidget);
  });
}
