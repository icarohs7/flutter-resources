library core_resources;

import 'package:flutter/material.dart';

export 'package:async/async.dart';
export 'package:build_context/build_context.dart';
export 'package:dartx/dartx.dart' hide Function0, Function1, Function2, Function3, Function4;
export 'package:dio/dio.dart';
export 'package:enhanced_future_builder/enhanced_future_builder.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:hive_flutter/hive_flutter.dart';
export 'package:http_parser/http_parser.dart';
export 'package:intl/date_symbol_data_local.dart';
export 'package:intl/intl.dart';
export 'package:rxdart/rxdart.dart' hide Rx;
export 'package:transparent_image/transparent_image.dart';

export 'src/baseclasses/abstract_json_database.dart';
export 'src/baseclasses/abstract_t_database.dart';
export 'src/baseclasses/base_api_service.dart';
export 'src/baseclasses/base_repository.dart';
export 'src/classes/rx_list.dart';
export 'src/extensions/color_extensions.dart';
export 'src/extensions/context_extensions.dart';
export 'src/extensions/execution_extensions.dart';
export 'src/extensions/future_extensions.dart';
export 'src/extensions/number_extensions.dart';
export 'src/extensions/object_extensions.dart';
export 'src/extensions/stream_extensions.dart';
export 'src/extensions/string_extensions.dart';
export 'src/extensions/time_extensions.dart';
export 'src/hive_database.dart' hide HiveDatabase;
export 'src/hive_db_resources.dart';
export 'src/models/try.dart';
export 'src/models/tuple.dart';
export 'src/utils/common_intents.dart';
export 'src/utils/date_time.dart';
export 'src/utils/dio.dart';
export 'src/utils/fade_page_route.dart';
export 'src/utils/form_validation.dart';
export 'src/utils/json.dart';
export 'src/utils/log.dart';
export 'src/utils/math.dart';
export 'src/utils/nav.dart';
export 'src/utils/simple_search_delegate.dart';
export 'src/utils/ui.dart';
export 'src/utils/utils.dart';
export 'src/utils/widgets.dart';
export 'src/widgets/auto_complete_text_view.dart';
export 'src/widgets/column_with_padded_children.dart';
export 'src/widgets/conditional_render.dart';
export 'src/widgets/dialogs.dart';
export 'src/widgets/dismissible_and_editable_slidable.dart';
export 'src/widgets/dismissible_from_end_to_start.dart';
export 'src/widgets/editable_label.dart';
export 'src/widgets/fade_in_and_loading_network_image.dart';
export 'src/widgets/future_loading_raised_button.dart';
export 'src/widgets/hero_text.dart';
export 'src/widgets/list_view_with_padded_children.dart';
export 'src/widgets/loading_button.dart';
export 'src/widgets/number_stepper.dart';
export 'src/widgets/password_form_field.dart';
export 'src/widgets/refresh_action_button.dart';
export 'src/widgets/row_with_padded_children.dart';
export 'src/widgets/splash_widget.dart';
export 'src/widgets/transitions.dart';

// ignore: avoid_classes_with_only_static_members
class Core {
  //region locator
  static late T Function<T extends Object>() _locator;

  /// Define the service locator used on some functions
  static void setLocator(T Function<T extends Object>() locator) => _locator = locator;

  static T get<T extends Object>() => _locator();

  //endregion

  //region replaceAllNamedNavigator
  static late void Function(
    BuildContext context,
    String routeName, {
    Map<String, String>? params,
  }) _replaceAllNamedNavigator;

  /// Define the function that will be used to replace all the routes in the navigator,
  /// used by other libraries to reuse navigation functions
  static void setReplaceAllNamedFn(
    void Function(BuildContext context, String routeName, {Map<String, String>? params}) fn,
  ) {
    _replaceAllNamedNavigator = fn;
  }

  void replaceAllNamed(BuildContext context, String routeName, {Map<String, String>? params}) {
    _replaceAllNamedNavigator(context, routeName);
  }

  //endregion

  //region replaceNamedNavigator
  static late void Function(
    BuildContext context,
    String routeName, {
    Map<String, String>? params,
  }) _replaceNamedNavigator;

  /// Define the function that will be used to replace the current route in the navigator,
  /// used by other libraries to reuse navigation functions
  static void setReplaceNamedFn(
    void Function(BuildContext context, String routeName, {Map<String, String>? params}) fn,
  ) {
    _replaceNamedNavigator = fn;
  }

  void replaceNamed(BuildContext context, String routeName, {Map<String, String>? params}) {
    _replaceNamedNavigator(context, routeName);
  }

  //endregion

  //region goNamedNavigator
  static late void Function(
    BuildContext context,
    String routeName, {
    Map<String, String>? params,
  }) _goNamedNavigator;

  /// Define the function that will be used to push the given route into the navigator,
  /// used by other libraries to reuse navigation functions
  static void setGoNamedFn(
    void Function(BuildContext context, String routeName, {Map<String, String>? params}) fn,
  ) {
    _goNamedNavigator = fn;
  }

  void goNamed(BuildContext context, String routeName, {Map<String, String>? params}) {
    _goNamedNavigator(context, routeName);
  }
//endregion
}
