import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should filter list inside stream', () async {
    final s1 = Stream.value([1, 2, 3, 4]);
    final f1 = s1.innerFilter((e) => e % 2 == 0);
    expect(await f1.first, [2, 4]);

    final s2 = Stream.value(['Nani!?', 'Kono Dio Da!', 'I, Giorno Giovanna, have a Dream.']);
    final f2 = s2.innerFilter((e) => e.contains('Giorno'));
    expect(await f2.first, ['I, Giorno Giovanna, have a Dream.']);
  });

  test('should get first element of list inside stream', () async {
    final s1 = Stream.value([1532, 42, 99, 54]);
    final f1 = s1.innerFirst((e) => e % 2 != 0);
    expect(await f1.first, 99);

    final s2 = Stream.value(['Omai wa', 'mou', 'shindeiru!']);
    final f2 = s2.innerFirst((e) => e.startsWith('s'));
    expect(await f2.first, 'shindeiru!');
  });

  test('should collect stream into list', () async {
    final s1 = Stream.fromIterable([1, 2, 3, 4]);
    final f1 = s1.collect();
    expect(await f1.last, [1, 2, 3, 4]);

    final s2 = Stream.fromIterable(['Omae wa', 'mou', 'shindeiru!']);
    final f2 = s2.collect();
    expect(await f2.last, ['Omae wa', 'mou', 'shindeiru!']);
  });

  test('should collect stream into list with initial value', () async {
    final s1 = Stream.fromIterable([1, 2, 3, 4]);
    final f1 = s1.collectValue();
    expect(f1.value, equals(<int>[]));
    expect(await f1.last, [1, 2, 3, 4]);

    final s2 = Stream.fromIterable(['Omae wa', 'mou', 'shindeiru!']);
    final f2 = s2.collectValue();
    expect(f2.value, equals(<String>[]));
    expect(await f2.last, ['Omae wa', 'mou', 'shindeiru!']);
  });
}
