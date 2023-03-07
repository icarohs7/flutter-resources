import 'package:flutter_test/flutter_test.dart';
import 'package:triple_resources/triple_resources.dart';

void main() {
  test('create disposable from lambda', () {
    //arrange
    var count = 0;
    final disposable = Disposable.create(() => count++);
    expect(count, 0);
    //act
    disposable.onDispose();
    //assert
    expect(count, 1);
  });
}
