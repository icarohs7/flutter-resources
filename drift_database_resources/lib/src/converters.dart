import 'dart:convert';

import 'package:drift/drift.dart';

/// Stores a Drift value as a JSON string and restores it through [fromJson].
///
/// Subclasses define the application value represented by the JSON object;
/// database failure mapping stays outside the converter.
abstract class const DriftJsonConverter<T>() extends TypeConverter<T, String> {
  @override
  String toSql(T value) => jsonEncode(value);

  /// Converts the decoded database JSON object into the application value.
  T fromJson(Map<String, dynamic> json);

  @override
  T fromSql(String fromDb) => fromJson(jsonDecode(fromDb) as Map<String, dynamic>);
}
