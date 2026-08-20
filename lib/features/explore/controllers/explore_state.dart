import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/data/models.dart';

class ExploreState {
  final String query;
  final String selectedFilter;
  final String? selectedShopId;
  final List<Shop> shops;

  /// Where the reader is, when they let the app find out.
  final GeoPoint? origin;

  /// True once the reader has picked a chip themselves, so locating them later
  /// does not yank the list out from under a deliberate choice.
  final bool filterChosen;

  const ExploreState({
    this.query = '',
    required this.selectedFilter,
    this.selectedShopId,
    this.shops = const [],
    this.origin,
    this.filterChosen = false,
  });

  factory ExploreState.initial() {
    return const ExploreState(selectedFilter: 'top_rated');
  }

  Shop? get selectedShop {
    final shopId = selectedShopId;
    if (shopId == null) return null;
    return shops.where((shop) => shop.id == shopId).firstOrNull;
  }

  ExploreState copyWith({
    String? query,
    String? selectedFilter,
    String? selectedShopId,
    bool clearSelectedShop = false,
    List<Shop>? shops,
    GeoPoint? origin,
    bool? filterChosen,
  }) {
    return ExploreState(
      query: query ?? this.query,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedShopId: clearSelectedShop
          ? null
          : selectedShopId ?? this.selectedShopId,
      shops: shops ?? this.shops,
      origin: origin ?? this.origin,
      filterChosen: filterChosen ?? this.filterChosen,
    );
  }
}
