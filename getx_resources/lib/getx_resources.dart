library getx_resources;

import 'package:core_resources/core_resources.dart';
import 'package:get/get.dart';

export 'package:get/get.dart'
    hide ListExtension, FormData, MultipartFile, Response, ContextExtensionss;

export 'src/extensions/future_extensions.dart';
export 'src/extensions/stream_extensions.dart';

// ignore: avoid_classes_with_only_static_members
class HiveDbResources {
  static Future<void> init({bool initHive = true}) async {
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
    if (initHive) await Hive.initFlutter();
  }
}
