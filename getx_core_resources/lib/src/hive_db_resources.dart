import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDbResources {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>('globalBox');
  }
}
