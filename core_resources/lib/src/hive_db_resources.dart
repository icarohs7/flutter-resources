import 'package:hive_flutter/hive_flutter.dart';

// ignore: avoid_classes_with_only_static_members
class HiveDbResources {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>('globalBox');
  }
}
