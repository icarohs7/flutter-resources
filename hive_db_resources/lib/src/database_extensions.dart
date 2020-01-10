import 'dart:convert';

import 'package:hive_db_resources/hive_db_resources.dart';

typedef JsonAdapter<T> = T Function(Map<String, dynamic> json);

extension DatabaseExtensions on Future<Box<Map<String, dynamic>>> {
  ///Insert the given value into a store, if [key] is defined and exists
  ///on store, the old value will be replaced, finally returning the key of the
  ///created or updated value
  Future<int> insert<T>(T value, {int key}) async {
    if (value == null) return -1;
    return await insertJson(jsonDecode(jsonEncode(value)), key: key);
  }

  ///Insert the given value into a store, if [key] is defined and exists
  ///on store, the old value will be replaced, finally returning the key of the
  ///created or updated value
  Future<int> insertJson(Map<String, dynamic> value, {int key}) async {
    if (value == null) return -1;
    if (key != null) {
      //replace record
      await (await this).put(key, value);
      return key;
    } else {
      //add new record
      return await (await this).add(value);
    }
  }

  ///Insert the given values to the database
  Future<void> insertAll<T>(List<T> values) async {
    if (values == null) return;
    insertAllJsons(
      values.map<Map<String, dynamic>>((e) {
        return jsonDecode(jsonEncode(e));
      }).toList(),
    );
  }

  ///Insert the given values to the database
  Future<void> insertAllJsons(List<Map<String, dynamic>> values) async {
    if (values == null) return;
    await (await this).addAll(values);
  }

  ///Erase the store and insert the given values
  Future<void> replaceAll<T>(List<T> values) async {
    if (values == null) return;
    await erase();
    await insertAll(values);
  }

  ///Erase the store and insert the given values
  Future<void> replaceAllJsons(List<Map<String, dynamic>> values) async {
    if (values == null) return;
    await erase();
    await insertAllJsons(values);
  }

  ///Delete the given item
  Future<void> delete(int key) async {
    await (await this).delete(key);
  }

  ///Remove all records from the given store,
  ///return the number of updated records
  Future<int> erase() async {
    return await (await this).clear();
  }

  ///Get records from the given store as maps of int keys and T type values
  Future<Map<int, T>> getAll<T>(JsonAdapter<T> adapter) async {
    return (await _get()).map((k, v) => MapEntry(k, adapter(v)));
  }

  ///Get records from the given store as maps of int keys and json values
  Future<Map<int, Map<String, dynamic>>> getAllJsons() async => await _get();

  ///Get a record on the given store identified by the given key
  Future<T> getSingle<T>(int key, JsonAdapter<T> adapter) async {
    return adapter(await getSingleJson(key));
  }

  ///Get a record on the given store identified by the given key
  Future<Map<String, dynamic>> getSingleJson(int key) async {
    return (await _get())[key];
  }

  ///Stream of all record snapshots on a given store
  Stream<Map<int, T>> streamAll<T>(JsonAdapter<T> adapter) async* {
    yield* (await this).watch().asyncMap((e) async {
      return (await _get()).map<int, T>((k, v) => MapEntry(k, adapter(v)));
    });
  }

  Future<Map<int, Map<String, dynamic>>> _get() async {
    return (await this).toMap().map((k, v) => MapEntry<int, Map<String, dynamic>>(k, v));
  }
}
