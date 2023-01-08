import 'package:flutter_test/flutter_test.dart';
import 'package:getx_resources/getx_resources.dart';

void main() {
  test('putSingleton', () {
    Get.putSingleton(1);
    expect(Get.find<int>(), 1);

    Get.putSingleton('Hello');
    expect(Get.find<String>(), 'Hello');
  });
}
