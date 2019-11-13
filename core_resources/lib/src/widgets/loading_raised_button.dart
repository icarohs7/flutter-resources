import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingRaisedButton extends StatefulWidget {
  const LoadingRaisedButton({
    @required this.onPressed,
    this.child,
  });

  final Widget child;
  final Future<void> Function() onPressed;

  @override
  _LoadingRaisedButtonState createState() => _LoadingRaisedButtonState();
}

class _LoadingRaisedButtonState extends State<LoadingRaisedButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final button = _Button(
      onPressed: _isLoading
          ? null
          : () async {
              try {
                setState(() => _isLoading = true);
                await widget.onPressed();
              } finally {
                setState(() => _isLoading = false);
              }
            },
      child: _isLoading
          ? Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : widget.child,
    );

    return _isLoading ? GlowingProgressIndicator(child: button) : button;
  }
}

class _Button extends StatelessWidget {
  const _Button({
    @required this.onPressed,
    @required this.child,
  });

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
