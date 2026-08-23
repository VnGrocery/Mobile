import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_cubit.dart';

void main() {
  setUp(() => MockDb.instance.shops.clear());
  tearDown(MockDb.instance.resetForTesting);

  test('an edit sends the reason the server signs into the record', () async {
    // The chain recorded what changed and never why; the server refuses an
    // update without a reason now, so the app has to carry one.
    Map<String, Object?>? sent;
    final cubit = SellerShopCubit(
      shopId: 'shop-1',
      repositories: AppRepositories.forTesting(
        MockDb.instance,
        RemoteDataSource(
          ApiClient(
            baseUrl: 'http://localhost:5050',
            tokenReader: () => 'token',
            client: MockClient((request) async {
              if (request.method == 'PUT' || request.method == 'POST') {
                sent = jsonDecode(request.body) as Map<String, Object?>;
              }
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
            }),
          ),
        ),
      ),
    );

    await cubit.save(
      name: 'Rau Cô Ba',
      description: '',
      address: 'Chợ Bến Thành',
      changeReason: '  Đổi địa chỉ sau khi chuyển sạp  ',
    );

    expect(sent?['changeReason'], 'Đổi địa chỉ sau khi chuyển sạp');

    await cubit.close();
  });
}
