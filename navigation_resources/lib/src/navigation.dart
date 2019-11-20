import 'package:flutter/material.dart';
import 'package:navigation_resources/navigation_resources.dart';

class Navigation {
  static Future<T> pushFade<T>(BuildContext context, {Widget destination}) {
    return Navigator.of(context).push<T>(FadePageRoute(page: destination));
  }

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

  static Future<T> pushReplacementFade<T>(BuildContext context, {Widget destination}) {
    return Navigator.of(context).pushReplacement<T, dynamic>(FadePageRoute(page: destination));
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
