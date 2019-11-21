///Class wrapping a mutable value that, when changed,
///invokes the [onChange] property with the new value.
///Intended to be used on StatefulBuilder for StatelessWidgets
class StatefulWrapper<T> {
  StatefulWrapper({
    T value,
    this.onChange,
  }) : _value = value;

  T get value => _value;

  set value(T val) {
    _value = val;
    onChange?.call(val);
  }

  T _value;
  void Function(T newValue) onChange;
}
