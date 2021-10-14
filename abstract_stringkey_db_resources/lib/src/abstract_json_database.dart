///Abstraction of database storing records
///as json objects in the form of
///Map<String, dynamic> objects
abstract class AbstractJsonDatabase {
  ///Store single item
  Future<String> insert(Map<String, dynamic> item, {String? key});

  ///Store multiple items
  Future<void> insertAll(List<Map<String, dynamic>> items);

  ///Store multiple items associating ids to each
  Future<void> insertAllWithKeys(Map<String, Map<String, dynamic>> items);

  ///Erase the database and insert values
  Future<void> replaceAll(List<Map<String, dynamic>> items);

  ///Erase the database and insert values using identifiers
  Future<void> replaceAllWithKeys(Map<String, Map<String, dynamic>> items);

  ///Remove data, if [key] is defined, only the record
  ///identified will be deleted, otherwise erase all
  ///records
  Future<void> delete({String? key});

  ///Get a record identified by the given [key]
  Future<Map<String, dynamic>?> getSingle(String key);

  ///Get all records stored
  Future<List<Map<String, dynamic>>> getAll();

  ///Stream of the latest records store
  Stream<List<Map<String, dynamic>>> streamAll();

  ///Stream of the latest version of a record
  ///identified by the given [key]
  Stream<Map<String, dynamic>?> streamSingle(String key);
}
