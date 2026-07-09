import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

void main() {
  test('Task<Either<L,R>>.merge', () {
    final task = Task(() => Future.value(Either.right(1)));
    final taskEither = task.merge();
    expect(taskEither.run(), completion(equals(Either.right(1))));

    final task2 = Task(() => Future.value(Either.left(1)));
    final taskEither2 = task2.merge();
    expect(taskEither2.run(), completion(equals(Either.left(1))));
  });

  test('Either.orNull', () {
    expect(right<int, int>(1).orNull(), 1);
    expect(left<int, int>(0).orNull(), isNull);
  });

  test('TaskEither.orNull', () async {
    expect(await TaskEither<int, int>.right(1).orNull(), 1);
    expect(await TaskEither<int, int>.left(0).orNull(), isNull);
  });
}
