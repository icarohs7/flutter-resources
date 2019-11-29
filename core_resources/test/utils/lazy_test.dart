import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should create lazy variable", () {
    var a = 0;
    final l = Lazy(() {
      a = 42;
      return 1532;
    });
    expect(a, 0);
    expect(l.v, 1532);
    expect(a, 42);
  });
}
