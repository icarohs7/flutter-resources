import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CommonIntents.locationOnMaps', () {
    expect(
      CommonIntents.locationOnMaps(latitude: 1.0, longitude: 2.0).toString(),
      'https://www.google.com/maps/search/?api=1&query=1.0%2C2.0',
    );
  });

  test('CommonIntents.openDialer', () {
    expect(
      CommonIntents.openDialer(phone: '1234567890').toString(),
      'tel:1234567890',
    );
  });

  test('CommonIntents.sendWhatsappMessage', () {
    expect(
      CommonIntents.sendWhatsappMessage('1234567890').toString(),
      'https://wa.me/1234567890',
    );
    expect(
      CommonIntents.sendWhatsappMessage('1234567890', message: 'Hello!').toString(),
      'https://wa.me/1234567890?text=Hello%21',
    );
  });
}
