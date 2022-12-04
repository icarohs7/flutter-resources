import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should invoke function', () {
    expect(invoke(() => 1532), equals(1532));
    expect(invoke(() => 'Hello'), equals('Hello'));
    expect(invoke(() => 'Hello ' 'World'), equals('Hello World'));
    expect(invoke(() => 42000 + 69), equals(42069));
  });
}
