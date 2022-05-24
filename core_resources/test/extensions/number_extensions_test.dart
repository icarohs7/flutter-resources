import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should remove all non-number characters from string', () {
    expect('aa123321bb'.onlyNumbers(), '123321');
    expect('1a2b65c99d'.onlyNumbers(), '126599');
  });

  test('should extract digits as integer from string', () {
    expect('aa123321bb'.digits(), 123321);
    expect('1a2b65c99d'.digits(), 126599);
  });

  test('should convert double to currency representation', () {
    expect(15.32.asCurrency(), r'R$ 15,32');
    expect(1000.99.asCurrency(), r'R$ 1000,99');
  });

  test('should remove trailing zeros from double number', () {
    expect(15.32.toStringTrimmingDecimals(), '15.32');
    expect(15.3.toStringTrimmingDecimals(), '15.3');
    expect(15.392.toStringTrimmingDecimals(precision: 2), '15.39');
    expect(4.0.toStringTrimmingDecimals(precision: 2), '4');
    expect(4.2000000.toStringTrimmingDecimals(precision: 2), '4.2');
  });
}
