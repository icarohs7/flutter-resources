import 'dart:async';

import 'package:get_it/get_it.dart' as get_it;


abstract class Disposable extends get_it.Disposable {
  @override
  FutureOr onDispose();

  static Disposable create(FutureOr Function() onDispose) => _DisposableImpl(onDispose);
}

class _DisposableImpl implements Disposable {
  final FutureOr Function() callback;

  _DisposableImpl(this.callback);

  @override
  FutureOr onDispose() => callback();
}