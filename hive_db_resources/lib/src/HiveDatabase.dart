import 'package:flutter/foundation.dart';
import 'package:hive_db_resources/hive_db_resources.dart';

///Implementation of [AbstractTDatabase] using Hive
///as the underlying engine
// ignore: non_constant_identifier_names
AbstractTDatabase<T> HiveTDatabase<T>({
  HiveDatabase jsonDatabase,
  T Function(Map<String, dynamic>) adapter,
}) {
  return AbstractTDatabase(jsonDatabase: jsonDatabase, adapter: adapter);
}

///Implementation of [AbstractJsonDatabase] using Hive
///as the underlying engine
// ignore: non_constant_identifier_names
AbstractJsonDatabase HiveJsonDatabase({@required String boxName}) {
  return HiveDatabase(boxName: boxName);
}

class HiveDatabase extends AbstractJsonDatabase {
  HiveDatabase({@required this.boxName});

  final String boxName;

  Future<Box<Map<String, dynamic>>> _getBox() async => await Hive.openBox(boxName);

  @override
  Future<int> insert(Map<String, dynamic> item, {int key}) async {
    final box = await _getBox();
    if (key != null) {
      await box.put(key, item);
      return key;
    } else {
      return await box.add(item);
    }
  }

  @override
  Future<void> insertAll(List<Map<String, dynamic>> items) async {
    await (await _getBox()).addAll(items);
  }

  @override
  Future<void> replaceAll(List<Map<String, dynamic>> items) async {
    final box = await _getBox();
    await box.clear();
    await insertAll(items);
  }

  @override
  Future<void> delete({int key}) async {
    final box = await _getBox();
    if (key != null) {
      await box.delete(key);
    } else {
      await box.clear();
    }
  }

  @override
  Future<Map<String, dynamic>> getSingle(int key) async {
    return (await _getBox()).get(key);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    return (await _getBox()).values.toList();
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
  Stream<Map<String, dynamic>> streamSingle(int key) async* {
    yield* (await _getBox()).watch(key: key).asyncMap<Map<String, dynamic>>((e) => getSingle(key));
  }
}
