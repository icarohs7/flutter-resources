import 'package:flutter_test/flutter_test.dart';
import 'package:triple_fp_resources/src/reactor.dart';
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
}
