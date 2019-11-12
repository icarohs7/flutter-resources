import 'package:async/async.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class NxBlocBase extends BlocBase {
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  void toggleLoading(bool isLoading) => _isLoading = isLoading;

  Future<T> runLoadingSetState<T>(Future<T> Function() operation) async {
    _isLoading = true;
    notifyListeners();
    Result<T> result;
    try {
      result = Result.value(await operation());
    } on Exception catch (e) {
      result = Result.error(e);
    }
    _isLoading = false;
    notifyListeners();
    return await result.asFuture;
  }

  void setState(void Function() operation) {
    operation();
    notifyListeners();
  }

  Object logError(dynamic e) {
    print("Error on $runtimeType => ${e?.response?.body ?? e}");
    return null;
  }
}
