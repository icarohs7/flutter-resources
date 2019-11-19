import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bloc_resources/bloc_resources.dart';

class NxBlocBase extends BlocBase {
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Stream<bool> get isLoadingStream => _isLoading$;
  final BehaviorSubject<bool> _isLoading$ = BehaviorSubject.seeded(false);

  void toggleLoading(bool isLoading) {
    setState(() => _isLoading = isLoading);
    _isLoading$.value = isLoading;
  }

  Future<T> runLoadingSetState<T>(Future<T> Function() operation) async {
    toggleLoading(true);
    final result = await runCatchingAsync(() async => await operation());
    toggleLoading(false);
    return result.asFuture;
  }

  void setState(void Function() operation) {
    operation();
    notifyListeners();
  }

  Object logError(dynamic e) {
    print("Error on $runtimeType => ${e?.response?.body ?? e}");
    return null;
  }

  @override
  void dispose() {
    _isLoading$.close();
    super.dispose();
  }
}
