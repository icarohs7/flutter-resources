typedef JsonObject = Map<String, dynamic>;

/// Database storing objects of type [T]
abstract class TDatabase<T> {
  ///Insert single item
  Future<int> insert(T item, {int? key});

  ///Insert items
  Future<void> insertAll(Iterable<T> items);

  ///Insert items using specific keys for each
  Future<void> insertAllWithKeys(Map<int, T> items);

  ///Erase the database and insert items
  Future<void> replaceAll(Iterable<T> items);

  ///Erase the database and insert items using specific keys for each
  Future<void> replaceAllWithKeys(Map<int, T> items);

  ///Remove the given item from the database
  Future<void> delete(int key);

  //Erase the database
  Future<void> deleteAll();

  ///Get a record identified by the given [key]
  Future<T?> getSingle(int key);

  ///Get all records stored
  Future<Iterable<T>> getAll();

  ///Stream of the latest records store
  Stream<Iterable<T>> streamAll();

  ///Stream of the latest version of a record
  ///identified by the given [key]
  Stream<T?> streamSingle(int key);
}
