part of bloc_resources;

class NxBlocBase extends BlocBase {
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  void toggleLoading(bool isLoading) => _isLoading = isLoading;

  Future<T> runLoadingSetState<T>(Future<T> Function() operation) async {
    _isLoading = true;
    notifyListeners();
    final result = await operation();
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
