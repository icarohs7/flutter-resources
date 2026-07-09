import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'mocks.dart';

void main() {
  group('constructors', () {
    test('right / left / of / fromEither', () async {
      expect(await TaskEither.of(1).run(), right<Never, int>(1));
      expect(await TaskEither.right(1).run(), right<Never, int>(1));
      expect(await TaskEither.left('e').run(), left<String, Never>('e'));
      expect(await TaskEither.fromEither(right<String, int>(2)).run(), right(2));
    });

    test('tryCatch', () async {
      expect(
        await TaskEither.tryCatch(() async => 10, (_, __) => 'err').run(),
        right<String, int>(10),
      );
      expect(
        await TaskEither.tryCatch(() async => throw StateError('x'), (e, _) => '$e').run(),
        left<String, int>('Bad state: x'),
      );
    });

    test('toTaskEither', () async {
      expect(await right<String, int>(1).toTaskEither().run(), right(1));
      expect(await left<String, int>('e').toTaskEither().run(), left('e'));
    });
  });

  group('map / flatMap / chainEither', () {
    test('map and mapLeft', () async {
      expect(await TaskEither.right(2).map((n) => n * 3).run(), right<Never, int>(6));
      expect(
        await TaskEither<String, int>.left('e').map((n) => n * 3).run(),
        left('e'),
      );
      expect(
        await TaskEither<String, int>.left('e').mapLeft((l) => '$l!').run(),
        left('e!'),
      );
      expect(
        await TaskEither<String, int>.right(2).mapLeft((l) => '$l!').run(),
        right(2),
      );
    });

    test('flatMap short-circuits on left', () async {
      var ran = false;
      final result = await TaskEither<String, int>.left('e').flatMap((n) {
        ran = true;
        return TaskEither.right(n + 1);
      }).run();
      expect(result, left('e'));
      expect(ran, isFalse);
    });

    test('flatMap chains right', () async {
      expect(
        await TaskEither<String, int>.right(2).flatMap((n) => TaskEither.right(n + 1)).run(),
        right(3),
      );
      expect(
        await TaskEither<String, int>.right(2).flatMap((_) => TaskEither.left('no')).run(),
        left('no'),
      );
    });

    test('andThen / chainEither', () async {
      expect(
        await TaskEither<String, int>.right(1).andThen(() => TaskEither.right('ok')).run(),
        right('ok'),
      );
      expect(
        await TaskEither<String, int>.right(2).chainEither((n) => right(n * 2)).run(),
        right(4),
      );
      expect(
        await TaskEither<String, int>.right(2).chainEither((_) => left('no')).run(),
        left('no'),
      );
    });
  });

  group('chainFirst', () {
    test('keeps original right when chain succeeds', () async {
      final effects = <int>[];
      final result = await TaskEither<String, int>.right(5).chainFirst((n) {
        effects.add(n);
        return TaskEither.right(unit);
      }).run();
      expect(result, right(5));
      expect(effects, [5]);
    });

    test('swallows chained left and still yields original right', () async {
      final effects = <String>[];
      final result = await TaskEither<String, int>.right(5).chainFirst((_) {
        effects.add('ran');
        return TaskEither<String, Unit>.left('ignored');
      }).run();
      expect(result, right(5));
      expect(effects, ['ran']);
    });

    test('does not run chain when outer is left', () async {
      var ran = false;
      final result = await TaskEither<String, int>.left('outer').chainFirst((_) {
        ran = true;
        return TaskEither.right(unit);
      }).run();
      expect(result, left('outer'));
      expect(ran, isFalse);
    });
  });

  group('orElse / getOrElse / match', () {
    test('orElse replaces left', () async {
      expect(
        await TaskEither<String, int>.left('e').orElse((l) => TaskEither.right(l.length)).run(),
        right(1),
      );
      expect(
        await TaskEither<String, int>.right(9).orElse((_) => TaskEither.right(0)).run(),
        right(9),
      );
    });

    test('getOrElse returns Task of value', () async {
      expect(await TaskEither<String, int>.right(3).getOrElse((_) => -1).run(), 3);
      expect(await TaskEither<String, int>.left('err').getOrElse((l) => l.length).run(), 3);
    });

    test('match returns Task', () async {
      expect(
        await TaskEither<String, int>.right(3).match((_) => 'L', (r) => 'R$r').run(),
        'R3',
      );
      expect(
        await TaskEither<String, int>.left('e').match((l) => 'L$l', (_) => 'R').run(),
        'Le',
      );
    });
  });

  group('sequence / traverse', () {
    test('sequenceListSeq runs every task then fails on first left', () async {
      final order = <int>[];
      final tasks = [
        TaskEither(() async {
          order.add(1);
          return right<String, int>(1);
        }),
        TaskEither(() async {
          order.add(2);
          return left<String, int>('fail');
        }),
        TaskEither(() async {
          order.add(3);
          return right<String, int>(3);
        }),
      ];

      final result = await TaskEither.sequenceListSeq(tasks).run();
      expect(result, left('fail'));
      expect(order, [1, 2, 3], reason: 'seq still runs all effects (fpdart semantics)');
    });

    test('sequenceListSeq collects all rights', () async {
      final result = await TaskEither.sequenceListSeq([
        TaskEither<String, int>.right(1),
        TaskEither.right(2),
        TaskEither.right(3),
      ]).run();
      expect(result.toNullable(), [1, 2, 3]);
    });

    test('traverseListSeq maps then sequences', () async {
      final ok = await TaskEither.traverseListSeq(
        [1, 2, 3],
        (n) => TaskEither<String, int>.right(n * 2),
      ).run();
      expect(ok.toNullable(), [2, 4, 6]);

      final fail = await TaskEither.traverseListSeq(
        [1, 2, 3],
        (n) => n == 2 ? TaskEither<String, int>.left('bad') : TaskEither.right(n),
      ).run();
      expect(fail.leftOrNull(), 'bad');
    });

    test('sequenceList (parallel) preserves order', () async {
      final result = await TaskEither.sequenceList([
        TaskEither(() async {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return right<String, int>(1);
        }),
        TaskEither(() async => right(2)),
        TaskEither(() async => right(3)),
      ]).run();
      expect(result.toNullable(), [1, 2, 3]);
    });
  });
}
