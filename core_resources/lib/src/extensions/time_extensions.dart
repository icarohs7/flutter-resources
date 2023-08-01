import 'package:intl/intl.dart';

extension TimeExtensions on DateTime {
  ///Convert the given DateTime object to
  ///string using the given [format]
  ///and [locale]
  String string([String? format, String? locale]) => DateFormat(format, locale).format(this);

  /// How much time was elapsed from the given
  /// [DateTime] until now
  String timeDifferenceFromNow() {
    final age = DateTime.now().difference(this);
    final ageMinutes = age.inMinutes;
    final ageHours = age.inHours;
    final ageDays = age.inDays;
    return ageMinutes < 1
        ? 'Há menos de 1 minuto'
        : ageHours < 1
            ? 'Há $ageMinutes minuto${ageMinutes > 1 ? 's' : ''}'
            : ageDays < 1
                ? 'Há $ageHours hora${ageHours > 1 ? 's' : ''}'
                : 'Há $ageDays dia${ageDays > 1 ? 's' : ''}';
  }

  /// Convert the given DateTime object to
  /// string using the format yyyy-MM-dd HH:mm:ss
  String toAmericanStdString() => string('yyyy-MM-dd HH:mm:ss');

  ///Modify the value of the given DateTime object
  DateTime update({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
