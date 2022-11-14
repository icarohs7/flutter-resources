library core_resources;

export 'package:async/async.dart';
export 'package:build_context/build_context.dart';
export 'package:dartx/dartx.dart' hide Function0, Function1, Function2, Function3, Function4;
export 'package:dio/dio.dart';
export 'package:enhanced_future_builder/enhanced_future_builder.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:http_parser/http_parser.dart';
export 'package:intl/date_symbol_data_local.dart';
export 'package:intl/intl.dart';
export 'package:rxdart/rxdart.dart' hide Rx;
export 'package:transparent_image/transparent_image.dart';

export 'src/baseclasses/abstract_json_database.dart';
export 'src/baseclasses/abstract_t_database.dart';
export 'src/baseclasses/base_api_service.dart';
export 'src/baseclasses/base_repository.dart';
export 'src/extensions/color_extensions.dart';
export 'src/extensions/context_extensions.dart';
export 'src/extensions/execution_extensions.dart';
export 'src/extensions/future_extensions.dart';
export 'src/extensions/future_extensions.dart';
export 'src/extensions/number_extensions.dart';
export 'src/extensions/object_extensions.dart';
export 'src/extensions/stream_extensions.dart';
export 'src/extensions/stream_extensions.dart';
export 'src/extensions/string_extensions.dart';
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
  static late T Function<T>({String? tag}) _locator;

  static void setLocator(T Function<T>({String? tag}) locator) => _locator = locator;

  static S get<S>({String? tag}) => _locator(tag: tag);
}
