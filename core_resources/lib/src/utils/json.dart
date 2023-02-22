import 'dart:convert';

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

/// Encode an object to its JSON representation
/// on background using the [compute] function
Future<String> jsonEncodeBg(dynamic obj) async {
  return compute((obs) => jsonEncode(obj), obj);
}
