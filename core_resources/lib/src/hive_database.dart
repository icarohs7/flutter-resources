import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'baseclasses/json_database.dart';
import 'baseclasses/t_database.dart';

///Implementation of [TDatabase] using Hive
///as the underlying engine.
// ignore: non_constant_identifier_names
TDatabase<T> HiveTDatabase<T>({
  String? dbName,
  required T Function(JsonObject) adapter,
}) {
  final db = HiveDatabase(dbName ?? '${T.runtimeType}'.toLowerCase());
  return TDatabase(jsonDatabase: db, adapter: adapter);
}

///Implementation of [JsonDatabase] using Hive
///as the underlying engine
// ignore: non_constant_identifier_names
class HiveDatabase extends JsonDatabase {
  HiveDatabase(this.boxName);

  final String boxName;

  Future<Box<JsonObject>> _box() async => await Hive.openBox(boxName);

  @override
  Future<int> insert(JsonObject item, {int? key}) async {
    final box = await _box();
    if (key != null) {
      await box.put(key, item);
      return key;
    } else {
      return await box.add(item);
    }
  }

  @override
  Future<void> insertAll(Iterable<JsonObject> items) async => (await _box()).addAll(items);

  @override
  Future<void> insertAllWithKeys(Map<int, JsonObject> items) async => (await _box()).putAll(items);

  @override
  Future<void> replaceAll(Iterable<JsonObject> items) async {
    final box = await _box();
    await box.clear();
    await insertAll(items);
  }

  @override
  Future<void> replaceAllWithKeys(Map<int, JsonObject> items) async {
    final box = await _box();
    await box.clear();
    await insertAllWithKeys(items);
  }

  @override
  Future<void> delete({int? key}) async {
    final box = await _box();
    if (key != null) {
      await box.delete(key);
    } else {
      await box.clear();
    }
  }

  @override
  Future<JsonObject?> getSingle(int key) async => (await _box()).get(key);

  @override
  Future<Iterable<JsonObject>> getAll() async => (await _box()).values;

  @override
  Stream<Iterable<JsonObject>> streamAll() async* {
    yield* (await _box())
        .watch()
        .throttleTime(Duration(milliseconds: 250), trailing: true)
        .asyncMap<Iterable<JsonObject>>((e) => getAll())
        .startWith(await getAll());
  }

  @override
  Stream<JsonObject?> streamSingle(int key) async* {
    yield* (await _box())
        .watch(key: key)
        .throttleTime(Duration(milliseconds: 250), trailing: true)
        .asyncMap<JsonObject?>((e) => getSingle(key))
        .startWith(await getSingle(key));
  }
}
