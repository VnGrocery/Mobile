import '../../../data/models.dart';
import '../explore_presenter.dart';

class ExploreState {
  final String query;
  final String selectedFilter;
  final String? selectedShopId;
  final List<Shop> shops;

  const ExploreState({
    this.query = '',
    required this.selectedFilter,
    this.selectedShopId,
    this.shops = const [],
  });

  factory ExploreState.initial() {
    return ExploreState(selectedFilter: ExplorePresenter.filters.first);
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
  }) {
    return ExploreState(
      query: query ?? this.query,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedShopId:
          clearSelectedShop ? null : selectedShopId ?? this.selectedShopId,
      shops: shops ?? this.shops,
    );
  }
}
