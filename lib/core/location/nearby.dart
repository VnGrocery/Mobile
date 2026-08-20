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
      : located
            .where((entry) => entry.distanceKm! <= NearbyRadius.far)
            .toList();

  return [...ring, ...unlocated];
}

/// A ranked list, and whether it had to reach past the search radius to fill.
class NearbySelection<T> {
  final List<Nearby<T>> items;

  /// True when nothing was within [NearbyRadius.far] and [items] are simply the
  /// closest that exist. Screens say so rather than passing them off as nearby.
  final bool outsideRange;

  const NearbySelection(this.items, {this.outsideRange = false});

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

/// Ranks by distance and, when the rings come back empty, falls back to the
/// [fallbackLimit] closest items whatever their distance.
///
/// A blank screen is the worst answer available: it looks identical to a
/// failure, and it is what a reader gets whenever they happen to be somewhere
/// the catalogue does not cover. Showing the closest that exist, labelled
/// honestly as out of range, at least tells them what is there.
NearbySelection<T> selectNearby<T>(
  List<T> items, {
  required GeoPoint? origin,
  required GeoPoint? Function(T item) locate,
  int fallbackLimit = 10,
}) {
  final ranked = rankByDistance(items, origin: origin, locate: locate);
  if (ranked.isNotEmpty || origin == null || !origin.isSet) {
    return NearbySelection(ranked);
  }

  // Everything was past the far ring. Measure the lot and take the closest.
  final measured = <Nearby<T>>[];
  for (final item in items) {
    final point = locate(item);
    if (point == null || !point.isSet) continue;
    measured.add(Nearby(item, distanceKm(origin, point)));
  }
  if (measured.isEmpty) return const NearbySelection([]);

  measured.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
  return NearbySelection(
    measured.take(fallbackLimit).toList(),
    outsideRange: true,
  );
}
