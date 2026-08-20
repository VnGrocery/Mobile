import 'geo.dart';

/// How far the app is willing to look, nearest ring first.
///
/// Someone shopping for fresh produce wants the stall down the road, not the
/// best-rated one across the city — but an empty page is worse than a longer
/// trip, so the search widens rather than giving up.
class NearbyRadius {
  const NearbyRadius._();

  /// Everything in walking or short-ride distance.
  static const double near = 5;

  /// Widened to when nothing at all is [near]. Past this, a "nearby" shop is
  /// not nearby in any useful sense.
  static const double far = 20;
}

/// One item with its distance from the reader.
class Nearby<T> {
  final T item;

  /// Null when the item has no coordinates to measure from.
  final double? distanceKm;

  const Nearby(this.item, this.distanceKm);

  bool get isLocated => distanceKm != null;
}

/// Ranks [items] by distance from [origin], nearest first.
///
/// Items within [NearbyRadius.near] are returned alone when there are any; only
/// if that ring is empty does the result widen to [NearbyRadius.far]. Items with
/// no coordinates keep their original order at the end — a shop that has not
/// filled in its address is still a real shop and should not disappear.
///
/// With no [origin] (location off or denied) the input order is preserved and
/// every distance is null, so callers can render the same list unranked.
List<Nearby<T>> rankByDistance<T>(
  List<T> items, {
  required GeoPoint? origin,
  required GeoPoint? Function(T item) locate,
}) {
  if (origin == null || !origin.isSet) {
    return [for (final item in items) Nearby(item, null)];
  }

  final located = <Nearby<T>>[];
  final unlocated = <Nearby<T>>[];

  for (final item in items) {
    final point = locate(item);
    if (point == null || !point.isSet) {
      unlocated.add(Nearby(item, null));
      continue;
    }
    located.add(Nearby(item, distanceKm(origin, point)));
  }

  located.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));

  final near = located
      .where((entry) => entry.distanceKm! <= NearbyRadius.near)
      .toList();
  final ring = near.isNotEmpty
      ? near
      : located.where((entry) => entry.distanceKm! <= NearbyRadius.far).toList();

  return [...ring, ...unlocated];
}
