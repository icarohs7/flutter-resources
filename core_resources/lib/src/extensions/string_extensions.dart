import 'package:dartx/dartx.dart';

extension StringExtensions on String {
  /// Returns the result of the given function
  /// if the string if blank
  T ifBlank<T>(T Function() defaultValue) {
    return isBlank ? defaultValue() : this;
  }

  /// Returns the result of the given function
  /// if the string if empty
  T ifEmpty<T>(T Function() defaultValue) {
    return isEmpty ? defaultValue() : this;
  }
}