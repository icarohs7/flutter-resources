import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

/// Decode a String to a JSON object on background
/// using the [compute] function
Future<Map<String, dynamic>> jsonDecodeObj(String source) async {
  return compute((s) => jsonDecode(s), source);
}

/// Decode a String to a JSON array on background
/// using the [compute] function
Future<List<dynamic>> jsonDecodeArray(String source) async {
  return compute((s) => jsonDecode(s), source);
}

/// Decode a byte array using utf and json decoders fused
/// for better performance
Future<Object?> jsonDecodeBytesBg(List<int> bytes) async {
  return Isolate.run(() => const Utf8Decoder().fuse(const JsonDecoder()).convert(bytes));
}

/// Encode an object to its JSON representation
/// on background using the [compute] function
Future<String> jsonEncodeBg(dynamic obj) async {
  return compute((obs) => jsonEncode(obj), obj);
}

/// Parses a JSON field that may arrive as [int], [num], or numeric [String].
///
/// Returns null when [value] is null or not int-compatible.
int? parseJsonInt(Object? value) {
  return switch (value) {
    null => null,
    int v => v,
    num v => v.toInt(),
    String v => int.tryParse(v),
    _ => null,
  };
}

/// Like [parseJsonInt], but throws [FormatException] when parsing fails.
///
/// Use with `@JsonKey(fromJson: requiredJsonInt)` on required model fields.
int requiredJsonInt(Object? value) {
  final parsed = parseJsonInt(value);
  if (parsed == null) {
    throw FormatException('Expected int-compatible JSON value, got $value (${value.runtimeType})');
  }
  return parsed;
}

/// Like [parseJsonInt], but returns 0 when parsing fails.
///
/// Use with `@JsonKey(fromJson: optionalJsonInt)` on optional numeric fields.
int optionalJsonInt(Object? value) => parseJsonInt(value) ?? 0;

/// Parses a required ISO-8601 [String] (or other [value] via [Object.toString]).
///
/// Throws [FormatException] when [value] is null, empty, or not parseable.
/// Parsed values are converted with [DateTime.toLocal].
///
/// Use with `@JsonKey(fromJson: requiredJsonDateTime)` on required [DateTime] fields.
DateTime requiredJsonDateTime(Object? value, {String fieldName = 'DateTime'}) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  if (parsed == null) {
    throw FormatException(
      'Expected ISO-8601 DateTime for $fieldName, got $value (${value.runtimeType})',
    );
  }
  return parsed.toLocal();
}
