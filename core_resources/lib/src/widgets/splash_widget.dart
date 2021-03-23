import 'dart:async';
import 'dart:io';

import 'package:core_resources/src/utils/log.dart';
import 'package:core_resources/src/utils/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashWidget<T> extends StatefulWidget {
  const SplashWidget({
    Key key,
    @required this.future,
    @required this.child,
    @required this.onComplete,
  }) : super(key: key);

  final Future<T> future;
  final Widget child;
  final Future<void> Function(BuildContext context, T value) onComplete;

  @override
  _SplashWidgetState createState() => _SplashWidgetState<T>();
}

class _SplashWidgetState<T> extends State<SplashWidget<T>> {
  _SplashWidgetState();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) hideTopSystemOverlay();
    Future(() async {
      final result = await widget.future.catchError((e) {
        clog('Error on Splash loading:\n$e');
        return null;
      });
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) await showSystemOverlays();
      await widget.onComplete(context, result);
    }).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
