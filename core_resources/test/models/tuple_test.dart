import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Tuple2', () {
    final tuple = Tuple2(1, 2);
    expect(tuple.value1, 1);
    expect(tuple.value2, 2);

    final tuple2 = tuple.copyWith(value1: 3);
    expect(tuple2.value1, 3);
    expect(tuple2.value2, 2);

    final tuple3 = tuple2.copyWith(value2: 4);
    expect(tuple3.value1, 3);
    expect(tuple3.value2, 4);
    expect(tuple3, isNot(equals(tuple)));
    expect(tuple3, isNot(equals(tuple2)));
    expect(tuple3.toJson(), {'value1': 3, 'value2': 4});

    final tuple4 = Tuple2.fromJson(tuple3.toJson());
    expect(tuple4, equals(tuple3));
    expect(tuple4.hashCode, equals(tuple3.hashCode));
    expect(tuple4.hashCode, isNot(equals(tuple2.hashCode)));
    expect(tuple4.toString(), equals('Tuple2(value1: 3, value2: 4)'));
  });
}
