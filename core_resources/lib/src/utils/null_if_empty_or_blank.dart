import 'package:dartx/dartx.dart';

/// Returns null when [value] is null or blank (empty or whitespace-only).
String? nullIfEmptyOrBlank(String? value) {
  if (value == null || value.isBlank) return null;
  return value;
}

/// Returns null when [value] is null or has no elements.
List<T>? nullIfEmpty<T>(List<T>? value) {
  if (value == null || value.isEmpty) return null;
  return value;
}
