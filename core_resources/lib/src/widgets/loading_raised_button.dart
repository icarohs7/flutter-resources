import 'package:core_resources/core_resources.dart';
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
          ? Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.onSurface,
              highlightColor: Colors.white,
              child: widget.child,
            )
          : widget.child,
    );

    return button;
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
