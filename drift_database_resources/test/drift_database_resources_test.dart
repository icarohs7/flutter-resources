import 'package:drift_database_resources/drift_database_resources.dart';
import 'package:drift_database_resources/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _TestDatabase database;

  setUp(() {
    database = _TestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  test('converts JSON-backed values to and from SQL', () {
    const converter = _MapConverter();

    expect(converter.toSql({'name': 'Ada'}), '{"name":"Ada"}');
    expect(converter.fromSql('{"name":"Ada"}'), {'name': 'Ada'});
  });

  test('maps database operation failures with the supplied mapper', () async {
    final result = await database
        .tryRun<String, String>(
          () => throw StateError('database unavailable'),
          onError: (error, _) => error.toString(),
        )
        .run();

    expect(result.match((failure) => failure, (value) => value), 'Bad state: database unavailable');
  });

  test('returns Unit after a successful batch', () async {
    var called = false;

    final result = await database.tryBatch<String>((_) {
      called = true;
    }, onError: (error, _) => error.toString()).run();

    expect(called, isTrue);
    expect(result.match((failure) => failure, (value) => value), unit);
  });

  test('maps selectable failures and returns rows on success', () async {
    final selectable = _TestSelectable();
    final singleSelectable = _SingleSelectable();

    final rows = await selectable.tryGet<String>(onError: (error, _) => error.toString()).run();
    final row = await singleSelectable
        .tryGetSingle<String>(onError: (error, _) => error.toString())
        .run();

    expect(rows.match((failure) => failure, (value) => value), [1, 2]);
    expect(row.match((failure) => failure, (value) => value), 1);
  });
}

class const _MapConverter() extends DriftJsonConverter<Map<String, dynamic>> {
  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => json;
}

final class _TestDatabase() extends GeneratedDatabase {
  this : super(NativeDatabase.memory());

  @override
  Iterable<TableInfo> get allTables => const [];

  @override
  int get schemaVersion => 1;
}

final class _TestSelectable() extends Selectable<int> {
  @override
  Future<List<int>> get() async => [1, 2];

  @override
  Stream<List<int>> watch() => Stream.value([1, 2]);
}

final class _SingleSelectable() extends Selectable<int> {
  @override
  Future<List<int>> get() async => [1];

  @override
  Stream<List<int>> watch() => Stream.value([1]);
}
