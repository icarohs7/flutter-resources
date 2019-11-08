import 'package:flutter/material.dart';

class Navigation {
  static Future<T> push<T>(
    BuildContext context, {
    Widget Function(BuildContext context) builder,
    Widget destination,
    bool fullscreenDialog = false,
  }) {
    return Navigator.of(context).push<T>(MaterialPageRoute(
      builder: builder ?? (_) => destination,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  static Future<T> pushReplacement<T>(
    BuildContext context, {
    Widget Function(BuildContext context) builder,
    Widget destination,
    bool fullscreenDialog = false,
  }) {
    return Navigator.of(context).pushReplacement<T, dynamic>(MaterialPageRoute(
      builder: builder ?? (_) => destination,
      fullscreenDialog: fullscreenDialog,
    ));
  }
}
