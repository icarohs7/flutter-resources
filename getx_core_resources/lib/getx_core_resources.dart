library getx_core_resources;

import 'package:core_resources/core_resources.dart';
import 'package:get/get.dart';

export 'package:core_resources/core_resources.dart' hide HiveDbResources, RxList;
export 'package:get/get.dart'
    hide ListExtension, FormData, MultipartFile, Response, ContextExtensionss;

export 'src/base_get_router.dart';
export 'src/extensions/future_extensions.dart';
export 'src/extensions/getx_extensions.dart';
export 'src/extensions/stream_extensions.dart';

// ignore: avoid_classes_with_only_static_members
class HiveDbResources {
  static Future<void> init() async {
    Core.setLocator(<T extends Object>() => Get.find<T>());
    await Hive.initFlutter();
    await Hive.openBox<String>('globalBox');
  }
}
