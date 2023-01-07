typedef JsonObject = Map<String, dynamic>;

///Abstraction of database storing records
///as json objects in the form of
///Map<String, dynamic> objects
abstract class JsonDatabase {
  ///Store single item
  Future<int> insert(JsonObject item, {int? key});

  ///Store multiple items
  Future<void> insertAll(Iterable<JsonObject> items);

  ///Store multiple items associating ids to each
  Future<void> insertAllWithKeys(Map<int, JsonObject> items);

  ///Erase the database and insert values
  Future<void> replaceAll(Iterable<JsonObject> items);

  ///Erase the database and insert values using identifiers
  Future<void> replaceAllWithKeys(Map<int, JsonObject> items);

  ///Remove data, if [key] is defined, only the record
  ///identified will be deleted, otherwise erase all
  ///records
  Future<void> delete({int? key});

  ///Get a record identified by the given [key]
  Future<JsonObject?> getSingle(int key);

  ///Get all records stored
  Future<Iterable<JsonObject>> getAll();

  ///Stream of the latest records store
  Stream<Iterable<JsonObject>> streamAll();

  ///Stream of the latest version of a record
  ///identified by the given [key]
  Stream<JsonObject?> streamSingle(int key);
}
