import 'package:material_ui/material_ui.dart';

class FadePageRoute<T>({required final Widget page}) extends PageRouteBuilder<T> {
  this
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return page;
            },
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
      );
}
