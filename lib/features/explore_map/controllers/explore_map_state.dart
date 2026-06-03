import '../../../data/models.dart';

class ExploreMapState {
  final List<Shop> shops;
  final String? selectedShopId;

  const ExploreMapState({
    this.shops = const [],
    this.selectedShopId,
  });

  Shop? get selectedShop {
    final shopId = selectedShopId;
    if (shopId == null) return null;
    return shops.where((shop) => shop.id == shopId).firstOrNull;
  }

  ExploreMapState copyWith({
    List<Shop>? shops,
    String? selectedShopId,
  }) {
    return ExploreMapState(
      shops: shops ?? this.shops,
      selectedShopId: selectedShopId ?? this.selectedShopId,
    );
  }
}
