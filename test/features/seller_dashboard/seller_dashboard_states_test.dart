import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_dashboard/controllers/seller_dashboard_cubit.dart';
import 'package:vngrocery/features/seller_dashboard/controllers/seller_dashboard_state.dart';

AppRepositories _repositories(http.Client client) => AppRepositories.forTesting(
  MockDb.instance,
  RemoteDataSource(
    ApiClient(
      baseUrl: 'http://localhost:5050',
      tokenReader: () => 'token',
      client: client,
    ),
  ),
);

void main() {
  setUp(() {
    MockDb.instance.shops.clear();
    MockDb.instance.products.clear();
  });
  tearDown(MockDb.instance.resetForTesting);

  test('an account with no shop is told so, not left on a spinner', () async {
    // The cubit used to return without emitting, so the tab sat on a
    // CircularProgressIndicator that nothing was ever going to replace.
    final cubit = SellerDashboardCubit(
      repositories: _repositories(
        MockClient((_) async => http.Response('{"error":"not found"}', 404)),
      ),
    );

    await cubit.load(null);

    expect(cubit.state.status, SellerDashboardStatus.noShop);
    expect(cubit.state.isBusy, isFalse);
    expect(cubit.state.hasDashboard, isFalse);

    await cubit.close();
  });

  test('a failed refresh says so rather than spinning', () async {
    final cubit = SellerDashboardCubit(
      repositories: _repositories(
        MockClient((_) async => throw http.ClientException('offline')),
      ),
    );

    await cubit.load(null);

    expect(cubit.state.status, SellerDashboardStatus.failed);
    expect(cubit.state.isBusy, isFalse);

    await cubit.close();
  });

  test('a shop that loads is ready', () async {
    final cubit = SellerDashboardCubit(
      repositories: _repositories(
        MockClient((request) async {
          if (request.url.path.endsWith('/me/shop')) {
            // Bytes, not a String: http.Response encodes a String as latin1,
            // which cannot carry the Vietnamese the real server sends.
            return http.Response.bytes(
              utf8.encode(
                jsonEncode({
                  'shopId': 'shop-1',
                  'name': 'Rau Cô Ba',
                  'address': 'Chợ Bến Thành',
                  'description': '',
                  'latitude': 10.77,
                  'longitude': 106.70,
                }),
              ),
              200,
            );
          }
          return http.Response(jsonEncode({'items': <Object?>[]}), 200);
        }),
      ),
    );

    await cubit.load(null);

    expect(cubit.state.status, SellerDashboardStatus.ready);
    expect(cubit.state.dashboard?.shop.id, 'shop-1');

    await cubit.close();
  });
}
