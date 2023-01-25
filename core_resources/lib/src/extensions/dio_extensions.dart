import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';

import '../utils/json.dart';

extension CRDioExtensions on Dio {
  String get baseUrl => options.baseUrl;

  /// Returns the result of the get request to the given [url],
  /// parsed as a [Map<String, dynamic>].
  Future<Map<String, dynamic>> getRJsonObj(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await get<String>(url, queryParameters: queryParameters, options: options);
    return jsonDecodeObj(response.data ?? '');
  }

  /// Returns the result of the get request to the given [url],
  /// parsed as a [List<dynamic>].
  Future<List> getRJsonArray(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await get<String>(url, queryParameters: queryParameters, options: options);
    return jsonDecodeArray(response.data ?? '');
  }

  /// Performs a post request to the given [url]
  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Response<T>> crPost<T>(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await post(
      url,
      data: rawData ?? await Isolate.run(() => jsonDecode(jsonEncode(data))),
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Performs a post request to the given [url]
  /// parsing the response as a [Map<String, dynamic>]
  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Map<String, dynamic>> postRJsonObj(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String Function(String)? responseInterceptor,
  }) async {
    final response = await crPost<String>(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
    return jsonDecodeObj(responseInterceptor?.call(response.data ?? '') ?? response.data ?? '');
  }

  /// Performs a post request to the given [url]
  /// parsing the response as a [List<dynamic>]
  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<List> postRJsonArray(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await crPost<String>(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
    return jsonDecodeArray(response.data ?? '');
  }

  /// Performs a put request to the given [url]
  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Response<T>> crPut<T>(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await put(
      url,
      data: rawData ?? await Isolate.run(() => jsonDecode(jsonEncode(data))),
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Performs a put request to the given [url]
  /// parsing the response as a [Map<String, dynamic>]
  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Map<String, dynamic>> putRJsonObj(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String Function(String)? responseInterceptor,
  }) async {
    final response = await crPut<String>(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
    return jsonDecodeObj(responseInterceptor?.call(response.data ?? '') ?? response.data ?? '');
  }
}
