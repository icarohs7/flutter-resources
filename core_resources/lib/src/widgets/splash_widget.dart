import 'package:core_resources/src/utils/ui.dart';
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
    hideTopSystemOverlay();
    widget.future.catchError((e) => null).then((result) async {
      await showSystemOverlays();
      await widget.onComplete(context, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
