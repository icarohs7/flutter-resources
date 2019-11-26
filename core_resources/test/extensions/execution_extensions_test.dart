import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should run code catching exceptions", () {
    final r1 = runCatching<int>(() => throw FormatException());
    expect(r1, null);

    final r2 = runCatching<int>(() => 1532);
    expect(r2, 1532);

    final r3 = runCatching<String>(() => throw FormatException());
    expect(r3, null);

    final r4 = runCatching<String>(() => "Omai wa mou shindeiru!");
    expect(r4, "Omai wa mou shindeiru!");
  });

  test("should measure execution time", () async {
    final time = measureTimeMillis(() async {
      return 1532;
    });
    expect(await time.value, 1532);
    expect(time.milliseconds.toDouble(), moreOrLessEquals(1, epsilon: 4));
  });
}
