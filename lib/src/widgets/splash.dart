import 'package:flutter/material.dart';

class Splash<T> extends StatefulWidget {
  final Future<T> future;
  final Widget child;
  final void Function(BuildContext context, T value) onComplete;

  Splash({
    Key key,
    @required this.future,
    @required this.child,
    @required this.onComplete,
  }) : super(key: key);

  @override
  _SplashState createState() => _SplashState<T>(onComplete);
}

class _SplashState<T> extends State<Splash<T>> {
  final void Function(BuildContext context, T value) onComplete;

  _SplashState(this.onComplete);

  @override
  void initState() {
    super.initState();
    widget.future.then((result) => onComplete(context, result));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
