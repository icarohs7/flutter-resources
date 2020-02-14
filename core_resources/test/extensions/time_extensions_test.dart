import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert DateTime to string', () {
    final dt = DateTime(2020, 5, 9, 12);

    expect(dt.string('yyyy-MM-dd'), equals('2020-05-09'));
    expect(dt.string('yyyy-MM-dd HH:mm'), equals('2020-05-09 12:00'));
    expect(dt.string('yyyy-MM-dd HH:mm:ss'), equals('2020-05-09 12:00:00'));
  });

  test('should change values on DateTime', () {
    final dtex = DateTime.parse('2020-01-01 12:00');
    expect(dtex.year, equals(2020));
    expect(dtex.month, equals(1));
    expect(dtex.day, equals(1));
    expect(dtex.hour, equals(12));
    expect(dtex.minute, equals(0));
    expect(dtex.second, equals(0));

    final dt1 = dtex.update(hour: 14);
    expect(dt1.year, equals(2020));
    expect(dt1.month, equals(1));
    expect(dt1.day, equals(1));
    expect(dt1.hour, equals(14));
    expect(dt1.minute, equals(0));
    expect(dt1.second, equals(0));

    final dt2 = dtex.update(hour: 15, minute: 30);
    expect(dt2.year, equals(2020));
    expect(dt2.month, equals(1));
    expect(dt2.day, equals(1));
    expect(dt2.hour, equals(15));
    expect(dt2.minute, equals(30));
    expect(dt2.second, equals(0));
  });
}
