import 'package:core_resources/core_resources.dart';

extension TimeExtensions on DateTime {
  ///Convert the given DateTime object to
  ///string using the given [format]
  ///and [locale]
  String string([String format, String locale]) => DateFormat(format, locale).format(this);
}
