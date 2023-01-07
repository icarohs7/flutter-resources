import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await Hive.initFlutter();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('database');
    await Hive.close();
  });

  test('insert and get', () async {
    final db = createDb();
    final key = await db.insert(MockModel(id: 1, description: 'test'), key: 1);
    final item = await db.getSingle(key);
    expect(item, MockModel(id: 1, description: 'test'));
  });

  test('insertAll and getAll', () async {
    final db = createDb();
    await db.insertAll([
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    final items = await db.getAll();
    expect(items, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
  });

  test('insertAllWithKeys', () async {
    final db = createDb();
    await db.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    final items = await db.getAll();
    expect(items, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    final item2 = await db.getSingle(2);
    expect(item2, MockModel(id: 2, description: 'test2'));
  });

  test('replaceAll', () async {
    final db = createDb();
    await db.insertAll([
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    final items0 = await db.getAll();
    expect(items0, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    await db.replaceAll([
      MockModel(id: 3, description: 'test3'),
      MockModel(id: 4, description: 'test4'),
    ]);
    final items = await db.getAll();
    expect(items, [
      MockModel(id: 3, description: 'test3'),
      MockModel(id: 4, description: 'test4'),
    ]);
  });

  test('replaceAllWithKeys', () async {
    final db = createDb();
    await db.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    final items0 = await db.getAll();
    expect(items0, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    await db.replaceAllWithKeys({
      1: MockModel(id: 3, description: 'test3'),
      2: MockModel(id: 4, description: 'test4'),
    });
    final items = await db.getAll();
    expect(items, [
      MockModel(id: 3, description: 'test3'),
      MockModel(id: 4, description: 'test4'),
    ]);
    final item3 = await db.getSingle(1);
    expect(item3, MockModel(id: 3, description: 'test3'));
  });

  test('delete', () async {
    final db = createDb();
    await db.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    final items0 = await db.getAll();
    expect(items0, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    await db.delete(key: 1);
    final items = await db.getAll();
    expect(items, [
      MockModel(id: 2, description: 'test2'),
    ]);
    await db.delete();
    final items2 = await db.getAll();
    expect(items2, []);
  });

  test('streamAll', () async {
    final db = createDb();
    final stream = db.streamAll();
    await db.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    expect(
      stream,
      emits([MockModel(id: 1, description: 'test'), MockModel(id: 2, description: 'test2')]),
    );
  });

  test('streamSingle', () async {
    final db = createDb();
    final stream = db.streamSingle(1);
    await db.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    expect(
      stream,
      emits(MockModel(id: 1, description: 'test')),
    );
  });
}

TDatabase<MockModel> createDb() {
  return HiveTDatabase<MockModel>(dbName: 'database', adapter: (e) => MockModel.fromJson(e));
}

class MockModel {
  final int id;
  final String description;

//<editor-fold desc="Data Methods">

  const MockModel({
    required this.id,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MockModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description);

  @override
  int get hashCode => id.hashCode ^ description.hashCode;


  @override
  String toString() => 'MockModel{id: $id, description: $description}';

  MockModel copyWith({
    int? id,
    String? description,
  }) {
    return MockModel(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
    };
  }

  factory MockModel.fromJson(Map<String, dynamic> map) {
    return MockModel(
      id: map['id'] as int,
      description: map['description'] as String,
    );
  }

//</editor-fold>
}
