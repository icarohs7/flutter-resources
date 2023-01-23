library core_resources;

import 'package:flutter/material.dart';

export 'package:build_context/build_context.dart';
export 'package:dartx/dartx.dart' hide Function0, Function1, Function2, Function3, Function4;
export 'package:dio/dio.dart';
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:hive_flutter/hive_flutter.dart';
export 'package:html_unescape/html_unescape.dart';
export 'package:http_parser/http_parser.dart';
export 'package:intl/date_symbol_data_local.dart';
export 'package:intl/intl.dart';
export 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
export 'package:rx_notifier/rx_notifier.dart';
export 'package:rxdart/rxdart.dart' hide Rx;
export 'package:url_launcher/url_launcher.dart';

export 'src/baseclasses/base_api_service.dart';
export 'src/baseclasses/base_router.dart';
export 'src/classes/core_router_observer.dart';
export 'src/database/base_repository.dart';
export 'src/database/hive_database.dart' hide HiveDatabase, HiveBoxAdapter;
export 'src/database/t_database.dart' hide JsonObject;
export 'src/extensions/async_snapshot_extensions.dart';
export 'src/extensions/color_extensions.dart';
export 'src/extensions/context_extensions.dart';
export 'src/extensions/dio_extensions.dart';
export 'src/extensions/execution_extensions.dart';
export 'src/extensions/future_extensions.dart';
export 'src/extensions/number_extensions.dart';
export 'src/extensions/object_extensions.dart';
export 'src/extensions/stream_extensions.dart';
export 'src/extensions/string_extensions.dart';
export 'src/extensions/time_extensions.dart';
export 'src/models/tuple.dart';
export 'src/utils/common_intents.dart';
export 'src/utils/date_time.dart';
export 'src/utils/dio.dart';
export 'src/utils/fade_page_route.dart';
export 'src/utils/field_masks.dart';
export 'src/utils/form_validation.dart';
export 'src/utils/hooks.dart';
export 'src/utils/json.dart';
export 'src/utils/log.dart';
export 'src/utils/math.dart';
export 'src/utils/nav.dart';
export 'src/utils/simple_search_delegate.dart';
export 'src/utils/ui.dart';
export 'src/utils/utils.dart';
export 'src/widgets/auto_complete_text_view.dart';
export 'src/widgets/conditional_render.dart';
export 'src/widgets/dialogs.dart';
export 'src/widgets/dismissible_and_editable_slidable.dart';
export 'src/widgets/dismissible_from_end_to_start.dart';
export 'src/widgets/editable_label.dart';
export 'src/widgets/loading_button.dart';
export 'src/widgets/number_stepper.dart';
export 'src/widgets/password_form_field.dart';
export 'src/widgets/refresh_action_button.dart';
export 'src/widgets/splash_widget.dart';
export 'src/widgets/transitions.dart';

typedef NavigationFunction = void Function(
  BuildContext context,
  String routeName, {
  Map<String, String>? params,
  Object? extra,
});

// ignore: avoid_classes_with_only_static_members
class Core {
  //region locator
  static late T Function<T extends Object>() _locator;

  /// Define the service locator used on some functions
  static void setLocator(T Function<T extends Object>() locator) => _locator = locator;

  static T get<T extends Object>() => _locator();

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
