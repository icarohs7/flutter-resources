import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'baseclasses/abstract_json_database.dart';
import 'baseclasses/abstract_t_database.dart';

///Implementation of [AbstractTDatabase] using Hive
///as the underlying engine.
// ignore: non_constant_identifier_names
AbstractTDatabase<T> HiveTDatabase<T>({
  String? dbName,
  required T Function(Map<String, dynamic>) adapter,
}) {
  final db = HiveDatabase(dbName ?? '${T.runtimeType}'.toLowerCase());
  return AbstractTDatabase(jsonDatabase: db, adapter: adapter);
}

///Implementation of [AbstractJsonDatabase] using Hive
///as the underlying engine
// ignore: non_constant_identifier_names
class HiveDatabase extends AbstractJsonDatabase {
  HiveDatabase(this.boxName);

  final String boxName;

  Future<Box<String>> _getBox() async => await Hive.openBox(boxName);

  String _serialize(Map<String, dynamic> item) => jsonEncode(item);

  List<String> _serializeList(List<Map<String, dynamic>> items) => items.map(_serialize).toList();

  Map<String, dynamic> _deserialize(String item) => jsonDecode(item);

  List<Map<String, dynamic>> _deserializeList(List<String> items) {
    return items.map(_deserialize).toList();
  }

  @override
  Future<int> insert(Map<String, dynamic> item, {int? key}) async {
    final box = await _getBox();
    if (key != null) {
      await box.put(key, _serialize(item));
      return key;
    } else {
      return await box.add(_serialize(item));
    }
  }

  @override
  Future<void> insertAll(List<Map<String, dynamic>> items) async {
    await (await _getBox()).addAll(_serializeList(items));
  }

  @override
  Future<void> insertAllWithKeys(Map<int, Map<String, dynamic>> items) async {
    await (await _getBox()).putAll(items.map<int, String>((k, v) {
      return MapEntry(k, _serialize(v));
    }));
  }

  @override
  Future<void> replaceAll(List<Map<String, dynamic>> items) async {
    final box = await _getBox();
    await box.clear();
    await insertAll(items);
  }

  @override
  Future<void> replaceAllWithKeys(Map<int, Map<String, dynamic>> items) async {
    final box = await _getBox();
    await box.clear();
    await insertAllWithKeys(items);
  }

  @override
  Future<void> delete({int? key}) async {
    final box = await _getBox();
    if (key != null) {
      await box.delete(key);
    } else {
      await box.clear();
    }
  }

  @override
  Future<Map<String, dynamic>?> getSingle(int key) async {
    final item = (await _getBox()).get(key);
    return item != null ? _deserialize(item) : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    return _deserializeList((await _getBox()).values.toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> streamAll() async* {
    yield* (await _getBox())
        .watch()
        .throttleTime(Duration(milliseconds: 250), trailing: true)
        .asyncMap<List<Map<String, dynamic>>>((e) => getAll())
        .startWith(await getAll());
  }

  @override
  Stream<Map<String, dynamic>?> streamSingle(int key) async* {
    yield* (await _getBox())
        .watch(key: key)
        .throttleTime(Duration(milliseconds: 250), trailing: true)
        .asyncMap<Map<String, dynamic>?>((e) => getSingle(key))
        .startWith(await getSingle(key));
  }
}
