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

  bool initialized = false;

  _MultiValueNotifier(
    super._value, {
    required List<Listenable> listenables,
    required this.builder,
  }) : _listenable = Listenable.merge(listenables);

  @override
  T get value => builder(ref);

  void onUpdate() => value = builder(ref);

  @override
  void addListener(VoidCallback listener) {
    if (!initialized) {
      _listenable.addListener(onUpdate);
      initialized = true;
    }
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      _listenable.removeListener(onUpdate);
      initialized = false;
    }
  }

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
