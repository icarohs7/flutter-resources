import 'package:flutter/material.dart';

extension ObjectExtensions<T> on T {
  MaterialStateProperty<T> get materialProperty => MaterialStateProperty.all(this);

  ///Returns the result of applying the given function to
  ///`this` object
  R apply<R>(R Function(T) f) => f(this);
}
