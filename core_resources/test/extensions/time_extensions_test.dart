import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert DateTime to string', () {
    final dt = DateTime(2020, 5, 9, 12);

    expect(dt.string('yyyy-MM-dd'), equals('2020-05-09'));
    expect(dt.string('yyyy-MM-dd HH:mm'), equals('2020-05-09 12:00'));
    expect(dt.string('yyyy-MM-dd HH:mm:ss'), equals('2020-05-09 12:00:00'));
  });
}
