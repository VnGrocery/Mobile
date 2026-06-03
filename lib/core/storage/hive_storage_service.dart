import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  HiveStorageService._();

  static const cartBoxName = 'cart_cache';
  static const productBoxName = 'product_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Map>(cartBoxName),
      Hive.openBox<Map>(productBoxName),
    ]);
  }

  static Box<Map> cartBox() => Hive.box<Map>(cartBoxName);

  static Box<Map> productBox() => Hive.box<Map>(productBoxName);
}
