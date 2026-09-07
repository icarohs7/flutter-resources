import 'package:flutter/widgets.dart';

/// Animates the scale of a transformed widget in the X axis.
class const HorizontalScaleTransition({
  super.key,
  required Animation<double> scale,

  /// The alignment of the origin of the coordinate system in which the scale
  /// takes place, relative to the size of the box.
  ///
  /// For example, to set the origin of the scale to bottom middle, you can use
  /// an alignment of (0.0, 1.0).
  final Alignment alignment = Alignment.center,

  /// The widget below this widget in the tree.
  final Widget? child,
}) extends AnimatedWidget {
  this : super(listenable: scale);

  /// The animation that controls the scale of the child.
  ///
  /// If the current value of the scale animation is v, the child will be
  /// painted v times its normal size.
  Animation<double> get scale => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final scaleValue = scale.value;
    final transform = Matrix4.diagonal3Values(scaleValue, 1.0, 1.0);
    return Transform(transform: transform, alignment: alignment, child: child);
  }
}

/// Animates the scale of a transformed widget in the Y axis.
class const VerticalScaleTransition({
  super.key,
  required Animation<double> scale,

  /// The alignment of the origin of the coordinate system in which the scale
  /// takes place, relative to the size of the box.
  ///
  /// For example, to set the origin of the scale to bottom middle, you can use
  /// an alignment of (0.0, 1.0).
  final Alignment alignment = Alignment.center,

  /// The widget below this widget in the tree.
  final Widget? child,
}) extends AnimatedWidget {
  this : super(listenable: scale);

  /// The animation that controls the scale of the child.
  ///
  /// If the current value of the scale animation is v, the child will be
  /// painted v times its normal size.
  Animation<double> get scale => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final scaleValue = scale.value;
    final transform = Matrix4.diagonal3Values(1.0, scaleValue, 1.0);
    return Transform(transform: transform, alignment: alignment, child: child);
  }
}
