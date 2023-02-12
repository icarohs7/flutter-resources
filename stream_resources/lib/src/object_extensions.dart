import 'package:rxdart/rxdart.dart';

extension SRObjectExtensions<T> on T {
  BehaviorSubject<T> get subject => BehaviorSubject.seeded(this);
}
