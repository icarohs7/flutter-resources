import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'mocks.dart';

void main() {
  test('ignore function', () {
    //assert
    expect(ignore(10), unit);
    expect(ignore(10, 'a'), unit);
    expect(ignore(10, 'a', true), unit);
    expect(ignore(10, 'a', true, 15.7), unit);
    expect(ignore(10, 'a', true, 15.7, 'nani!?'), unit);
  });

  test('taskEitherCatch', () {
    //arrange
    final task1 = taskEitherCatch(() async => 1532, MockFailure.new);
    final task2 = taskEitherCatch(() async => throw Exception, MockFailure.new);
    //assert
    expect(task1.run(), completion(equals(right(1532))));
    expect(task2.run(), completion(equals(left(MockFailure()))));
  });

  test('eitherCatch', () {
    //arrange
    final either1 = eitherCatch(() => 1532, MockFailure.new);
    final either2 = eitherCatch(() => throw Exception, MockFailure.new);
    //assert
    expect(either1, equals(right(1532)));
    expect(either2, equals(left(MockFailure())));
  });

  test('taskOptionCatch', () {
    //arrange
    final task1 = taskOptionCatch(() async => 1532);
    final task2 = taskOptionCatch(() async => throw Exception());
    //assert
    expect(task1.run(), completion(equals(some(1532))));
    expect(task2.run(), completion(equals(none())));
  });

  test('taskOptionNullable', () {
    //arrange
    final task1 = taskOptionNullable(() async => 1532);
    final task2 = taskOptionNullable<int>(() async => null);
    //assert
    expect(task1.run(), completion(equals(some(1532))));
    expect(task2.run(), completion(equals(none())));
  });
}
