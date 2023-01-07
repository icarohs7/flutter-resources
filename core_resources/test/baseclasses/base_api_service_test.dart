import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final mockDio = MockDio();
  final service = MockApiService();
  Core.setLocator(<T extends Object>() => mockDio as T);

  setUp(() {
    reset(mockDio);
  });

  test('get', () async {
    final queryParameters = <String, dynamic>{'key': 'value'};
    final options = Options(headers: <String, dynamic>{'key': 'value'});
    final response = Response<String>(data: 'data', requestOptions: RequestOptions(path: 'path'));

    when(() => mockDio.get<String>('path', queryParameters: queryParameters, options: options))
        .thenAnswer((_) async => response);

    final r = await service.get<String>('path', queryParameters: queryParameters, options: options);
    expect(r, response);
    verify(() => mockDio.get<String>('path', queryParameters: queryParameters, options: options))
        .called(1);
  });

  test('getRJsonObj', () async {
    final queryParameters = <String, dynamic>{'key': 'value'};
    final options = Options(headers: <String, dynamic>{'key': 'value'});
    final response =
        Response<String>(data: '{"key":1}', requestOptions: RequestOptions(path: 'path'));

    when(() => mockDio.get<String>('path', queryParameters: queryParameters, options: options))
        .thenAnswer((_) async => response);

    final r = await service.getRJsonObj('path', queryParameters: queryParameters, options: options);
    expect(r, {'key': 1});
    verify(() => mockDio.get<String>('path', queryParameters: queryParameters, options: options))
        .called(1);
  });

  test('getRJsonArray', () async {
    final queryParameters = <String, dynamic>{'key': 'value'};
    final options = Options(headers: <String, dynamic>{'key': 'value'});
    final response = Response<String>(data: '[1]', requestOptions: RequestOptions(path: 'path'));

    when(() => mockDio.get<String>('path', queryParameters: queryParameters, options: options))
        .thenAnswer((_) async => response);

    final r =
        await service.getRJsonArray('path', queryParameters: queryParameters, options: options);
    expect(r, [1]);
    verify(() => mockDio.get<String>('path', queryParameters: queryParameters, options: options))
        .called(1);
  });

  test('post', () async {
    final data = <String, dynamic>{'key': 'value'};
    final rawData = <String, dynamic>{'key': 'value'};
    final queryParameters = <String, dynamic>{'key': 'value'};
    final options = Options(headers: <String, dynamic>{'key': 'value'});
    final response = Response<String>(data: 'data', requestOptions: RequestOptions(path: 'path'));

    when(() => mockDio.post<String>(
          'path',
          data: data,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r = await service.post<String>('path',
        data: data, queryParameters: queryParameters, options: options);
    expect(r, response);
    verify(() => mockDio.post<String>('path',
        data: data, queryParameters: queryParameters, options: options)).called(1);

    when(() => mockDio.post<String>(
          'path',
          data: rawData,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r2 = await service.post<String>('path',
        rawData: rawData, queryParameters: queryParameters, options: options);
    expect(r2, response);
    verify(() => mockDio.post<String>('path',
        data: rawData, queryParameters: queryParameters, options: options)).called(1);
  });

  test('postRJsonObj', () async {
    final data = <String, dynamic>{'key': 'value'};
    final rawData = <String, dynamic>{'key': 'value'};
    final queryParameters = <String, dynamic>{'key': 'value'};
    final options = Options(headers: <String, dynamic>{'key': 'value'});
    final response =
        Response<String>(data: '{"key": 1}', requestOptions: RequestOptions(path: 'path'));

    when(() => mockDio.post<String>(
          'path',
          data: data,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r = await service.postRJsonObj('path',
        data: data, queryParameters: queryParameters, options: options);
    expect(r, {'key': 1});
    verify(() => mockDio.post<String>('path',
        data: data, queryParameters: queryParameters, options: options)).called(1);

    when(() => mockDio.post<String>(
          'path',
          data: rawData,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r2 = await service.postRJsonObj('path',
        rawData: rawData, queryParameters: queryParameters, options: options);
    expect(r2, {'key': 1});
    verify(() => mockDio.post<String>('path',
        data: rawData, queryParameters: queryParameters, options: options)).called(1);
  });

  test('postRJsonArray', () async {
    final data = <String, dynamic>{'key': 'value'};
    final rawData = <String, dynamic>{'key': 'value'};
    final queryParameters = <String, dynamic>{'key': 'value'};
    final options = Options(headers: <String, dynamic>{'key': 'value'});
    final response = Response<String>(data: '[1]', requestOptions: RequestOptions(path: 'path'));

    when(() => mockDio.post<String>(
          'path',
          data: data,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r = await service.postRJsonArray('path',
        data: data, queryParameters: queryParameters, options: options);
    expect(r, [1]);
    verify(() => mockDio.post<String>('path',
        data: data, queryParameters: queryParameters, options: options)).called(1);

    when(() => mockDio.post<String>(
          'path',
          data: rawData,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r2 = await service.postRJsonArray('path',
        rawData: rawData, queryParameters: queryParameters, options: options);
    expect(r2, [1]);
    verify(() => mockDio.post<String>('path',
        data: rawData, queryParameters: queryParameters, options: options)).called(1);
  });

  test('put', () async {
    final data = <String, dynamic>{'key': 'value'};
    final rawData = <String, dynamic>{'key': 'value'};
    final queryParameters = <String, dynamic>{'key': 'value'};
    final options = Options(headers: <String, dynamic>{'key': 'value'});
    final response =
        Response<String>(data: '{"key":1}', requestOptions: RequestOptions(path: 'path'));

    when(() => mockDio.put<String>(
          'path',
          data: data,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r = await service.putRJsonObj('path',
        data: data, queryParameters: queryParameters, options: options);
    expect(r, {'key': 1});
    verify(() => mockDio.put<String>('path',
        data: data, queryParameters: queryParameters, options: options)).called(1);

    when(() => mockDio.put<String>(
          'path',
          data: rawData,
          queryParameters: queryParameters,
          options: options,
        )).thenAnswer((_) async => response);

    final r2 = await service.putRJsonObj('path',
        rawData: rawData, queryParameters: queryParameters, options: options);
    expect(r2, {'key': 1});
    verify(() => mockDio.put<String>('path',
        data: rawData, queryParameters: queryParameters, options: options)).called(1);
  });
}

class MockApiService with BaseApiService {}

class MockDio extends Mock implements Dio {}
