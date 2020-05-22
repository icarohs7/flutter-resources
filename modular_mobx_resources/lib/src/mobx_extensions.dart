import 'package:mobx/mobx.dart';

extension ObservableExtensions<T> on Observable<T> {
  ///Updates the value of the observable and notify
  ///its observers using an action
  void update(T value) => runInAction(() => this.value = value);
}
