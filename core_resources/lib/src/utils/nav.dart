import 'package:flutter/material.dart';

import 'fade_page_route.dart';

/// Utility class to use Navigator methods using a shorter syntax
class Nav {
  Future<T?> goFullscreenDialog<T extends Object?>(BuildContext context, {required Widget page}) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => page, fullscreenDialog: true),
    );
  }

  Future<T?> goNamed<T>(BuildContext context, String route, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, route, arguments: arguments);
  }

  Future<T?> go<T>(
    BuildContext context, {
    required Widget page,
    Route<T> Function(Widget page)? routeBuilder,
  }) {
    return Navigator.push<T>(context, routeBuilder?.call(page) ?? FadePageRoute(page: page));
  }

  Future<T?> goReplacementNamed<T>(BuildContext context, String route, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, dynamic>(context, route, arguments: arguments);
  }

  Future<T?> goReplacement<T>(
    BuildContext context, {
    required Widget page,
    Route<T> Function(Widget page)? routeBuilder,
  }) {
    return Navigator.pushReplacement<T, dynamic>(
      context,
      routeBuilder?.call(page) ?? FadePageRoute(page: page),
    );
  }

  Future goErasingHistoryNamed(BuildContext context, String route) {
    return Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
  }

  Future goErasingHistory(
    BuildContext context, {
    required Widget page,
    Route Function(Widget page)? routeBuilder,
  }) {
    return Navigator.pushAndRemoveUntil(
      context,
      routeBuilder?.call(page) ?? FadePageRoute(page: page),
      (r) => false,
    );
  }

  static Nav get to => _instance;
  static final Nav _instance = Nav();
}
