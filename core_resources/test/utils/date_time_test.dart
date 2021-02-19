import 'package:core_resources/src/utils/date_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert duration string to duration instance', () {
    final d1 = parseDuration('2:3:4');
    final d2 = parseDuration('02:03:04');

    expect(d1, equals(d2));
    expect(d1.inHours, equals(2));
    expect(d1.inMinutes, equals(123));
    expect(d1.inSeconds, equals(7384));

    final d3 = parseDuration('03:04');
    expect(d3.inHours, equals(3));
    expect(d3.inMinutes, equals(184));

    expect(() => parseDuration('03H'), throwsA(isA<FormatException>()));
  });
}
