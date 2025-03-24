import 'package:flutter/material.dart';

typedef NavigationFunction = void Function(
  BuildContext context,
  String routeName, {
  Map<String, String>? params,
  Object? extra,
});

// ignore: avoid_classes_with_only_static_members
class Core {
  //region locator
  static late T Function<T extends Object>({String? instanceName}) _locator;

  /// Define the service locator used on some functions
  static void setLocator(T Function<T extends Object>({String? instanceName}) locator) =>
      _locator = locator;

  static T get<T extends Object>({String? instanceName}) => _locator(instanceName: instanceName);

  //endregion

  //region push
  static late NavigationFunction _pushNavigator;

  /// Define the function that will be used to push the given route into the navigator,
  /// used by other libraries to reuse navigation functions
  static void setPushFn(NavigationFunction fn) => _pushNavigator = fn;

  static void push(
    BuildContext context,
    String routeName, {
    Map<String, String>? params,
    Object? extra,
  }) {
    _pushNavigator(context, routeName, params: params, extra: extra);
  }

  //endregion

  //region go
  static late NavigationFunction _goNavigator;

  /// Define the function that will be used to navigate to the given route into the navigator,
  /// used by other libraries to reuse navigation functions
  static void setGoFn(NavigationFunction fn) => _goNavigator = fn;

  static void go(
    BuildContext context,
    String routeName, {
    Map<String, String>? params,
    Object? extra,
  }) {
    _goNavigator(context, routeName, params: params, extra: extra);
  }

  //endregion

  //region replace
  static late NavigationFunction _replaceNavigator;

  /// Define the function that will be used to replace the current route in the navigator,
  /// used by other libraries to reuse navigation functions
  static void setReplaceFn(NavigationFunction fn) => _replaceNavigator = fn;

  static void replace(
    BuildContext context,
    String routeName, {
    Map<String, String>? params,
    Object? extra,
  }) {
    _replaceNavigator(context, routeName, params: params, extra: extra);
  }

  //endregion

  //region replaceAll
  static late NavigationFunction _replaceAllNavigator;

  /// Define the function that will be used to replace all the routes in the navigator,
  /// used by other libraries to reuse navigation functions
  static void setReplaceAllFn(NavigationFunction fn) => _replaceAllNavigator = fn;

  static void replaceAll(
    BuildContext context,
    String routeName, {
    Map<String, String>? params,
    Object? extra,
  }) {
    _replaceAllNavigator(context, routeName, params: params, extra: extra);
  }

  //endregion

  //region back
  static void Function(BuildContext context, [Object? result]) _back =
      (BuildContext context, [Object? result]) => Navigator.of(context).pop(result);

  /// Define the function that will be used to pop the current route in the navigator,
  /// used by other libraries to reuse navigation functions
  static void setBackFn(void Function(BuildContext context, [Object? result]) fn) => _back = fn;

  static void back(BuildContext context, [Object? result]) => _back(context, result);

  //endregion

  //region currentPath
  static late String Function(BuildContext context) _currentPath;

  /// Define the function that will be used to get the current path
  static void setCurrentPathFn(String Function(BuildContext context) fn) => _currentPath = fn;

  static String currentPath(BuildContext context) => _currentPath(context);

  //endregion

  //region currentParams
  static late Map<String, String> Function(BuildContext context) _currentParams;

  /// Define the function that will be used to get the current route params
  static void setCurrentParamsFn(Map<String, String> Function(BuildContext context) fn) =>
      _currentParams = fn;

  static Map<String, String> currentParams(BuildContext context) => _currentParams(context);

  //endregion

  //region currentExtras
  static late Object? Function(BuildContext context) _currentExtras;

  /// Define the function that will be used to get the current route extras
  static void setCurrentExtrasFn(Object? Function(BuildContext context) fn) => _currentExtras = fn;

  static Object? currentExtras(BuildContext context) => _currentExtras(context);
//endregion
}
