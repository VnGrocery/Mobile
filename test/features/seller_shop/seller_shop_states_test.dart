import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_cubit.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_state.dart';

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

  test('an account with no shop lands on the create form, not a spinner', () async {
    final cubit = SellerShopCubit(
      shopId: null,
      repositories: _repositories(
        MockClient((_) async => http.Response('{"error":"not found"}', 404)),
      ),
    );

    await cubit.load();

    expect(cubit.state.status, SellerShopStatus.noShop);
    expect(cubit.state.isCreating, isTrue);
    expect(cubit.state.isBusy, isFalse);
    // Nothing to prefill the form from, and no shop to update on save.
    expect(cubit.state.shop, isNull);
    expect(cubit.shopId, isNull);

    await cubit.close();
  });

  test('a failed load says so rather than spinning', () async {
    final cubit = SellerShopCubit(
      shopId: null,
      repositories: _repositories(
        MockClient((_) async => throw http.ClientException('offline')),
      ),
    );

    await cubit.load();

    expect(cubit.state.status, SellerShopStatus.failed);
    expect(cubit.state.isBusy, isFalse);
    // A failure is not an invitation to create a second shop.
    expect(cubit.state.isCreating, isFalse);

    await cubit.close();
  });

  test('the shop the server returns fills the form', () async {
    final cubit = SellerShopCubit(
      shopId: null,
      repositories: _repositories(
        MockClient((request) async {
          if (request.url.path.endsWith('/me/shop')) {
            return http.Response.bytes(
              utf8.encode(
                jsonEncode({
                  'shopId': 'shop-7',
                  'name': 'Rau Cô Ba',
                  'address': 'Chợ Bến Thành',
                  'description': 'Rau sạch Đà Lạt',
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

    await cubit.load();

    expect(cubit.state.status, SellerShopStatus.ready);
    expect(cubit.state.shop?.name, 'Rau Cô Ba');
    expect(cubit.shopId, 'shop-7');

    await cubit.close();
  });

  test('a save that fails clears the spinner and surfaces the error', () async {
    final cubit = SellerShopCubit(
      shopId: null,
      repositories: _repositories(
        MockClient((_) async => throw http.ClientException('offline')),
      ),
    );

    await expectLater(
      cubit.save(name: 'Rau Cô Ba', description: '', address: 'Chợ Bến Thành'),
      throwsA(isA<Object>()),
    );

    // The button used to stay stuck spinning while the screen reported success.
    expect(cubit.state.saving, isFalse);
    expect(cubit.state.shop, isNull);

    await cubit.close();
  });
}
