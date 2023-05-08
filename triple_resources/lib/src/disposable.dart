import 'dart:async';

import 'package:get_it/get_it.dart' as get_it;

/// A class that has resources to be disposed of by
/// calling its [onDispose] method
abstract class Disposable extends get_it.Disposable {
  @override
  FutureOr onDispose();

  /// Shortcut to create a disposable from a lambda
  static Disposable create(FutureOr Function() onDispose) => _DisposableImpl(onDispose);
}

class _DisposableImpl implements Disposable {
  final FutureOr Function() callback;

  _DisposableImpl(this.callback);

  @override
  FutureOr onDispose() => callback();
}
