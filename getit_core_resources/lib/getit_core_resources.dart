library getit_core_resources;

import 'getit_core_resources.dart';

export 'package:core_resources/core_resources.dart' hide HiveDbResources;
export 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

// ignore: avoid_classes_with_only_static_members
class HiveDbResources {
  static Future<void> init() async {
    Core.setLocator(<T extends Object>() => GetIt.I<T>());
    await Hive.initFlutter();
    await Hive.openBox<String>('globalBox');
  }
}
