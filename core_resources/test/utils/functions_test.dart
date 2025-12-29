import 'package:flutter_test/flutter_test.dart';
import 'package:core_resources/core_resources.dart';

void main() {
  test('identityString', () {
    const f1 = '';
    expect(identityString(f1), '');

    const f2 = 'test string';
    expect(identityString(f2), 'test string');

    const f3 = 'Hello World!';
    expect(identityString(f3), 'Hello World!');

    const int? f4 = null;
    expect(identityString(f4), 'null');

    const f5 = 1532;
    expect(identityString(f5), '1532');
  });
}
