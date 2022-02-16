import 'package:getx_core_resources/getx_core_resources.dart';

/// GCR = Getx Core Resources
extension GCRStreamExtensions<T> on Stream<T> {
  /// Create an observable from a stream,
  /// containing a null value initially
  /// and updating according to the stream events
  Rxn<T> obsF({T? initialValue}) => Rxn<T>(initialValue)..bindStream(this);
}

extension GCRStreamOfMapExtensions<K, V> on Stream<Map<K, V>> {
  /// Create an observable map from a stream,
  /// containing an empty collection initially
  /// and updating according to the stream events
  RxMap<K, V> obsFMap({Map<K, V> initialValue = const {}}) => RxMap(initialValue)..bindStream(this);
}
