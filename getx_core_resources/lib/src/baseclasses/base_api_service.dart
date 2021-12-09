import 'dart:convert';
import 'dart:io';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;
import 'package:rest_resources/rest_resources.dart';

class _EmptyBaseApiService with BaseApiService {}

mixin BaseApiService {
  static BaseApiService create() => _EmptyBaseApiService();

  Dio get dio => Get.find();

  String? getJsonErrorIfAny(
    Map<String, dynamic> json, {
    String messageWhenBlankError = 'Erro ao realizar requisição',
  }) {
    return _extractErrorOrNullFromJson(json, messageWhenBlankError: messageWhenBlankError);
  }

  Try<T> tryJsonOrErrorT<T>(Map<String, dynamic> json,
      T mapper(Map<String, dynamic> json), {
        String messageOnError = 'Erro ao realizar requisição',
      }) {
    return Try(
          () => mapper(json),
      messageOnError:
      getJsonErrorIfAny(json, messageWhenBlankError: messageOnError) ?? messageOnError,
    );
  }

  void throwJsonErrorIfAny(Map<String, dynamic> json) {
    final error = _extractErrorOrNullFromJson(json);
    if (error == null) return;
    if (error.isBlank) throw Exception('Unknown error on API call');
    throw Exception(error);
  }

  String? _extractErrorOrNullFromJson(Map<String, dynamic> json, {
    String? messageWhenBlankError,
  }) {
    final error = json['error'] ?? json['erro'];
    final errors = json['errors'];
    final retorno = json['retorno'];
    final status = json['status'];
    final success = json['sucesso'] ?? json['success'];
    final message = json['mensagem'] ?? json['message'];
    final code = json['code'] ?? runCatching(() => json['data']['status']);
    final statusMessage = (status != null && status is String)
        ? !status.isNumericOnly
        ? status
        : null
        : null;
    final retornoMessage = (retorno != null && retorno is String)
        ? !retorno.isNumericOnly
        ? retorno
        : null
        : null;

    final errorInvalid = error != null && '$error'.isNotBlank;
    final returnInvalid =
        (retorno == 0 || retorno == '0') && status != null && '$status'.isNotBlank;
    final successInvalid = success == false || success == 0 || success == '0';
    final codeInvalid =
        code != null && (code is int || code is String) && code != 200 && code != '200';
    final statusAsCodeInvalid = status is int && status >= 400;

    final hasError =
        errorInvalid || returnInvalid || successInvalid || codeInvalid || statusAsCodeInvalid;

    if (errors != null) {
      final message = runCatching(() {
        final Map<String, dynamic> errors = json['errors'];
        final List messages = errors.values.first;
        final String message = messages.first;
        return message;
      });
      return message ?? messageWhenBlankError;
    }

    if (hasError) {
      return error ?? statusMessage ?? message ?? retornoMessage ?? messageWhenBlankError;
    }

    return null;
  }

  Future<Response<T>> get<T>(String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Map<String, dynamic>> getRJsonObj(String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await get<String>(url, queryParameters: queryParameters, options: options);
    return jsonDecodeObj(response.data ?? '');
  }

  Future<List> getRJsonArray(String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await get<String>(url, queryParameters: queryParameters, options: options);
    return jsonDecodeArray(response.data ?? '');
  }

  Future<List<int>?> getBytes(String url, {
    required Map<String, dynamic> queryParameters,
    Options? options,
  }) async {
    final response = await get<List<int>>(
      url,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(responseType: ResponseType.bytes),
    );
    return response.data;
  }

  Future<http.StreamedResponse> postMultipart(String url, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      ...?headers,
      'Accept': 'application/json',
    });

    request.fields.addAll({
      ...?fields,
    });

    request.files.addAll([
      ...?files,
    ]);

    return request.send();
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Response<T>> post<T>(String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(
      url,
      data: rawData ?? await compute(_encodeObj, data),
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Map<String, dynamic>> postRJsonObj(String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String Function(String)? responseInterceptor,
  }) async {
    final response = await post<String>(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
    return jsonDecodeObj(responseInterceptor?.call(response.data ?? '') ?? response.data ?? '');
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<List> postRJsonArray(String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await post<String>(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
    return jsonDecodeArray(response.data ?? '');
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Response<T>> put<T>(String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.put(
      url,
      data: rawData ?? await compute(_encodeObj, data),
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// [data] - will be sent encoded to the server
  /// [rawData] - will be sent as is to the server
  Future<Map<String, dynamic>> putRJsonObj(String url, {
    dynamic data,
    dynamic rawData,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await put<String>(
      url,
      data: data,
      rawData: rawData,
      queryParameters: queryParameters,
      options: options,
    );
    return jsonDecodeObj(response.data ?? '');
  }

  Future<http.MultipartFile?> resizedImageMultipart(String field, {
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

extension ResponseExtensions on Response<String> {
  Future<List> toJsonArray() => jsonDecodeArray(data ?? '');

  Future<Map<String, dynamic>> toJsonObject() => jsonDecodeObj(data ?? '');
}

img.Image? _resizeImage(Tuple2<File, int> args) {
  final file = args.value1;
  final widthThreshold = args.value2;
  final image = img.decodeImage(file.readAsBytesSync());
  if (image == null) return null;
  return image.width <= widthThreshold ? image : img.copyResize(image, width: widthThreshold);
}
