import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  HiveStorageService._();

  static const schemaVersion = 1;
  static const metadataBoxName = 'storage_metadata';
  static const _schemaVersionKey = 'schema_version';

  static const cartBoxName = 'cart_cache';
  static const productBoxName = 'product_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Object>(metadataBoxName),
      Hive.openBox<Map>(cartBoxName),
      Hive.openBox<Map>(productBoxName),
    ]);
    await _ensureSchemaVersion();
  }

  static Box<Object> metadataBox() => Hive.box<Object>(metadataBoxName);

  static Box<Object>? tryMetadataBox() {
    if (!Hive.isBoxOpen(metadataBoxName)) return null;
    return Hive.box<Object>(metadataBoxName);
  }

  static Box<Map> cartBox() => Hive.box<Map>(cartBoxName);

  static Box<Map> productBox() => Hive.box<Map>(productBoxName);

  static Box<Map>? tryCartBox() {
    if (!Hive.isBoxOpen(cartBoxName)) return null;
    return Hive.box<Map>(cartBoxName);
  }

  static Box<Map>? tryProductBox() {
    if (!Hive.isBoxOpen(productBoxName)) return null;
    return Hive.box<Map>(productBoxName);
  }

  static Future<void> _ensureSchemaVersion() async {
    final metadata = metadataBox();
    final current = metadata.get(_schemaVersionKey) as int?;
    if (current == schemaVersion) return;

    await metadata.put(_schemaVersionKey, schemaVersion);
  }
}
