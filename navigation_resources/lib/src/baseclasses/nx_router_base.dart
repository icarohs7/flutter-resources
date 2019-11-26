import 'package:core_resources/core_resources.dart';
import 'package:flutter/widgets.dart';
import 'package:navigation_resources/navigation_resources.dart';

class NxRouterBase {
  ///Shorthand to [go] with named route
  Future<T> goNamed<T>(BuildContext context, String route) {
    return go(context, namedRoute: route);
  }

  Future<T> go<T>(
    BuildContext context, {
    String namedRoute,
    Widget page,
    Route<T> Function(Widget page) routeBuilder,
    Route<T> route,
  }) {
    if (namedRoute != null) {
      return Navigator.pushNamed<T>(context, namedRoute);
    } else if (page != null) {
      return Navigator.push<T>(context, routeBuilder?.invoke(page) ?? FadePageRoute(page: page));
    } else if (route != null) {
      return Navigator.push<T>(context, route);
    }
    throw ArgumentError("namedRoute, page or route must be defined");
  }

  ///Shorthand to [goReplacement] with named route
  Future<T> goReplacementNamed<T>(BuildContext context, String route) {
    return goReplacement(context, namedRoute: route);
  }

  Future<T> goReplacement<T>(
    BuildContext context, {
    String namedRoute,
    Widget page,
    Route<T> Function(Widget page) routeBuilder,
    Route<T> route,
  }) {
    if (namedRoute != null) {
      return Navigator.pushReplacementNamed<T, dynamic>(context, namedRoute);
    } else if (page != null) {
      return Navigator.pushReplacement<T, dynamic>(
        context,
        routeBuilder?.invoke(page) ?? FadePageRoute(page: page),
      );
    } else if (route != null) {
      return Navigator.pushReplacement<T, dynamic>(context, route);
    }
    throw ArgumentError("namedRoute, page or route must be defined");
  }

  static NxRouterBase get to => _instance;
  static final NxRouterBase _instance = NxRouterBase();
}
