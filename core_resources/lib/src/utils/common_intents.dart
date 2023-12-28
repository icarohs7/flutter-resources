import '../../core_resources.dart';

class CommonIntents {
  static Uri locationOnMaps({
    double? latitude,
    double? longitude,
    String? query,
  }) {
    return Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': [
          if (latitude != null && longitude != null) '$latitude,$longitude',
          if (query != null) query,
        ].joinToString(separator: ''),
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
