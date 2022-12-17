import 'dart:async';

import '../../core_resources.dart';

class Try<A> {
  factory Try(A Function() op, {String messageOnError = ''}) {
    try {
      return Try.value(op());
    } catch (e, s) {
      return Try.exception(e, stacktrace: s, message: messageOnError);
    }
  }

  static Future<Try<A>> async<A>(FutureOr<A> Function() op, {String messageOnError = ''}) async {
    try {
      return Try.value(await op());
    } catch (e, s) {
      return Try.exception(e, stacktrace: s, message: messageOnError);
    }
  }

  Try.value(this.value)
      : message = '',
        exception = null,
        stacktrace = null;

  Try.message(this.message, {this.exception, this.stacktrace}) : value = null;

  Try.exception(this.exception, {this.message = '', this.stacktrace})
      : assert(exception != null),
        value = null;

  final A? value;
  final String message;
  final dynamic exception;
  final StackTrace? stacktrace;

  bool get isValue => message.isBlank && exception == null && value != null;

  // ignore: null_check_on_nullable_type_parameter
  B fold<B>(B Function() ifError, B Function(A a) ifValue) => isValue ? ifValue(value!) : ifError();

  Try<B> map<B>(B Function(A a) f) {
    return fold(
      () => Try.message(message, exception: exception),
      (A a) => Try(() => f(a)),
    );
  }

  Try<B> flatMap<B>(Try<B> Function(A b) f) {
    return fold(
      () => Try.message(message, exception: exception, stacktrace: stacktrace),
      f,
    );
  }

  A getOrElse(A Function() dflt) => fold(dflt, (a) => a);

  A operator |(A other) => getOrElse(() => other);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Try &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          message == other.message &&
          exception == other.exception;

  @override
  int get hashCode => value.hashCode ^ message.hashCode ^ exception.hashCode;

  @override
  String toString() {
    return 'Try{value: $value, message: $message, exception: $exception, stacktrace: ${stacktrace == null ? 'null' : 'Instance of \'Stacktrace\''}';
  }
}

extension TryTryExtensions<T> on Try<Try<T>> {
  Try<T> flatten() {
    return value ?? Try.message(message, exception: exception, stacktrace: stacktrace);
  }
}

extension TryTryFutureExtensions<T> on Future<Try<Try<T>>> {
  Future<Try<T>> flatten() async {
    final thiss = await this;
    return thiss.value ??
        Try.message(thiss.message, exception: thiss.exception, stacktrace: thiss.stacktrace);
  }
}
