import 'package:core_resources/src/utils/ui.dart';
import 'package:flutter/material.dart';

class Splash<T> extends StatefulWidget {
  const Splash({
    Key key,
    @required this.future,
    @required this.child,
    @required this.onComplete,
  }) : super(key: key);

  final Future<T> future;
  final Widget child;
  final void Function(BuildContext context, T value) onComplete;

  @override
  _SplashState createState() => _SplashState<T>(onComplete);
}

class _SplashState<T> extends State<Splash<T>> {
  _SplashState(this.onComplete);

  final void Function(BuildContext context, T value) onComplete;

  @override
  void initState() {
    super.initState();
    hideSystemOverlays();
    widget.future.catchError((e) => null).then((result) async {
      await showSystemOverlays();
      onComplete(context, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
