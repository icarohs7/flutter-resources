import 'package:flutter/material.dart';

import '../../core_resources.dart';

mixin BaseRouter {
  void go(BuildContext context, String route, {Map<String, String>? params, Object? extra}) {
    Core.goNamed(context, route, params: params, extra: extra);
  }

  void replace(BuildContext context, String route, {Map<String, String>? params, Object? extra}) {
    Core.replaceNamed(context, route, params: params, extra: extra);
  }

  void replaceAll(
    BuildContext context,
    String route, {
    Map<String, String>? params,
    Object? extra,
  }) {
    Core.replaceAllNamed(context, route, params: params, extra: extra);
  }

  List<String> get bottomNavRoutes => [];

  /// The index of the curent route in the
  /// [bottomNavRoutes] list, or null if
  /// it isn't a registered route
  int? currentBottomNavIndex(BuildContext context) {
    final routeName = Core.currentPath(context);
    final index = bottomNavRoutes.indexOf(routeName);
    return index != -1 ? index : null;
  }
}
