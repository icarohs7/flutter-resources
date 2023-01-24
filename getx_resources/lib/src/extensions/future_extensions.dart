import 'package:get/get.dart';

extension GCRFutureExtensions<T> on Future<T> {
  /// Create an observable from a future,
  /// containing a null value initially
  /// and updating to the future's result
  /// when done
  Rxn<T> obsF() => Rxn<T>()..bindStream(asStream());
}
