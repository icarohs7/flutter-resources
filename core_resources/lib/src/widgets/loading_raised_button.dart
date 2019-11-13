import 'package:flutter/material.dart';

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
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: _isLoading
          ? Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : widget.child,
      onPressed: _isLoading
          ? null
          : () async {
              _isLoading = true;
              try {
                await widget.onPressed();
              } finally {
                _isLoading = false;
              }
            },
    );
  }
}
