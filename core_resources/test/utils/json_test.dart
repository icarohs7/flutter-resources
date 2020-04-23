import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should decode json object', () async {
    const json = '''
    {
      "name": "test",
      "items": [1, 2, 3]
    }
    ''';
    final obj = await jsonDecodeObj(json);
    expect(obj['name'], equals('test'));
    expect(obj['items'], equals([1, 2, 3]));
    expect(
      obj,
      equals({
        'name': 'test',
        'items': [1, 2, 3],
      }),
    );
  });

  test('should decode json array', () async {
    const json = '["omai", "wa", "mou", "shindeiru", 42]';
    final arr = await jsonDecodeArray(json);
    expect(arr[0], equals('omai'));
    expect(arr[1], equals('wa'));
    expect(arr[2], equals('mou'));
    expect(arr[3], equals('shindeiru'));
    expect(arr[4], equals(42));
    expect(arr, equals(['omai', 'wa', 'mou', 'shindeiru', 42]));
  });
}
