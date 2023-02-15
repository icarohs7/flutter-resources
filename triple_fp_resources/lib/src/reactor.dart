import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';

/// A wrapper around [ValueNotifier]
class Reactor<T> extends ValueNotifier<T> {
  Reactor(super.value);

  void setValue(T newValue) => value = newValue;
}

/// Shortcut to create a [Reactor] of a non-nullable type
// ignore: non_constant_identifier_names
Reactor<T> Rc<T extends Object>(T initialValue) => Reactor(initialValue);

/// Shortcut to create a [Reactor] of a nullable type
// ignore: non_constant_identifier_names
Reactor<T?> Rcn<T>([T? initialValue]) => Reactor(initialValue);

extension ReactorX<T> on T {
  /// Create a reactor using suffix form
  ///
  /// example:
  /// final value = 1;
  /// final Reactor<int> reactor = 1.rc;
  Reactor<T> get rc => Reactor(this);
}

/// Hook to subscribe and use a [Reactor] object
T useReactor<T>(ValueListenable<T> reactor) => useValueListenable(reactor);
