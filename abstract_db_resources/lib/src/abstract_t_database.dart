import 'dart:convert';

import 'package:abstract_db_resources/src/abstract_json_database.dart';
import 'package:flutter/foundation.dart';

///Abstraction of database storing records
///as json objects but exposing them as
///T objects, converted by the [adapter]
///field
class AbstractTDatabase<T> {
  AbstractTDatabase({
    @required this.jsonDatabase,
    @required this.adapter,
  });

  final AbstractJsonDatabase jsonDatabase;
  final T Function(Map<String, dynamic>) adapter;

  Map<String, dynamic> _serialize(T item) => jsonDecode(jsonEncode(item));

  List<Map<String, dynamic>> _serializeList(List<T> items) => items.map(_serialize).toList();

  T _deserialize(Map<String, dynamic> json) => adapter(json);

  List<T> _deserializeList(List<Map<String, dynamic>> items) => items.map(_deserialize).toList();

  ///Store single item
  Future<int> insert(T item, {int key}) {
    return jsonDatabase.insert(_serialize(item), key: key);
  }

  ///Store multiple items
  Future<void> insertAll(List<T> items) {
    return jsonDatabase.insertAll(_serializeList(items));
  }

  ///Erase the database and insert values
  Future<void> replaceAll(List<T> items) {
    return jsonDatabase.replaceAll(_serializeList(items));
  }

  ///Remove data, if [key] is defined, only the record
  ///identified will be deleted, otherwise erase all
  ///records
  Future<void> delete({int key}) {
    return jsonDatabase.delete(key: key);
  }

  ///Get a record identified by the given [key]
  Future<T> getSingle(int key) async {
    return _deserialize(await jsonDatabase.getSingle(key));
  }

  ///Get all records stored
  Future<List<T>> getAll() async {
    return _deserializeList(await jsonDatabase.getAll());
  }

  ///Stream of the latest records store
  Stream<List<T>> streamAll() {
    return jsonDatabase.streamAll().map(_deserializeList);
  }

  ///Stream of the latest version of a record
  ///identified by the given [key]
  Stream<T> streamSingle(int key) {
    return jsonDatabase.streamSingle(key).map(_deserialize);
  }
}
