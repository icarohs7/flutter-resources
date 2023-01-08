import 'package:flutter_test/flutter_test.dart';
import 'package:getx_resources/getx_resources.dart';

void main() {
  test('obsF', () {
    final stream = Stream.fromIterable([1, 2, 3]);
    final obs = stream.obsF();
    expect(obs.value, isNull);

    final sub = obs.listen((value) {
      expect(value, 3);
    });
    sub.cancel();
  });

  test('obsFNN', () {
    final stream = Stream.fromIterable([1, 2, 3]);
    final obs = stream.obsFNN(initialValue: 0);
    expect(obs.value, 0);

    final sub = obs.listen((value) {
      expect(value, 3);
    });
    sub.cancel();
  });

  test('obsFMap', () {
    final stream = Stream.fromIterable([{'a': 1}, {'b': 2}, {'c': 3}]);
    final obs = stream.obsFMap();
    expect(obs, isEmpty);

    final sub = obs.listen((value) {
      expect(value, {'c': 3});
    });
    sub.cancel();
  });
}
