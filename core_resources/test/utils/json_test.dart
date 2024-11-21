import 'dart:convert';

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

  test('should decode byte array', () async {
    final obj1 = {
      'name': 'test',
      'items': [1, 2, 3],
    };
    final obj1bytes = utf8.encode(jsonEncode(obj1));
    expect(await jsonDecodeBytesBg(obj1bytes), equals(obj1));

    final obj2 = {
      'name': 'Hello',
      'items': [1, 2, 3],
      'people': {
        'Jhon': {
          'age': 27,
        },
      },
    };
    final obj2bytes = utf8.encode(jsonEncode(obj2));
    expect(await jsonDecodeBytesBg(obj2bytes), equals(obj2));
  });

  test('should encode json object', () async {
    final obj1 = {
      'name': 'test',
      'items': [1, 2, 3],
    };
    const exJson1 = '{"name":"test","items":[1,2,3]}';
    expect(await jsonEncodeBg(obj1), equals(exJson1));

    final obj2 = ['omai', 'wa', 'mou', 'shindeiru', 42];
    const exJson2 = '["omai","wa","mou","shindeiru",42]';
    expect(await jsonEncodeBg(obj2), equals(exJson2));
  });
}
