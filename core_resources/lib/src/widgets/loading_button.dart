import 'package:flutter/material.dart';

class LoadingRaisedButton extends StatelessWidget {
  const LoadingRaisedButton({
    @required this.onPressed,
    this.child,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.progressIndicatorColor,
  });

  final Widget child;
  final void Function() onPressed;
  final bool isLoading;
  final Color color;
  final Color textColor;
  final Color progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: RaisedButton(
        color: color,
        textColor: textColor,
        onPressed: onPressed,
        child: _ButtonContent(
          isLoading: isLoading,
          child: child,
          progressIndicatorColor:
              progressIndicatorColor ?? textColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class LoadingFlatButton extends StatelessWidget {
  const LoadingFlatButton({
    @required this.onPressed,
    this.child,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.progressIndicatorColor,
  });

  final Widget child;
  final void Function() onPressed;
  final bool isLoading;
  final Color color;
  final Color textColor;
  final Color progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: FlatButton(
        color: color,
        textColor: textColor,
        onPressed: onPressed,
        child: _ButtonContent(
          isLoading: isLoading,
          child: child,
          progressIndicatorColor:
              progressIndicatorColor ?? textColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    Key key,
    @required this.isLoading,
    @required this.child,
    @required this.progressIndicatorColor,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;
  final Color progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      child: isLoading
          ? Stack(alignment: Alignment.center, children: <Widget>[
              Opacity(
                opacity: 0,
                child: child,
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(progressIndicatorColor),
                  ),
                ),
              ),
            ])
          : child,
    );
  }
}
