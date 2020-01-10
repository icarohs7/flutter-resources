import 'dart:convert';

import 'package:core_resources/core_resources.dart';
import 'package:sembast_db_resources/sembast_db_resources.dart';

import '../sembast_db_resources.dart';

///Create a default instace of a sembast database using the file name 'app.db'
Future<Database> createDefaultSembastDatabase() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  return databaseFactoryIo.openDatabase(join(appDocDir.path, 'app.db'));
}

typedef JsonAdapter<T> = T Function(Map<String, dynamic>);

extension DatabaseExtensions on Future<Database> {
  ///Insert the given value into a store, if [key] is defined and exists
  ///on store, the old value will be replaced
  Future<void> insertWithStringKey<T>(String storeName, T value, {String key}) async {
    if (value == null) return;
    return await insertJsonWithStringKey(storeName, jsonDecode(jsonEncode(value)), key: key);
  }

  ///Insert the given value into a store, if [key] is defined and exists
  ///on store, the old value will be replaced
  Future<void> insertJsonWithStringKey(
    String storeName,
    Map<String, dynamic> value, {
    String key,
  }) async {
    if (value == null) return;
    await _stringStore(storeName).record(key).put(await this, value);
  }

  ///Insert the given value into a store, if [key] is defined and exists
  ///on store, the old value will be replaced, finally returning the key of the
  ///created or updated value
  Future<int> insert<T>(String storeName, T value, {int key}) async {
    if (value == null) return -1;
    return await insertJson(storeName, jsonDecode(jsonEncode(value)));
  }

  ///Insert the given value into a store, if [key] is defined and exists
  ///on store, the old value will be replaced, finally returning the key of the
  ///created or updated value
  Future<int> insertJson(String storeName, Map<String, dynamic> value, {int key}) async {
    if (value == null) return -1;
    if (key != null) {
      await _intStore(storeName).record(key).put(await this, value);
      return key;
    } else {
      return await _intStore(storeName).add(await this, value);
    }
  }

  ///Insert the given values to the database
  Future<void> insertAll<T>(String storeName, List<T> values) async {
    if (values == null) return;
    insertAllJsons(
      storeName,
      values.map<Map<String, dynamic>>((e) {
        return jsonDecode(jsonEncode(e));
      }).toList(),
    );
  }

  ///Insert the given values to the database
  Future<void> insertAllJsons(String storeName, List<Map<String, dynamic>> values) async {
    if (values == null) return;
    await _intStore(storeName).addAll(await this, values);
  }

  ///Erase the store and insert the given values
  Future<void> replaceAll<T>(String storeName, List<T> values) async {
    if (values == null) return;
    await erase(storeName);
    await insertAll(storeName, values);
  }

  ///Erase the store and insert the given values
  Future<void> replaceAllJsons(String storeName, List<Map<String, dynamic>> values) async {
    if (values == null) return;
    await erase(storeName);
    await insertAllJsons(storeName, values);
  }

  ///Delete the given item
  Future<void> delete(String storeName, int key) async {
    await _intStore(storeName).record(key).delete(await this);
  }

  ///Delete the given item
  Future<void> deleteWithStringKey(String storeName, String key) async {
    await _stringStore(storeName).record(key).delete(await this);
  }

  ///Remove all records from the given store,
  ///return the number of updated records
  Future<void> erase(String storeName) async {
    await runCatchingAsync(() async => await _intStore(storeName).drop(await this));
    await runCatchingAsync(() async => await _stringStore(storeName).drop(await this));
  }

  ///Get records from the given store as maps of int keys and T type values
  Future<Map<int, T>> getAll<T>(String storeName, JsonAdapter<T> adapter) async {
    return (await _get(storeName)).map((k, v) => MapEntry(k, adapter(v)));
  }

  ///Get records from the given store as maps of int keys and json values
  Future<Map<int, Map<String, dynamic>>> getAllJsons(String storeName) async => _get(storeName);

  ///Get a record on the given store identified by the given key
  Future<T> getSingleWithStringKey<T>(String storeName, String key, JsonAdapter<T> adapter) async {
    return adapter(await _stringStore(storeName).record(key).get(await this));
  }

  ///Get a record on the given store identified by the given key
  Future<T> getSingleWithIntKey<T>(String storeName, int key, JsonAdapter<T> adapter) async {
    return adapter(await _intStore(storeName).record(key).get(await this));
  }

  ///Stream of all record snapshots on a given store
  Stream<Map<int, T>> streamAll<T>(String storeName, JsonAdapter<T> adapter) async* {
    yield* _intStore(storeName).query().onSnapshots(await this).map<Map<int, T>>((data) {
      return data.associate<int, T>((e) {
        return MapEntry(e.key, adapter(e.value));
      });
    });
  }

  Future<Map<int, Map<String, dynamic>>> _get(String storeName) async {
    final store = intMapStoreFactory.store(storeName);
    return (await store.query().getSnapshots(await this)).associate<int, Map<String, dynamic>>((e) {
      return MapEntry(e.key, e.value);
    });
  }

  StoreRef<int, Map<String, dynamic>> _intStore(String storeName) {
    return intMapStoreFactory.store(storeName);
  }

  StoreRef<String, Map<String, dynamic>> _stringStore(String storeName) {
    return stringMapStoreFactory.store(storeName);
  }
}
