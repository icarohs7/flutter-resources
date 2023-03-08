import 'package:flutter/material.dart';

///Render the given [child] only if the given
///[condition] is true, implicitly animating the
///transitions using the given [duration] with
///the animation returned from the [transitionBuilder]
class ConditionalRender extends StatelessWidget {
  const ConditionalRender({
    super.key,
    required this.condition,
    this.child,
    this.childBuilder,
    this.childElse,
    this.childElseBuilder,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
    this.transitionBuilder,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.animationsEnabled = true,
  }) : assert(child != null || childBuilder != null);

  final bool condition;
  final Widget? child;
  final Widget Function(BuildContext)? childBuilder;
  final Widget? childElse;
  final Widget Function(BuildContext)? childElseBuilder;
  final Duration duration;
  final Duration? reverseDuration;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final bool animationsEnabled;

  @override
  Widget build(BuildContext context) {
    getChild() => (child ?? childBuilder?.call(context))!;
    getChildElse() => (childElse ?? childElseBuilder?.call(context) ?? SizedBox());

    if (!animationsEnabled) {
      return condition ? getChild() : getChildElse();
    }
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder: transitionBuilder ??
          (child, value) {
            return ScaleTransition(scale: value, child: child);
          },
      child: condition ? getChild() : getChildElse(),
    );
  }
}
