import 'package:dio/dio.dart';

///Create default dio instance
///for flutter
Dio defaultFlutterDio(
  String baseUrl, {
  int? connectTimeout = 30 * 1000,
  int? receiveTimeout = 30 * 1000,
  int? sendTimeout = 30 * 1000,
  ResponseType? responseType = ResponseType.plain,
  Map<String, String> headers = const {'Accept': 'application/json'},
  bool receiveDataWhenStatusError = true,
}) {
  return Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
    sendTimeout: sendTimeout,
    responseType: responseType,
    headers: headers,
    receiveDataWhenStatusError: receiveDataWhenStatusError,
  ));
}
