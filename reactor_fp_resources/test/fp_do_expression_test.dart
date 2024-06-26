import 'package:flutter_test/flutter_test.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'mocks.dart';

void main() {
  test('should evaluate a successful expression with do notation of TaskEither', () async {
    //act
    final result = await taskEitherDo(($, $$) async {
      final firstNumber = $(right(10));

      final secondNumber = await $$(TaskEither.right(20));

      return firstNumber + secondNumber;
    }).run();
    //assert
    expect(result, isA<Right>());
    expect(result.fold(identity, identity), 30);
  });

  test('do notation fails using Either', () async {
    //act
    final result = await taskEitherDo<MockFailure, int>(($, $$) async {
      final firstNumber = $(right(10));

      final secondNumber = $(left<MockFailure, int>(MockFailure('Failed')));

      return firstNumber + secondNumber;
    }).run();
    //assert
    expect(result, isA<Left>());
    expect(result.fold(identity, identity), MockFailure('Failed'));
  });

  test('do notation fails using TaskEither', () async {
    //act
    final result = await taskEitherDo<MockFailure, int>(($, $$) async {
      final firstNumber = $(right(10));

      final secondNumber = await $$(TaskEither<MockFailure, int>.left(MockFailure('Failed')));

      return firstNumber + secondNumber;
    }).run();
    //assert
    expect(result, isA<Left>());
    expect(result.fold(identity, identity), MockFailure('Failed'));
  });

  test('do notation running on separated isolate success', () async {
    //act
    final result = await taskEitherDoBg(($, $$) async {
      final firstNumber = $(right(10));

      final secondNumber = await $$(TaskEither.right(20));

      return firstNumber + secondNumber;
    }).run();
    //assert
    expect(result, isA<Right>());
    expect(result.fold(identity, identity), 30);
  });

  test('do notation running on separated isolate fails using Either', () async {
    //act
    final result = await taskEitherDoBg<MockFailure, int>(($, $$) async {
      final firstNumber = $(right(10));

      final secondNumber = $(left<MockFailure, int>(MockFailure('Failed')));

      return firstNumber + secondNumber;
    }).run();
    //assert
    expect(result, isA<Left>());
    expect(result.fold(identity, identity), MockFailure('Failed'));
  });

  test('do notation running on separated isolate fails using TaskEither', () async {
    //act
    final result = await taskEitherDoBg<MockFailure, int>(($, $$) async {
      final firstNumber = $(right(10));

      final secondNumber = await $$(TaskEither<MockFailure, int>.left(MockFailure('Failed')));

      return firstNumber + secondNumber;
    }).run();
    //assert
    expect(result, isA<Left>());
    expect(result.fold(identity, identity), MockFailure('Failed'));
  });
}
