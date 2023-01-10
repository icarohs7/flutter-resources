import 't_database.dart';

class BaseRepository<T> implements TDatabase<T> {
  BaseRepository({required this.db});

  final TDatabase<T> db;

  ///Insert single item
  @override
  Future<int> insert(T item, {int? key}) => db.insert(item, key: key);

  ///Insert items
  @override
  Future<void> insertAll(Iterable<T> items) => db.insertAll(items);

  ///Insert items using specific keys for each
  @override
  Future<void> insertAllWithKeys(Map<int, T> items) => db.insertAllWithKeys(items);

  ///Erase the database and insert items
  @override
  Future<void> replaceAll(Iterable<T> items) => db.replaceAll(items);

  ///Erase the database and insert items using specific keys for each
  @override
  Future<void> replaceAllWithKeys(Map<int, T> items) => db.replaceAllWithKeys(items);

  ///Remove the given item from the database
  @override
  Future<void> delete(int key) => db.delete(key);

  //Erase the database
  @override
  Future<void> deleteAll() => db.deleteAll();

  ///Get a record identified by the given [key]
  @override
  Future<T?> getSingle(int key) => db.getSingle(key);

  ///Get all records stored
  @override
  Future<Iterable<T>> getAll() => db.getAll();

  ///Stream of the latest records store
  @override
  Stream<Iterable<T>> streamAll() => db.streamAll();

  ///Stream of the latest version of a record
  ///identified by the given [key]
  @override
  Stream<T?> streamSingle(int key) => db.streamSingle(key);
}
