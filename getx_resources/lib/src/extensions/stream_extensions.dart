import 'package:get/get.dart';

/// GCR = Getx Core Resources
extension GCRStreamExtensions<T> on Stream<T> {
  /// Create an observable from a stream,
  /// containing a null value initially
  /// and updating according to the stream events
  Rxn<T> obsF({T? initialValue}) => Rxn<T>(initialValue)..bindStream(this);

  /// Create an observable from a stream,
  /// containing [initialValue] initially
  /// and updating according to the stream events
  /// non-nullable version of [obsF]
  Rx<T> obsFNN({required T initialValue}) => Rx<T>(initialValue)..bindStream(this);
}

extension GCRStreamOfMapExtensions<K, V> on Stream<Map<K, V>> {
  /// Create an observable map from a stream,
  /// containing an empty collection initially
  /// and updating according to the stream events
  RxMap<K, V> obsFMap({Map<K, V> initialValue = const {}}) => RxMap(initialValue)..bindStream(this);
}
