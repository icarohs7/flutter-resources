library getx_resources;

import 'package:core_resources/core_resources.dart';
import 'package:core_resources/core_resources.dart' as core;
import 'package:get/get.dart';

export 'package:core_resources/core_resources.dart' hide HiveDbResources, RxList;
export 'package:get/get.dart'
    hide
        ListExtension,
        FormData,
        MultipartFile,
        Response,
        ContextExtensionss,
        RxNotifier,
        RxSet,
        RxMap;

export 'src/extensions/future_extensions.dart';
export 'src/extensions/getx_extensions.dart';
export 'src/extensions/stream_extensions.dart';

// ignore: avoid_classes_with_only_static_members
class HiveDbResources {
  static Future<void> init() async {
    Core.setLocator(<T extends Object>() {
      return Get.find<T>();
    });
    Core.setPushFn((context, routeName, {params, extra}) {
      Get.toNamed(routeName, parameters: params, arguments: extra, preventDuplicates: false);
    });
    Core.setGoFn((context, routeName, {params, extra}) {
      Get.toNamed(routeName, parameters: params, arguments: extra, preventDuplicates: false);
    });
    Core.setReplaceFn((context, routeName, {params, extra}) {
      Get.offNamed(routeName, parameters: params, arguments: extra, preventDuplicates: false);
    });
    Core.setReplaceAllFn((context, routeName, {params, extra}) {
      Get.offAllNamed(routeName, parameters: params, arguments: extra);
    });
    Core.setCurrentPathFn((context) {
      return Get.currentRoute;
    });
    Core.setCurrentParamsFn((context) {
      return Get.parameters.mapValues((entry) => entry.value ?? '');
    });
    Core.setCurrentExtrasFn((context) {
      return Get.arguments;
    });
    await core.HiveDbResources.init();
  }
}