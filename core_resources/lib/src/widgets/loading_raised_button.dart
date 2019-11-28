import 'package:flutter/material.dart';

class LoadingRaisedButton extends StatelessWidget {
  const LoadingRaisedButton({
    @required this.onPressed,
    this.child,
    this.isLoading,
  });

  final Widget child;
  final void Function() onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: _Button(
        onPressed: onPressed,
        child: AnimatedSwitcher(
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          duration: Duration(milliseconds: 300),
          child: isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Container(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({@required this.onPressed, @required this.child});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: onPressed, child: child);
  }
}
