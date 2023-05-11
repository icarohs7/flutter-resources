import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:value_notifier_resources/value_notifier_resources.dart';

void main() {
  test('computed listenable initial value', () {
    //arrange
    final nameNotifier = ValueNotifier('Icaro');
    final ageNotifier = ValueNotifier(25);
    //act
    final personNotifier = computedValueListenable((ref) {
      final name = ref.watch(nameNotifier);
      final age = ref.watch(ageNotifier);

      return [name, age];
    });
    //assert
    expect(personNotifier.value, ['Icaro', 25]);
  });

  test('computed listenable value change without listening', () async {
    //arrange
    final v1 = ValueNotifier(10);
    final v2 = ValueNotifier(20);
    final sumNotifier = computedValueListenable((ref) => ref.watch(v1) + ref.watch(v2));
    //act
    v1.value = 15;
    v2.value = 45;
    //assert
    expect(sumNotifier.value, 60);
  });

  test('computed listenable emits when its children emit', () async {
    //arrange
    final nameNotifier = ValueNotifier('Icaro');
    final ageNotifier = ValueNotifier(25);
    final personNotifier = computedValueListenable((ref) {
      final name = ref.watch(nameNotifier);
      final age = ref.watch(ageNotifier);

      return [name, age];
    });

    var events = 0;
    listener() => events++;
    personNotifier.addListener(listener);
    //act
    nameNotifier.value = 'Daniel';
    //assert
    expect(events, 1);
    expect(personNotifier.value, ['Daniel', 25]);

    //act
    nameNotifier.value = 'Icaro';
    ageNotifier.value = 26;
    //assert
    expect(events, 3);
    expect(personNotifier.value, ['Icaro', 26]);

    personNotifier.removeListener(listener);
  });

  test('listener is disposed', () {
    //arrange
    final notifier1 = ValueNotifier(10);
    final notifier2 = ValueNotifier(20);
    final computed = computedValueListenable<int>((ref) {
      return ref.watch(notifier1) + ref.watch(notifier2);
    });
    var count = 0;
    var lastEmission = 0;
    final sub = computed.listen((v, _) {
      count++;
      lastEmission = v;
    });
    //assert
    expect(count, 0);
    expect(lastEmission, 0);
    expect(computed.value, 30);

    //act
    notifier1.value = 95;
    //assert
    expect(count, 1);
    expect(lastEmission, 115);
    expect(computed.value, 115);

    //act
    (computed as ValueNotifier).dispose();
    notifier2.value = 30;
    //assert
    expect(count, 1);
    expect(lastEmission, 115);
    expect(computed.value, 125);

    sub.cancel();
  });
}
