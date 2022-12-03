import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

extension ObjectExtensions<T> on T {
  MaterialStateProperty<T> get materialProperty => MaterialStateProperty.all(this);

  BehaviorSubject<T> get subject => BehaviorSubject.seeded(this);
}
