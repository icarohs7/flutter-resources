import 'package:flutter/material.dart';

///Render the given [child] only if the given
///[condition] is true, implicitly animating the
///transitions using the given [duration] with
///the animation returned from the [transitionBuilder]
class ConditionalRender extends StatelessWidget {
  const ConditionalRender({
    @required this.condition,
    @required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
    this.transitionBuilder,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.animationsEnabled = true,
  });

  final bool condition;
  final Widget child;
  final Duration duration;
  final Duration reverseDuration;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final bool animationsEnabled;

  @override
  Widget build(BuildContext context) {
    if (animationsEnabled == false) return condition ? child : SizedBox();
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder: transitionBuilder ??
          (child, value) {
          return ScaleTransition(child: child, scale: value);
        },
      child: condition ? child : SizedBox(),
    );
  }
}
