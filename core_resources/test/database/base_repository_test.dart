import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks.dart';
import 'hive_database_test.dart';

void main() {
  setUp(() async => await startHiveWithMockDirectory());
  tearDown(() async => await Hive.close());

  MockRepository createRepository() => MockRepository();

  test('insert and get', () async {
    final repo = createRepository();
    final key = await repo.insert(MockModel(id: 1, description: 'test'), key: 1);
    final item = await repo.getSingle(key);
    expect(item, MockModel(id: 1, description: 'test'));
  });

  test('insertAll and getAll', () async {
    final repo = createRepository();
    await repo.insertAll([
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    final items = await repo.getAll();
    expect(items, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
  });

  test('insertAllWithKeys', () async {
    final repo = createRepository();
    await repo.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    final items = await repo.getAll();
    expect(items, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    final item2 = await repo.getSingle(2);
    expect(item2, MockModel(id: 2, description: 'test2'));
  });

  test('replaceAll', () async {
    final repo = createRepository();
    await repo.insertAll([
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    final items0 = await repo.getAll();
    expect(items0, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    await repo.replaceAll([
      MockModel(id: 3, description: 'test3'),
      MockModel(id: 4, description: 'test4'),
    ]);
    final items = await repo.getAll();
    expect(items, [
      MockModel(id: 3, description: 'test3'),
      MockModel(id: 4, description: 'test4'),
    ]);
  });

  test('replaceAllWithKeys', () async {
    final repo = createRepository();
    await repo.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    final items0 = await repo.getAll();
    expect(items0, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    await repo.replaceAllWithKeys({
      1: MockModel(id: 3, description: 'test3'),
      2: MockModel(id: 4, description: 'test4'),
    });
    final items = await repo.getAll();
    expect(items, [
      MockModel(id: 3, description: 'test3'),
      MockModel(id: 4, description: 'test4'),
    ]);
    final item3 = await repo.getSingle(1);
    expect(item3, MockModel(id: 3, description: 'test3'));
  });

  test('delete and clear', () async {
    final repo = createRepository();
    await repo.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    final items0 = await repo.getAll();
    expect(items0, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    await repo.delete(1);
    final items = await repo.getAll();
    expect(items, [
      MockModel(id: 2, description: 'test2'),
    ]);
    await repo.deleteAll();
    final items2 = await repo.getAll();
    expect(items2, []);
    await repo.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    final items3 = await repo.getAll();
    expect(items3, [
      MockModel(id: 1, description: 'test'),
      MockModel(id: 2, description: 'test2'),
    ]);
    await repo.deleteAll();
    final items4 = await repo.getAll();
    expect(items4, []);
  });

  test('streamAll', () async {
    final repo = createRepository();
    final stream = repo.streamAll();
    await repo.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    expect(
      stream,
      emits([MockModel(id: 1, description: 'test'), MockModel(id: 2, description: 'test2')]),
    );
  });

  test('streamSingle', () async {
    final repo = createRepository();
    final stream = repo.streamSingle(1);
    await repo.insertAllWithKeys({
      1: MockModel(id: 1, description: 'test'),
      2: MockModel(id: 2, description: 'test2'),
    });
    expect(
      stream,
      emits(MockModel(id: 1, description: 'test')),
    );
  });
}

class MockRepository extends BaseRepository<MockModel> {
  MockRepository() : super(db: createDb());

  @override
  Future<int> insert(MockModel item, {int? key}) async {
    final id = key ?? item.id;
    return super.insert(item.copyWith(id: id), key: id);
  }
}
