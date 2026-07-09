import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'mocks.dart';

void main() {
  test('ignore function', () {
    expect(ignore(10), unit);
    expect(ignore(10, 'a'), unit);
    expect(ignore(10, 'a', true), unit);
    expect(ignore(10, 'a', true, 15.7), unit);
    expect(ignore(10, 'a', true, 15.7, 'nani!?'), unit);
  });

  test('taskEitherCatch', () {
    final task1 = taskEitherCatch(() async => 1532, MockFailure.new);
    final task2 = taskEitherCatch(() async => throw Exception, MockFailure.new);
    expect(task1.run(), completion(equals(right(1532))));
    expect(task2.run(), completion(equals(left(MockFailure()))));
  });

  test('eitherCatch', () {
    final either1 = eitherCatch(() => 1532, MockFailure.new);
    final either2 = eitherCatch(() => throw Exception, MockFailure.new);
    expect(either1, equals(right(1532)));
    expect(either2, equals(left(MockFailure())));
  });
}
