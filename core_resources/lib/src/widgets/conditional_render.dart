import 'package:material_ui/material_ui.dart';

///Render the given [child] only if the given
///[condition] is true, implicitly animating the
///transitions using the given [duration] with
///the animation returned from the [transitionBuilder]
class const ConditionalRender({
  super.key,
  required final bool condition,
  final Widget? child,
  final Widget Function(BuildContext)? childBuilder,
  final Widget? childElse,
  final Widget Function(BuildContext)? childElseBuilder,
  final Duration duration = const Duration(milliseconds: 200),
  final Duration? reverseDuration,
  final AnimatedSwitcherTransitionBuilder? transitionBuilder,
  final Curve switchInCurve = Curves.linear,
  final Curve switchOutCurve = Curves.linear,
  final bool animationsEnabled = true,
}) extends StatelessWidget {
  this : assert(child != null || childBuilder != null);

  @override
  Widget build(BuildContext context) {
    getChild() => (child ?? childBuilder?.call(context))!;
    getChildElse() => (childElse ?? childElseBuilder?.call(context) ?? SizedBox.shrink());

    if (!animationsEnabled) {
      return condition ? getChild() : getChildElse();
    }
    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder:
          transitionBuilder ??
          (child, value) {
            return ScaleTransition(scale: value, child: child);
          },
      child: condition ? getChild() : getChildElse(),
    );
  }
}
