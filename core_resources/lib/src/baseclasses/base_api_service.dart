import 'package:http/http.dart' as http;

import '../../core_resources.dart';

class _EmptyBaseApiService with BaseApiService {}

mixin BaseApiService {
  static BaseApiService create() => _EmptyBaseApiService();

  Dio get dio => Core.get();

  String? getJsonErrorIfAny(
    Map<String, dynamic>? json, {
    String messageWhenBlankError = 'Erro ao realizar requisição',
  }) {
    return dio.getJsonErrorIfAny(json, messageWhenBlankError: messageWhenBlankError);
  }

  Try<T> tryJsonOrErrorT<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) mapper, {
    String messageOnError = 'Erro ao realizar requisição',
  }) {
    return dio.tryJsonOrErrorT(json, mapper, messageOnError: messageOnError);
  }

  void throwJsonErrorIfAny(Map<String, dynamic> json) {
    dio.throwJsonErrorIfAny(json);
  }

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

  Future<List<int>?> getBytes(
    String url, {
    required Map<String, dynamic> queryParameters,
    Options? options,
  }) {
    return dio.getBytes(url, queryParameters: queryParameters, options: options);
  }

  Future<http.StreamedResponse> postMultipart(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) {
    return dio.postMultipart(url, headers: headers, fields: fields, files: files);
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

  Future<http.MultipartFile?> resizedImageMultipart(
    String field, {
    required String imagePath,
    int imageWidth = 800,
  }) {
    return dio.resizedImageMultipart(field, imagePath: imagePath, imageWidth: imageWidth);
  }
}
