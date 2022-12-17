

// ignore: non_constant_identifier_names
final CommonIntents = _CommonIntents();

class _CommonIntents {
  String locationOnMaps({
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
    ).toString();
  }

  String openDialer({required String phone}) => 'tel:$phone';

  String sendWhatsappMessage(String phone, {String? message}) {
    return Uri.https(
      'wa.me',
      '/$phone',
      message != null ? {'text': message} : null,
    ).toString();
  }
}
