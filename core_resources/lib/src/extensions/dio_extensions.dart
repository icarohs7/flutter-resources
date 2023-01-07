import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;

import '../../core_resources.dart';

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
      data: rawData ?? await compute(_encodeObj, data),
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
      data: rawData ?? await compute(_encodeObj, data),
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

  /// Returns the given image located at [imagePath] as a [http.MultipartFile]
  /// resized to the given [imageWidth]
  Future<http.MultipartFile?> resizedImageMultipart(
    String field, {
    required String imagePath,
    int imageWidth = 800,
  }) async {
    final file = File(imagePath);
    final contentType = mime(file.uri.toString());
    if (contentType == null) return null;
    final resized = await compute(_resizeImage, Tuple2(file, imageWidth));
    if (resized == null) return null;

    final isJpg = contentType == 'image/jpeg' || contentType == 'image/jpg';
    final isGif = contentType == 'image/gif';
    final isIco = contentType == 'image/x-icon';

    return http.MultipartFile.fromBytes(
      field,
      isJpg
          ? img.encodeJpg(resized)
          : isGif
              ? img.encodeGif(resized)
              : isIco
                  ? img.encodeIco(resized)
                  : img.encodePng(resized),
      filename: path.basename(file.path),
      contentType: MediaType.parse(contentType),
    );
  }
}

dynamic _encodeObj(dynamic obj) => jsonDecode(jsonEncode(obj));

img.Image? _resizeImage(Tuple2<File, int> args) {
  final file = args.value1;
  final widthThreshold = args.value2;
  final image = img.decodeImage(file.readAsBytesSync());
  if (image == null) return null;
  return image.width <= widthThreshold ? image : img.copyResize(image, width: widthThreshold);
}
