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
}
