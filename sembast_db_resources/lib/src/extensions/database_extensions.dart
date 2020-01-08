import 'package:sembast_db_resources/sembast_db_resources.dart';

import '../../sembast_db_resources.dart';

///Create a default instace of a sembast database using the file name 'app.db'
Future<Database> createDefaultSembastDatabase() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  return databaseFactoryIo.openDatabase(join(appDocDir.path, 'app.db'));
}

extension DatabaseExtensions on Future<Database> {
  ///Get a record value with the given key as a List from the main store
  Future<List> getListRecordFromMainStore(String key) async {
    return await _getTRecordFromMainStore(key);
  }

  ///Put the given value into a record on the main store
  Future<void> putListRecordOnMainStore(String key, List value) async {
    return await _putTRecordOnMainStore(key, value);
  }

  ///Get a record value with the given key as a String from the main store
  Future<String> getStringRecordFromMainStore(String key) async {
    return await _getTRecordFromMainStore(key);
  }

  ///Put the given value into a record on the main store
  Future<void> putStringRecordOnMainStore(String key, String value) async {
    return await _putTRecordOnMainStore(key, value);
  }

  Future<T> _getTRecordFromMainStore<T>(String key) async {
    final db = await this;
    return await StoreRef<String, T>.main().record(key).get(db);
  }

  Future<void> _putTRecordOnMainStore<T>(String key, T value) async {
    final db = await this;
    return await StoreRef<String, T>.main().record(key).put(db, value);
  }
}
