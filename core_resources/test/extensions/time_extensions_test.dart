import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert DateTime to string', () {
    final dt = DateTime(2020, 5, 9, 12);

    expect(dt.string('yyyy-MM-dd'), equals('2020-05-09'));
    expect(dt.string('yyyy-MM-dd HH:mm'), equals('2020-05-09 12:00'));
    expect(dt.string('yyyy-MM-dd HH:mm:ss'), equals('2020-05-09 12:00:00'));
  });

  test('should convert DateTime to string using american standard', () {
    final dt = DateTime(2020, 5, 9, 12, 0, 35);

    expect(dt.toAmericanStdString(), equals('2020-05-09 12:00:35'));
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

    final dt3 = dtex.update(
      year: 2022,
      month: 12,
      day: 31,
      hour: 23,
      minute: 59,
      second: 58,
      millisecond: 999,
      microsecond: 998,
    );
    expect(dt3.year, equals(2022));
    expect(dt3.month, equals(12));
    expect(dt3.day, equals(31));
    expect(dt3.hour, equals(23));
    expect(dt3.minute, equals(59));
    expect(dt3.second, equals(58));
    expect(dt3.millisecond, equals(999));
    expect(dt3.microsecond, equals(998));

    final dt4 = dtex.update(year: 2023);
    expect(dt4.year, equals(2023));
    expect(dt4.month, equals(1));
    expect(dt4.day, equals(1));
    expect(dt4.hour, equals(12));
    expect(dt4.minute, equals(0));
    expect(dt4.second, equals(0));
  });
}
