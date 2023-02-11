import 'package:flutter/foundation.dart';

typedef _Builder<T> = T Function(_Ref ref);

/// Merge many [ValueListenable] objects using a builder
///
/// The resulting [Listenable] will update any time one of
/// the listenables used to build it update
///
/// example:
/// ```dart
/// final nameListenable = ValueNotifier('Icaro');
/// final ageListenable = ValueNotifier(25);
///
/// final personListenable = computedValueListenable((ref) {
///   final name = ref.watch(nameListenable);
///   final age = ref.watch(ageListenable);
///
///   return Person(
///     name: name,
///     age: age,
///   );
/// });
/// ```
ValueListenable<T> computedValueListenable<T>(_Builder<T> builder) {
  final listenables = <Listenable>[];
  final ref = _Ref(listenables.add);
  return _MultiValueNotifier(builder(ref), listenables: listenables, builder: builder);
}

class _MultiValueNotifier<T> extends ValueNotifier<T> {
  late final Listenable _listenable;
  final _Builder<T> builder;

  final ref = _Ref();

  _MultiValueNotifier(
    super._value, {
    required List<Listenable> listenables,
    required this.builder,
  }) {
    _listenable = Listenable.merge(listenables);
    _listenable.addListener(onUpdate);
  }

  @override
  T get value => builder(ref);

  R subscribe<R>(ValueListenable<R> notifier) => notifier.value;

  void onUpdate() => value = builder(ref);

  @override
  void dispose() {
    super.dispose();
    _listenable.removeListener(onUpdate);
  }
}

class _Ref {
  final void Function(Listenable)? _watchHandler;

  const _Ref([this._watchHandler]);

  R watch<R>(ValueListenable<R> notifier) {
    _watchHandler?.call(notifier);
    return notifier.value;
  }
}
