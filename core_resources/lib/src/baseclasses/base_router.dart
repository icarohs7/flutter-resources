import 'package:flutter/material.dart';

import '../../core_resources.dart';

mixin BaseRouter {
  void push(BuildContext context, String route, {Map<String, String>? params, Object? extra}) {
    Core.push(context, route, params: params, extra: extra);
  }

  void go(BuildContext context, String route, {Map<String, String>? params, Object? extra}) {
    Core.go(context, route, params: params, extra: extra);
  }

  void replace(BuildContext context, String route, {Map<String, String>? params, Object? extra}) {
    Core.replace(context, route, params: params, extra: extra);
  }

  void replaceAll(
    BuildContext context,
    String route, {
    Map<String, String>? params,
    Object? extra,
  }) {
    Core.replaceAll(context, route, params: params, extra: extra);
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

  void pushToBottomNavRoute(BuildContext context, int index) {
    push(context, bottomNavRoutes[index]);
  }

  void goToBottomNavRoute(BuildContext context, int index) {
    go(context, bottomNavRoutes[index]);
  }

  void replaceToBottomNavRoute(BuildContext context, int index) {
    replace(context, bottomNavRoutes[index]);
  }

  void replaceAllToBottomNavRoute(BuildContext context, int index) {
    replaceAll(context, bottomNavRoutes[index]);
  }
}
