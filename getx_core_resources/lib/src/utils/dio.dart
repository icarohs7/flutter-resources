import 'package:dio/dio.dart';

///Create default dio instance
///for flutter
Dio defaultFlutterDio(String baseUrl) {
  int secondsToMilliseconds(int seconds) => seconds * 1000;
  return Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: secondsToMilliseconds(30),
    receiveTimeout: secondsToMilliseconds(30),
    sendTimeout: secondsToMilliseconds(30),
    responseType: ResponseType.plain,
    headers: {'Accept': 'application/json'},
    receiveDataWhenStatusError: true,
  ));
}
