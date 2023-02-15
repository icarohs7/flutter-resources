import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';

class Reactor<T> extends ValueNotifier<T> {
  Reactor(super.value);

  void setValue(T newValue) => value = newValue;
}

// ignore: non_constant_identifier_names
Reactor<T> Rc<T>(T initialValue) => Reactor(initialValue);

// ignore: non_constant_identifier_names
Reactor<T?> Rcn<T>([T? initialValue]) => Reactor(initialValue);

extension ReactorX<T> on T {
  Reactor<T> get rc => Reactor(this);
}

T useReactor<T>(ValueListenable<T> reactor) => useValueListenable(reactor);
