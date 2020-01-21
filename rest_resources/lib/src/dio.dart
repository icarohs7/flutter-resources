import 'package:rest_resources/rest_resources.dart';

///Create default dio instance
///for flutter
Dio defaultFlutterDio(String baseUrl) {
  return Dio(BaseOptions(baseUrl: baseUrl))..transformer = FlutterTransformer();
}
