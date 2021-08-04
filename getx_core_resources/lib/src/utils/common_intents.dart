import 'package:flutter/foundation.dart';

// ignore: non_constant_identifier_names
final CommonIntents = _CommonIntents();

class _CommonIntents {
  String locationOnMaps({
    required double latitude,
    required double longitude,
  }) {
    const scheme = 'https://www.google.com/maps/search/?api=1';
    final latLng = 'query=$latitude,$longitude';
    return '$scheme&$latLng';
  }

  String openDialer({required String phone}) => 'tel:$phone';

  String sendWhatsappMessage(String phone, {String? message}) {
    if (kIsWeb) {
      return 'https://api.whatsapp.com/send?phone=$phone'
          '${message != null ? '&text=$message' : ''}';
    } else {
      return Uri(
        scheme: 'whatsapp',
        host: 'send',
        queryParameters: {
          'phone': phone,
          if (message != null) 'text': message,
        },
      ).toString();
    }
  }
}
