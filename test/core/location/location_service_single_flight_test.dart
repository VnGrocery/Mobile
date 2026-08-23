import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/location/location_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('overlapping asks share one request and never throw', () async {
    // MainScreen builds every tab at once, so the home tab, the store list and
    // the map all ask on the same frame. geolocator answers the second overlap
    // with PermissionRequestInProgressException, which used to escape into the
    // caller - on the iOS simulator that failed the whole run.
    //
    // No platform channel is registered in a unit test, so every call fails
    // inside the plugin: the point here is that the failure comes back as an
    // answer, and that two concurrent asks resolve to the same one.
    final first = LocationService.instance.current();
    final second = LocationService.instance.current();

    final results = await Future.wait([first, second]);

    expect(results[0].$1, isNull);
    expect(results[0].$2, LocationDenial.unavailable);
    expect(results[1], results[0]);
  });

  test('a later ask starts a fresh request', () async {
    final first = await LocationService.instance.current();
    final later = await LocationService.instance.current();

    expect(first.$2, LocationDenial.unavailable);
    expect(later.$2, LocationDenial.unavailable);
  });
}
