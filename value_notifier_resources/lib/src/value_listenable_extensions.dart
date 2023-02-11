import 'package:flutter/foundation.dart';
import 'package:functional_listener/functional_listener.dart';

extension CRValueListenableExtensions<T> on ValueListenable<T> {
  ///
  /// converts a ValueListenable to another type [T] by returning a new connected
  /// `ValueListenable<T>`
  /// on each value change of `this` the conversion function
  /// [convert] is called to do the type conversion
  ValueListenable<R> mapEvent<R>(R Function(T value) convert) => map(convert);

  ///
  /// [whereEvent] allows you to set a filter on a `ValueListenable` so that an installed
  /// handler function is only called if the passed
  /// [selector] function returns true. Because the selector function is called on
  /// every new value you can change the filter during runtime.
  ValueListenable<T> whereEvent(bool Function(T value) selector) => where(selector);
}
