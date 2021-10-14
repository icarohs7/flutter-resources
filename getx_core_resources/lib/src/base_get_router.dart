import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

mixin BaseGetRouter {
  Future<T?>? go<T>(String route, {Object? arguments}) {
    return Get.toNamed<T>(route, arguments: arguments);
  }

  Future<T?>? goReplacement<T>(String route, {Object? arguments}) {
    return Get.offNamed(route, arguments: arguments);
  }

  Future<T?>? goClearingBackstack<T>(String route, {Object? arguments}) {
    return Get.offAllNamed(route, arguments: arguments);
  }

  Future<T?>? goAndRemoveUntil<T>(
    String route,
    bool Function(Route<dynamic> route) predicate, {
    Object? arguments,
  }) {
    return Get.offNamedUntil(route, predicate, arguments: arguments);
  }

  List<String> get bottomNavRoutes => [];

  /// The index of the curent route in the
  /// [bottomNavRoutes] list, or null if
  /// it isn't a registered route
  int? currentBottomNavIndex(BuildContext context) {
    final routeName = Get.currentRoute;
    final index = bottomNavRoutes.indexOf(routeName);
    return index != -1 ? index : null;
  }
}
