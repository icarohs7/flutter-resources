import 'package:flutter/material.dart';

extension CRObjectExtensions<T> on T {
  WidgetStateProperty<T> get materialProperty => WidgetStateProperty.all(this);

  ///Returns the result of applying the given function to
  ///`this` object
  R apply<R>(R Function(T) f) => f(this);
}
