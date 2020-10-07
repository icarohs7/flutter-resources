import 'dart:async';

import 'package:core_resources/core_resources.dart';

class Try<A> {
  factory Try(A op()) {
    try {
      return Try.value(op());
    } catch (e, s) {
      return Try.exception(e, stacktrace: s);
    }
  }

  static Future<Try<A>> async<A>(FutureOr<A> op()) async {
    try {
      return Try.value(await op());
    } catch (e, s) {
      return Try.exception(e, stacktrace: s);
    }
  }

  Try.value(this.value)
      : message = '',
        exception = null,
        stacktrace = null;

  Try.message(this.message, {this.exception, this.stacktrace})
      : assert(message != null),
        value = null;

  Try.exception(this.exception, {this.message = '', this.stacktrace})
      : assert(exception != null),
        value = null;

  final A value;
  final String message;
  final dynamic exception;
  final StackTrace stacktrace;

  bool get isValue => message.isBlank && exception == null;

  B fold<B>(B ifError(), B ifValue(A a)) => isValue ? ifValue(value) : ifError();

  Try<B> map<B>(B f(A a)) {
    return fold(
      () => Try.message(message, exception: exception),
      (A a) => Try(() => f(a)),
    );
  }

  A getOrElse(A dflt()) => fold(dflt, (a) => a);

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
}
