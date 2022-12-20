import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

/// A [NavigatorObserver] that notifies when the current route changes
/// through its [stream]
class CoreRouterObserver extends NavigatorObserver {
  static final _subject = BehaviorSubject<CoreRoute?>.seeded(null);
  static final ValueStream<CoreRoute?> stream = _subject.stream;

  @override
  void didPush(Route route, Route? previousRoute) =>
      update(route: route, previousRoute: previousRoute);

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) =>
      update(route: newRoute, previousRoute: oldRoute);

  @override
  void didRemove(Route route, Route? previousRoute) =>
      update(route: previousRoute, previousRoute: previousRoute);

  @override
  void didPop(Route route, Route? previousRoute) =>
      update(route: previousRoute, previousRoute: previousRoute);

  void update({Route? route, Route? previousRoute}) {
    if (route == null) return;
    _subject.add(CoreRoute(currentRoute: route, previousRoute: previousRoute));
  }
}

/// A [Route] wrapper that contains the current and previous route.
/// To be replaced by tuples in the future
class CoreRoute {
  final Route currentRoute;
  final Route? previousRoute;

  const CoreRoute({required this.currentRoute, this.previousRoute});

  @override
  String toString() {
    return 'CoreRoute{currentRoute: $currentRoute, previousRoute: $previousRoute}';
  }

  @override
  bool operator ==(covariant CoreRoute other) =>
      identical(this, other) ||
      (currentRoute == other.currentRoute && previousRoute == other.previousRoute);

  @override
  int get hashCode => currentRoute.hashCode ^ previousRoute.hashCode;
}
