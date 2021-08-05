import 'package:getx_core_resources/getx_core_resources.dart';

extension GCRFutureExtensions<T> on Future<T> {
  /// Create an observable from a future,
  /// containing a null value initially
  /// and updating to the future's result
  /// when done
  Rxn<T> get obxF => Rxn<T>()..bindStream(asStream());
}
