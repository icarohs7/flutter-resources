import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:triple_fp_resources/src/fp_do_expression.dart';

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
    expect(result.fold(id, id), 30);
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
    expect(result.fold(id, id), MockFailure('Failed'));
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
    expect(result.fold(id, id), MockFailure('Failed'));
  });
}
