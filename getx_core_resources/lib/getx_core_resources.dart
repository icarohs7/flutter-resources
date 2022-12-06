library getx_core_resources;

import 'package:core_resources/core_resources.dart';
import 'package:core_resources/core_resources.dart' as core;
import 'package:get/get.dart';

export 'package:core_resources/core_resources.dart' hide HiveDbResources, RxList;
export 'package:get/get.dart'
    hide ListExtension, FormData, MultipartFile, Response, ContextExtensionss;

export 'src/extensions/future_extensions.dart';
export 'src/extensions/getx_extensions.dart';
export 'src/extensions/stream_extensions.dart';

// ignore: avoid_classes_with_only_static_members
class HiveDbResources {
  static Future<void> init() async {
    Core.setLocator(<T extends Object>() => Get.find<T>());
    Core.setGoNamedFn((context, routeName, {params}) => Get.toNamed(routeName, arguments: params));
    Core.setReplaceNamedFn((context, routeName, {params}) {
      Get.offNamed(routeName, arguments: params);
    });
    Core.setReplaceAllNamedFn((context, routeName, {params}) {
      Get.offAllNamed(routeName, arguments: params);
    });
    Core.setCurrentPathFn((context) => Get.currentRoute);
    await core.HiveDbResources.init();
  }
}
