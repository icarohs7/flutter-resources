import '../extensions/string_extensions.dart';

class CommonIntents {
  static Uri locationOnMaps({
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

  static Uri openDialer({required String phone}) => 'tel:$phone'.toUri();

  static Uri sendWhatsappMessage(String phone, {String? message}) {
    return Uri.https(
      'wa.me',
      '/$phone',
      message != null ? {'text': message} : null,
    );
  }
}
