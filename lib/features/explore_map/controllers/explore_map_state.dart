import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/nearby.dart';
import 'package:vngrocery/data/models.dart';

/// Where the map is in finding the reader.
///
/// The map opened before the answer arrived, so it framed whatever shop
/// happened to be first in the list. That reads as "here is the busiest
/// neighbourhood" when what was asked for was "here is where you are".
enum MapLocationStatus {
  /// Still asking. The map has nowhere honest to point yet.
  locating,

  /// [ExploreMapState.origin] is set.
  located,

  /// Refused or no fix; the map falls back to framing the shops.
  unavailable,
}

class ExploreMapState {
  final List<Shop> shops;
  final String? selectedShopId;

  /// Where the reader is, when they let the app find out.
  final GeoPoint? origin;

  final MapLocationStatus locationStatus;

  const ExploreMapState({
    this.shops = const [],
    this.selectedShopId,
    this.origin,
    this.locationStatus = MapLocationStatus.locating,
  });

  /// Shops near the reader, nearest first — the 5 km ring, widening to 20 km
  /// only if that is empty. Unordered when there is no location.
  NearbySelection<Shop> get nearbyShops => selectNearby(
    shops,
    origin: origin,
    locate: (shop) => GeoPoint(shop.latitude, shop.longitude),
  );

  /// What the map should be centred on.
  ///
  /// The reader if known. Falling back to a shop is only right once locating
  /// has actually failed: doing it while the answer is still coming is what
  /// made the map open on a cluster of shops instead of on you.
  GeoPoint? get center {
    if (origin != null && origin!.isSet) return origin;
    if (locationStatus == MapLocationStatus.locating) return null;
    for (final entry in nearbyShops.items) {
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
    MapLocationStatus? locationStatus,
  }) {
    return ExploreMapState(
      shops: shops ?? this.shops,
      selectedShopId: selectedShopId ?? this.selectedShopId,
      origin: origin ?? this.origin,
      locationStatus: locationStatus ?? this.locationStatus,
    );
  }
}
