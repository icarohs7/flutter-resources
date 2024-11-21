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
