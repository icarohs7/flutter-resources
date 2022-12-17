import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  final objects = <Type, dynamic>{Dio: defaultFlutterDio('https://example.com')};
  Core.setLocator(<T extends Object>() => objects[T]);
  final dio = Core.get<Dio>();
  final dioAdapter = DioAdapter(dio: dio);

  test('baseUrl', () {
    expect(dio.baseUrl, 'https://example.com');
  });

  dioAdapter
    ..onGet(
      '/object',
      (server) => server.reply(200, {'path': 'object'}),
    )
    ..onGet(
      '/array',
      (server) => server.reply(200, ['object']),
    )
    ..onGet(
      '/bytes',
      (server) => server.reply(200, [0, 0, 1, 1, 0, 0, 1, 1]),
    )
    ..onPost(
      '/object',
      (server) => server.reply(200, {'path': 'object'}),
    )
    ..onPost(
      '/object',
      data: 'data',
      (server) => server.reply(200, {'path': 'objectData'}),
    )
    ..onPost(
      '/map',
      data: {'key': 'value'},
      (server) => server.reply(200, {'path': 'mapData'}),
    )
    ..onPost(
      '/array',
      (server) => server.reply(200, ['object']),
    )
    ..onPost(
      '/array',
      data: 'data',
      (server) => server.reply(200, ['objectData']),
    );

  test('getRJsonObj', () async {
    final response = await dio.getRJsonObj('/object');
    expect(response, {'path': 'object'});
  });

  test('getRJsonArray', () async {
    final response = await dio.getRJsonArray('/array');
    expect(response, ['object']);
  });

  // test('getBytes', () async {
  //   final response = await dio.getBytes('/bytes');
  //   expect(response, [0, 0, 1, 1, 0, 0, 1, 1]);
  // });

  test('postRJsonObj', () async {
    final response = await dio.postRJsonObj('/object', rawData: 'data');
    expect(response, {'path': 'objectData'});
  });

  test('postRJsonObj with map', () async {
    final response = await dio.postRJsonObj('/map', data: {'key': 'value'});
    expect(response, {'path': 'mapData'});
  });

  test('postRJsonArray', () async {
    final response = await dio.postRJsonArray('/array', rawData: 'data');
    expect(response, ['objectData']);
  });
}
