import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'mocks.dart';

void main() {
  group('constructors', () {
    test('right / left / of / factories', () {
      expect(right<String, int>(1), Either.right(1));
      expect(left<String, int>('e'), Either.left('e'));
      expect(Either.of(1), right<Never, int>(1));
    });

    test('fromNullable', () {
      expect(Either.fromNullable(1, () => 'null'), right<String, int>(1));
      expect(Either.fromNullable(null, () => 'null'), left<String, int>('null'));
    });

    test('tryCatch', () {
      expect(Either.tryCatch(() => 10, (_, __) => 'err'), right<String, int>(10));
      expect(
        Either.tryCatch(() => throw StateError('x'), (e, _) => e.toString()),
        left<String, int>('Bad state: x'),
      );
    });
  });

  group('Right', () {
    final either = right<String, int>(2);

    test('map / mapLeft / flatMap / andThen', () {
      expect(either.map((n) => n * 3), right<String, int>(6));
      expect(either.mapLeft((l) => '$l!'), right<String, int>(2));
      expect(either.flatMap((n) => right(n + 1)), right<String, int>(3));
      expect(either.flatMap((_) => left<String, int>('no')), left('no'));
      expect(either.andThen(() => right('ok')), right<String, String>('ok'));
    });

    test('match / fold / getOrElse', () {
      expect(either.match((_) => -1, (r) => r), 2);
      expect(either.fold((_) => -1, (r) => r), 2);
      expect(either.getOrElse((_) => -1), 2);
    });

    test('toNullable / leftOrNull / isLeft / isRight', () {
      expect(either.toNullable(), 2);
      expect(either.leftOrNull(), isNull);
      expect(either.isLeft(), isFalse);
      expect(either.isRight(), isTrue);
    });
  });

  group('Left', () {
    final either = left<String, int>('err');

    test('map / mapLeft / flatMap / andThen', () {
      expect(either.map((n) => n * 3), left<String, int>('err'));
      expect(either.mapLeft((l) => '$l!'), left<String, int>('err!'));
      expect(either.flatMap((n) => right(n + 1)), left<String, int>('err'));
      expect(either.andThen(() => right('ok')), left<String, String>('err'));
    });

    test('match / fold / getOrElse', () {
      expect(either.match((l) => l.length, (_) => -1), 3);
      expect(either.fold((l) => l.length, (_) => -1), 3);
      expect(either.getOrElse((l) => l.length), 3);
    });

    test('toNullable / leftOrNull / isLeft / isRight', () {
      expect(either.toNullable(), isNull);
      expect(either.leftOrNull(), 'err');
      expect(either.isLeft(), isTrue);
      expect(either.isRight(), isFalse);
    });
  });

  group('sequenceList / traverseList', () {
    test('sequenceList collects rights and short-circuits on first left', () {
      expect(
        Either.sequenceList([right<String, int>(1), right(2), right(3)]).toNullable(),
        [1, 2, 3],
      );
      expect(
        Either.sequenceList([
          right<String, int>(1),
          left('fail'),
          right(3),
        ]).leftOrNull(),
        'fail',
      );
    });

    test('traverseList maps then sequences', () {
      expect(
        Either.traverseList([1, 2, 3], (n) => right<String, int>(n * 2)).toNullable(),
        [2, 4, 6],
      );
      expect(
        Either.traverseList([1, 2, 3], (n) => n == 2 ? left('bad') : right(n)).leftOrNull(),
        'bad',
      );
    });
  });

  group('equality', () {
    test('Right / Left compare by value', () {
      expect(right<String, int>(1), right<String, int>(1));
      expect(left<String, int>('a'), left<String, int>('a'));
      expect(right<String, int>(1), isNot(right<String, int>(2)));
      expect(left<String, int>('a'), isNot(right<String, int>(1)));
      expect(MockFailure('x'), MockFailure('x'));
      expect(left(MockFailure('x')), left(MockFailure('x')));
    });
  });
}
