import 'package:dio/dio.dart';

import '../core.dart';
import '../extensions/dio_extensions.dart';

class _EmptyBaseApiService with BaseApiService {}

mixin BaseApiService {
  static BaseApiService create() => _EmptyBaseApiService();

  Dio get dio => Core.get();

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.get(url, queryParameters: queryParameters, options: options);
  }

  Future<Map<String, dynamic>> getRJsonObj(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.getRJsonObj(url, queryParameters: queryParameters, options: options);
  }

  Future<List> getRJsonArray(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.getRJsonArray(url, queryParameters: queryParameters, options: options);
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.crPost(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Map<String, dynamic>> postRJsonObj(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String Function(String)? responseInterceptor,
  }) {
    return dio.postRJsonObj(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
      responseInterceptor: responseInterceptor,
    );
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<List> postRJsonArray(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.postRJsonArray(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Map<String, dynamic>> putRJsonObj(
    String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String Function(String)? responseInterceptor,
  }) {
    return dio.putRJsonObj(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
      responseInterceptor: responseInterceptor,
    );
  }
}
