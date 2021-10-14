import 'package:abstract_stringkey_db_resources/abstract_stringkey_db_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///Implementation of [AbstractTDatabase] using Firestore
///as the underlying engine.
///Implementation of [AbstractJsonDatabase] using Firestore

// ignore: non_constant_identifier_names
AbstractTDatabase<T> FirestoreTDatabase<T>({
  AbstractJsonDatabase? jsonDatabase,
  Future<CollectionReference<Map<String, dynamic>>>? collectionReference,
  required T Function(Map<String, dynamic>) adapter,
}) {
  assert(jsonDatabase != null || collectionReference != null);
  final dbImpl = jsonDatabase ?? FirestoreJsonDatabase(collectionReference!);
  return AbstractTDatabase(jsonDatabase: dbImpl, adapter: adapter);
}

///<br/> Either [jsonDatabase] or [dbName] must be defined
///as the underlying engine
// ignore: non_constant_identifier_names
AbstractJsonDatabase FirestoreJsonDatabase(
  Future<CollectionReference<Map<String, dynamic>>> collectionReference,
) {
  return FirestoreDatabase(collectionReference);
}

class FirestoreDatabase extends AbstractJsonDatabase {
  FirestoreDatabase(this.collectionReferecence);

  final Future<CollectionReference<Map<String, dynamic>>> collectionReferecence;

  @override
  Future<void> delete({String? key}) async {
    final ref = await collectionReferecence;
    if (key == null) {
      for (final doc in (await ref.get()).docs) {
        await doc.reference.delete();
      }
    } else {
      await ref.doc(key).delete();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    final ref = await collectionReferecence;
    final query = await ref.get();
    return query.docs.map((e) => e.data()).toList();
  }

  @override
  Future<Map<String, dynamic>?> getSingle(String key) async {
    final ref = await collectionReferecence;
    return (await ref.doc(key).get()).data();
  }

  @override
  Future<String> insert(Map<String, dynamic> item, {String? key}) async {
    final ref = await collectionReferecence;
    if (key == null) {
      final newRef = await ref.add(item);
      return newRef.id;
    } else {
      await ref.doc(key).set(item);
      return key;
    }
  }

  @override
  Future<void> insertAll(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await insert(item);
    }
  }

  @override
  Future<void> insertAllWithKeys(Map<String, Map<String, dynamic>> items) async {
    for (final entry in items.entries) {
      final key = entry.key;
      final item = entry.value;
      await insert(item, key: key);
    }
  }

  @override
  Future<void> replaceAll(List<Map<String, dynamic>> items) async {
    await delete();
    await insertAll(items);
  }

  @override
  Future<void> replaceAllWithKeys(Map<String, Map<String, dynamic>> items) async {
    await delete();
    await insertAllWithKeys(items);
  }

  @override
  Stream<List<Map<String, dynamic>>> streamAll() async* {
    final ref = await collectionReferecence;
    yield* ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Stream<Map<String, dynamic>?> streamSingle(String key) async* {
    final ref = await collectionReferecence;
    yield* ref.doc(key).snapshots().map((event) => event.data());
  }
}
