import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firestore_db_resources/firestore_db_resources.dart';
@TestOn('vm')
import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_void_async
void main() async {
  final db = await createDb();

  await db.delete();
  group('insert and get', () {
    test('insert', () async {
      final id1 = await db.insert({'name': 'Icaro'});
      final id2 = await db.insert({'name': 'Patrick'});

      expect(id1.isNotBlank, true);
      expect(id2.isNotBlank, true);
    });

    test('get all', () async {
      final items = await db.getAll();
      expect(items.length, equals(2));
      expect(items[0], equals({'name': 'Icaro'}));
      expect(items[1], equals({'name': 'Patrick'}));
    });

    test('insert all', () async {
      await db.insertAll([
        {'anime': 'ID: Invaded'},
        {'anime': 'Kiseijuu sei no kakuritsu'}
      ]);
      final items2 = await db.getAll();
      expect(items2.length, equals(4));
      expect(items2[2], equals({'anime': 'ID: Invaded'}));
      expect(items2[3], equals({'anime': 'Kiseijuu sei no kakuritsu'}));
    });

    test('get single item', () async {
      final key = await db.insert({'age': 21});

      final retrieved = await db.getSingle(key);
      expect(retrieved, equals({'age': 21}));
    });
  });

  group('replace and delete', () {
    test('replace all', () async {
      await db.delete();
      await db.insertAll([
        {'a': 'b'},
        {'c': 'd'}
      ]);
      final items = await db.getAll();
      expect(items.length, equals(2));
      expect(
        items,
        containsAll([
          {'a': 'b'},
          {'c': 'd'},
        ]),
      );

      await db.replaceAll([
        {'message': 'Kono Giorno Giovanna niwa yume ga aru'}
      ]);
      final items2 = await db.getAll();
      expect(items2.length, equals(1));
      expect(
        items2,
        containsAll([
          {'message': 'Kono Giorno Giovanna niwa yume ga aru'}
        ]),
      );
    });

    test('delete single', () async {
      await db.delete();
      final k1 = await db.insert({'message': 'omai wa mou, shindeiru'});
      await db.insert({'message': 'nani'});
      await db.insert({'message': 'kono Dio da!'});
      expect((await db.getAll()).length, equals(3));
      await db.delete(key: k1);
    });

    test('delete all', () async {
      final items = await db.getAll();
      expect(items, isNot(contains({'message': 'omai wa mou, shindeiru'})));
      expect(items.length, equals(2));
    });
  });

  group('streams', () {
    test('stream all', () async {
      await db.delete();
      await db.insert({'feeling': 'lazy'});
      await db.insert({'number': '15'});
      expect(
        db.streamAll(),
        emits([
          {'feeling': 'lazy'},
          {'number': '15'}
        ]),
      );
    });
  });
}

Future<AbstractJsonDatabase> createDb() async {
  final mockDb = FakeFirebaseFirestore();
  return FirestoreJsonDatabase(Future(() => mockDb.collection('test_collection')));
}
