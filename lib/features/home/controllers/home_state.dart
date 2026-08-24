import 'package:vngrocery/core/location/geo.dart';
import 'package:vngrocery/core/location/location_service.dart';
import 'package:vngrocery/core/location/nearby.dart';
import 'package:vngrocery/data/models.dart';

/// Where the home tab is in its load.
///
/// The cubit used to swallow every error, so a server that was unreachable
/// looked exactly like a server with nothing in it: a blank page, forever, with
/// no way to retry.
enum HomeStatus { loading, ready, failed }

class HomeState {
  final HomeStatus status;
  final List<Shop> shops;
  final List<Product> products;

  /// Where the reader is, when they let the app find out.
  final ReaderLocation? location;

  /// Why there is no location. Null while it has not been asked for yet.
  final LocationDenial? locationDenial;

  /// Suggestions for this reader. Null while loading or when the request
  /// failed, which hides the section rather than showing an empty one.
  final Recommendations? recommendations;

  /// Live offers for the advert slot. Empty hides the slot: an offer card with
  /// nothing in it would be an advert for nothing.
  final List<FeaturedVoucher> offers;

  const HomeState({
    this.status = HomeStatus.loading,
    this.shops = const [],
    this.products = const [],
    this.location,
    this.locationDenial,
    this.recommendations,
    this.offers = const [],
  });

  /// Replaces the location outcome wholesale.
  ///
  /// Both fields are set together and either may legitimately become null — a
  /// successful fix clears the denial, a refusal clears the position — so this
  /// deliberately takes no "keep what you had" shortcut.
  HomeState withLocation(ReaderLocation? location, LocationDenial? denial) =>
      HomeState(
        status: status,
        shops: shops,
        products: products,
        location: location,
        locationDenial: denial,
        recommendations: recommendations,
        offers: offers,
      );

  HomeState withRecommendations(Recommendations value) => HomeState(
    status: status,
    shops: shops,
    products: products,
    location: location,
    locationDenial: locationDenial,
    recommendations: value,
    offers: offers,
  );

  HomeState withOffers(List<FeaturedVoucher> value) => HomeState(
    status: status,
    shops: shops,
    products: products,
    location: location,
    locationDenial: locationDenial,
    recommendations: recommendations,
    offers: value,
  );

  /// True once there is something worth showing in the suggestions section.
  bool get hasRecommendations =>
      recommendations != null && !recommendations!.isEmpty;

  GeoPoint? get origin => location?.point;

  static GeoPoint? _shopPoint(Shop shop) =>
      GeoPoint(shop.latitude, shop.longitude);

  /// Nothing to show: nothing ranked and no shops worth listing.
  bool get isEmpty => shops.isEmpty && rankedProducts.isEmpty;

  /// How deep the ranked catalogue is fetched. The grid at the foot of the
  /// home page is the whole catalogue in interest order, not a teaser, so it
  /// needs more than the ten a spotlight row would.
  static const rankedLimit = 40;

  /// How many ranked products the spotlight row shows before the grid takes
  /// over. The grid skips exactly these, so nothing is printed twice.
  static const spotlightCount = 6;

  /// Every product the server ranked, best first.
  List<RecommendedProduct> get rankedProducts =>
      recommendations?.products ?? const [];

  /// The spotlight row: the strongest few, shown horizontally.
  List<RecommendedProduct> get spotlightProducts =>
      rankedProducts.take(spotlightCount).toList();

  /// The grid under it. Filtering collapses the split - once the reader has
  /// narrowed the catalogue, a "most wanted" row carved off the top of their
  /// own search would just hide results from them.
  List<RecommendedProduct> rankedGrid({String? category, String query = ''}) {
    final needle = query.trim().toLowerCase();
    final filtering =
        needle.isNotEmpty || (category != null && category.isNotEmpty);
    final source = filtering
        ? rankedProducts
        : rankedProducts.skip(spotlightCount);
    return source.where((product) {
      if (category != null &&
          category.isNotEmpty &&
          product.category != category) {
        return false;
      }
      if (needle.isEmpty) return true;
      return product.name.toLowerCase().contains(needle) ||
          product.shopName.toLowerCase().contains(needle);
    }).toList();
  }

  /// True while the reader has narrowed the catalogue, which is what hides the
  /// carousels above the grid.
  bool filtering({String? category, String query = ''}) =>
      query.trim().isNotEmpty || (category != null && category.isNotEmpty);

  /// Categories actually present in the loaded products.
  ///
  /// Derived rather than hardcoded: the previous fixed list of meat types
  /// matched neither the sample data ("Thịt gà") nor the server, which sends
  /// keys like "fresh_produce", so a filter built on it could only ever return
  /// nothing.
  /// Taken from the ranked catalogue the chips actually filter, so a chip can
  /// never offer a category the grid below it cannot show.
  List<String> get categories {
    final seen = <String>{};
    for (final product in rankedProducts) {
      final category = product.category.trim();
      if (category.isNotEmpty) seen.add(category);
    }
    final list = seen.toList()..sort();
    return list;
  }

  /// Shops near the reader, nearest first.
  ///
  /// Empty only when the reader is nowhere near any shop; with no location it
  /// falls back to every shop in the loaded order.
  NearbySelection<Shop> get nearbyShops =>
      selectNearby(shops, origin: origin, locate: _shopPoint);

  /// True when the reader is outside the search radius of everything, so the
  /// lists are the closest that exist rather than anything actually nearby.
  bool get outsideRange => nearbyShops.outsideRange;

  /// Shops worth putting under "đánh giá tốt", best first.
  ///
  /// The section used to render [shops] in whatever order the server returned,
  /// so a brand-new shop with 0.0 stars and no reviews sat at the front of a
  /// list titled "top rated". A shop earns a place here only once it has a
  /// signal to rank on — a review, or a trust verdict backed by real pledges —
  /// and the list is empty when none do, which lets the section hide itself.
  ///
  /// Only shops in the nearby ring are considered: a well-rated stall 30 km
  /// away is not somewhere anyone is buying fresh produce today.
  List<Shop> get topRatedShops {
    final ranked = nearbyShops.items
        .map((entry) => entry.item)
        .where(
          (shop) =>
              shop.reviewCount > 0 || (shop.trustSummary?.hasData ?? false),
        )
        .toList();
    ranked.sort((a, b) {
      final byRating = b.rating.compareTo(a.rating);
      if (byRating != 0) return byRating;
      final byTrust = _trustScore(b).compareTo(_trustScore(a));
      if (byTrust != 0) return byTrust;
      return b.reviewCount.compareTo(a.reviewCount);
    });
    return ranked;
  }

  static double _trustScore(Shop shop) => shop.trustSummary?.score ?? 0;
}
