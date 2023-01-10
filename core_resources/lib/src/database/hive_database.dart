import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 't_database.dart';

///Implementation of [TDatabase] using Hive
///as the underlying engine.
// ignore: non_constant_identifier_names
TDatabase<T> HiveTDatabase<T>(String dbName, T Function(JsonObject) adapter) =>
    HiveDatabase(dbName, adapter);

///Implementation of [JsonDatabase] using Hive
///as the underlying engine
// ignore: non_constant_identifier_names
class HiveDatabase<T> extends TDatabase<T> {
  HiveDatabase(String boxName, T Function(JsonObject) adapter)
      : box = HiveBoxAdapter<T>(boxName, adapter);

  final HiveBoxAdapter<T> box;

  @override
  Future<int> insert(T item, {int? key}) => key != null ? box.put(key, item) : box.add(item);

  @override
  Future<void> insertAll(Iterable<T> items) => Future.wait(items.map(insert));

  @override
  Future<void> insertAllWithKeys(Map<int, T> items) =>
      Future.wait(items.entries.map((e) => insert(e.value, key: e.key)));

  @override
  Future<void> replaceAll(Iterable<T> items) => deleteAll().then((_) => insertAll(items));

  @override
  Future<void> replaceAllWithKeys(Map<int, T> items) =>
      deleteAll().then((_) => insertAllWithKeys(items));

  @override
  Future<void> deleteAll() => box.clear();

  @override
  Future<void> delete(int key) => box.delete(key);

  @override
  Future<T?> getSingle(int key) async => box.get(key);

  @override
  Future<Iterable<T>> getAll() async => box.values();

  @override
  Stream<Iterable<T>> streamAll() async* {
    yield* box.watchAll().throttleTime(Duration(milliseconds: 250), trailing: true);
  }

  @override
  Stream<T?> streamSingle(int key) async* {
    yield* box.watch(key).throttleTime(Duration(milliseconds: 250), trailing: true);
  }
}

class HiveBoxAdapter<T> {
  final String boxName;
  final T Function(JsonObject) adapter;

  HiveBoxAdapter(this.boxName, this.adapter);

  Box<String>? hiveBox;

  Future<Box<String>> _box() async => hiveBox ??= await Hive.openBox<String>(boxName);

  String _encode(T item) => jsonEncode(item);

  T _decode(String json) => adapter(jsonDecode(json));

  Future<int> put(int key, T value) async {
    final box = await _box();
    await box.put(key, _encode(value));
    return key;
  }

  Future<int> add(T value) async {
    final box = await _box();
    return box.add(_encode(value));
  }

  Future<void> delete(int key) async {
    final box = await _box();
    await box.delete(key);
  }

  Future<void> clear() async {
    final box = await _box();
    await box.clear();
  }

  Future<T?> get(int key) async {
    final box = await _box();
    final value = box.get(key);
    return value != null ? _decode(value) : null;
  }

  Future<Iterable<T>> values() async {
    final box = await _box();
    return box.values.map((e) => _decode(e));
  }

  Stream<T?> watch(int key) async* {
    final box = await _box();
    yield* box
        .watch(key: key)
        .asyncMap((e) => get(key))
        .startWith(await get(key))
        .asBroadcastStream();
  }

  Stream<Iterable<T>> watchAll() async* {
    final box = await _box();
    yield* box.watch().asyncMap((e) => values()).startWith(await values()).asBroadcastStream();
  }
}
