import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/nearby.dart';
import 'package:vngrocery/data/models.dart';

class ExploreMapState {
  final List<Shop> shops;
  final String? selectedShopId;

  /// Where the reader is, when they let the app find out.
  final GeoPoint? origin;

  const ExploreMapState({
    this.shops = const [],
    this.selectedShopId,
    this.origin,
  });

  /// Shops near the reader, nearest first — the 5 km ring, widening to 20 km
  /// only if that is empty. Unordered when there is no location.
  List<Nearby<Shop>> get nearbyShops => rankByDistance(
    shops,
    origin: origin,
    locate: (shop) => GeoPoint(shop.latitude, shop.longitude),
  );

  /// What the map should be centred on.
  ///
  /// The reader if known, else the nearest shop, else nothing — the screen used
  /// to hardcode the centre of Ho Chi Minh City for everyone.
  GeoPoint? get center {
    if (origin != null && origin!.isSet) return origin;
    for (final entry in nearbyShops) {
      final point = GeoPoint(entry.item.latitude, entry.item.longitude);
      if (point.isSet) return point;
    }
    return null;
  }

  Shop? get selectedShop {
    final shopId = selectedShopId;
    if (shopId == null) return null;
    return shops.where((shop) => shop.id == shopId).firstOrNull;
  }

  ExploreMapState copyWith({
    List<Shop>? shops,
    String? selectedShopId,
    GeoPoint? origin,
  }) {
    return ExploreMapState(
      shops: shops ?? this.shops,
      selectedShopId: selectedShopId ?? this.selectedShopId,
      origin: origin ?? this.origin,
    );
  }
}
