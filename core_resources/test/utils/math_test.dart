import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should convert degrees to radians and vice-versa", () {
    expect(degToRad(171.887), moreOrLessEquals(3.0, epsilon: 0.001));
    expect(degToRad(229.183), moreOrLessEquals(4.0, epsilon: 0.001));

    expect(radToDeg(3.0), moreOrLessEquals(171.887, epsilon: 0.001));
    expect(radToDeg(4.0), moreOrLessEquals(229.183, epsilon: 0.001));
  });
}
