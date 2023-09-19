class ExceptionWrapper implements Exception {
  final Object error;
  final StackTrace? stack;

  ExceptionWrapper(this.error, this.stack);

  @override
  String toString() => '$error\n$stack';
}
