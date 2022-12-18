// ignore_for_file: non_constant_identifier_names

import 'package:core_resources/src/extensions/string_extensions.dart';

final CommonIntents = _CommonIntents();

class _CommonIntents {
  Uri locationOnMaps({
    required double latitude,
    required double longitude,
  }) {
    return Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': '$latitude,$longitude',
      },
    );
  }

  Uri openDialer({required String phone}) => 'tel:$phone'.toUri();

  Uri sendWhatsappMessage(String phone, {String? message}) {
    return Uri.https(
      'wa.me',
      '/$phone',
      message != null ? {'text': message} : null,
    );
  }
}
