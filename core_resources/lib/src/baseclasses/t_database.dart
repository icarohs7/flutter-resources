import 'dart:convert';

import 'package:dartx/dartx.dart';

import '../extensions/object_extensions.dart';
import 'json_database.dart';

///Abstraction of database storing records
///as json objects but exposing them as
///T objects, converted by the [adapter]
///field
class TDatabase<T> {
  TDatabase({
    required JsonDatabase jsonDatabase,
    required this.adapter,
  }) : db = jsonDatabase;

  final JsonDatabase db;
  final T Function(JsonObject) adapter;

  JsonObject _serialize(T item) => jsonDecode(jsonEncode(item));

  Iterable<JsonObject> _serializeList(Iterable<T> items) => items.map(_serialize);

  T? _deserialize(JsonObject json) => adapter(json);

  Iterable<T> _deserializeList(Iterable<JsonObject> items) => items.mapNotNull(_deserialize);

  ///Store single item
  Future<int> insert(T item, {int? key}) => db.insert(_serialize(item), key: key);

  ///Store multiple items
  Future<void> insertAll(Iterable<T> items) => db.insertAll(_serializeList(items));

  ///Store multiple items associating ids to each
  Future<void> insertAllWithKeys(Map<int, T> items) {
    return db.insertAllWithKeys(items.map((k, v) => MapEntry(k, _serialize(v))));
  }

  ///Erase the database and insert values
  Future<void> replaceAll(Iterable<T> items) => db.replaceAll(_serializeList(items));

  ///Erase the database and insert values using identifiers
  Future<void> replaceAllWithKeys(Map<int, T> items) {
    return db.replaceAllWithKeys(items.map((k, v) => MapEntry(k, _serialize(v))));
  }

  ///Remove data, if [key] is defined, only the record
  ///identified will be deleted, otherwise erase all
  ///records
  Future<void> delete({int? key}) => db.delete(key: key);

  ///Get a record identified by the given [key]
  Future<T?> getSingle(int key) async => (await db.getSingle(key))?.apply(_deserialize);

  ///Get all records stored
  Future<Iterable<T>> getAll() async => _deserializeList(await db.getAll());

  ///Stream of the latest records store
  Stream<Iterable<T>> streamAll() => db.streamAll().map(_deserializeList).asBroadcastStream();

  ///Stream of the latest version of a record
  ///identified by the given [key]
  Stream<T?> streamSingle(int key) {
    return db.streamSingle(key).map((json) => json?.apply(_deserialize)).asBroadcastStream();
  }
}
