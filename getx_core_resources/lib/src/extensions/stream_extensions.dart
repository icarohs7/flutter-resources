import 'package:getx_core_resources/getx_core_resources.dart';

extension GCRStreamExtensions<T> on Stream<T> {
  /// Create an observable from a stream,
  /// containing a null value initially
  /// and updating according to the stream events
  Rxn<T> get obsF => Rxn<T>()..bindStream(this);
}
