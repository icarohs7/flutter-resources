import 'package:html_unescape/html_unescape.dart';

final _htmlUnescape = HtmlUnescape();

extension CR2StringEx on String {
  String get htmlUnescaped => _htmlUnescape.convert(this);
}
