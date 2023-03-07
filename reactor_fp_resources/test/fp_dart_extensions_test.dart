import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'mocks.dart';

void main() {
  test('Task<Either<L,R>>.merge', () {
    final task = Task(() => Future.value(Either.right(1)));
    final taskEither = task.merge();
    expect(taskEither.run(), completion(equals(Either.right(1))));

    final task2 = Task(() => Future.value(Either.left(1)));
    final taskEither2 = task2.merge();
    expect(taskEither2.run(), completion(equals(Either.left(1))));
  });

  test('Task<Option<R>>.merge', () {
    final task = Task(() => Future.value(some(1)));
    final taskOption = task.merge();
    expect(taskOption.run(), completion(equals(some(1))));

    final task2 = Task(() => Future.value(Option.none()));
    final taskOption2 = task2.merge();
    expect(taskOption2.run(), completion(equals(Option.none())));
  });

  test('TaskOption<R>.catchMap', () {
    //arrange
    final task1 = TaskOption.some(10);
    final task2 = TaskOption.some('Hello');
    final task3 = TaskOption.none();
    //act
    final result1 = task1.catchMap((r) async => r * 42);
    final result2 = task2.catchMap((r) async => throw Exception());
    final result3 = task3.catchMap((r) async => 1532);
    //assert
    expect(result1.run(), completion(equals(some(420))));
    expect(result2.run(), completion(equals(none())));
    expect(result3.run(), completion(equals(none())));
  });

  test('TaskOption<R>.matchEither', () {
    //arrange
    final task1 = TaskOption.some(10);
    final task2 = TaskOption.none();
    //act
    final result1 = task1.matchEither(() => Exception(), (r) => r * 42);
    final result2 = task2.matchEither(() => MockFailure(), (r) => 1532);
    //assert
    expect(result1.run(), completion(equals(right(420))));
    expect(result2.run(), completion(equals(left(MockFailure()))));
  });
}
