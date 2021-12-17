import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlRender extends StatelessWidget {
  const HtmlRender({
    required this.data,
    this.style,
  });

  final String data;
  final Map<String, Style>? style;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Html(
        data: HtmlUnescape().convert(data),
        style: {...?style},
        onLinkTap: (url, context, attributes, element) {
          if (url != null) launch(url);
        },
      ),
    );
  }
}
