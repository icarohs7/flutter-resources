import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

/// Decode a String to a JSON object on background
/// using the [compute] function
Future<Map<String, dynamic>> jsonDecodeObj(String source) async {
  return Isolate.run(() => jsonDecode(source));
}

/// Decode a String to a JSON array on background
/// using the [compute] function
Future<List<dynamic>> jsonDecodeArray(String source) async {
  return Isolate.run(() => jsonDecode(source));
}

/// Encode an object to its JSON representation
/// on background using the [compute] function
Future<String> jsonEncodeBg(dynamic obj) async {
  return Isolate.run(() => jsonEncode(obj));
}
