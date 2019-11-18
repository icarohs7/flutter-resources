import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

TransitionType _defaultTransition = TransitionType.fadeIn;

extension RouterExtensions on Router {
  void setDefaultTransition(TransitionType transition) {
    _defaultTransition = transition;
  }

  void addRoute(
    String routePath, {
    Widget destination,
    HandlerFunc handlerFunc,
    Handler handler,
    TransitionType transition,
  }) {
    define(
      routePath,
      handler: handler ?? Handler(handlerFunc: handlerFunc ?? (_, __) => destination),
      transitionType: transition ?? _defaultTransition,
    );
  }
}
