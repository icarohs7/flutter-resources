import 'package:flutter/material.dart';

class LoadingRaisedButton extends StatelessWidget {
  const LoadingRaisedButton({
    @required this.onPressed,
    this.child,
    this.isLoading,
    this.isLoadingStream,
  }) : assert(!(isLoading != null && isLoadingStream != null));

  final Widget child;
  final void Function() onPressed;
  final bool isLoading;
  final Stream<bool> isLoadingStream;

  @override
  Widget build(BuildContext context) {
    return isLoadingStream != null
        ? StreamBuilder(
            stream: isLoadingStream,
            initialData: false,
            builder: (context, snapshot) {
              return _Button(isLoading: snapshot.data, onPressed: onPressed, child: child);
            },
          )
        : _Button(isLoading: isLoading ?? false, onPressed: onPressed, child: child);
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.isLoading,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  final bool isLoading;
  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: RaisedButton(
        onPressed: onPressed,
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
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
