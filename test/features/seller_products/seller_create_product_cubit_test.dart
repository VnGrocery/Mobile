import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_cubit.dart';
import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

void main() {
  test('SellerCreateProductCubit updates category and image state', () {
    final cubit = SellerCreateProductCubit(shopId: AppDataConfig.demoShopId);

    // A category the rest of the system actually stores. The seller screens
    // used to offer beef/pork/chicken/other, which nothing else matched.
    cubit.setCategory(CategoryPresenter.selectable.last);
    // The photo is real bytes now, not a flag with nothing behind it.
    cubit.attachImage(Uint8List.fromList(const [1, 2, 3]));

    expect(cubit.state.category, CategoryPresenter.selectable.last);
    expect(cubit.state.imageSelected, isTrue);

    cubit.close();
  });

  testWidgets('SellerCreateProductCubit saves a product buyers can see', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final cubit = SellerCreateProductCubit(shopId: AppDataConfig.demoShopId);

    final product = await cubit.save(
      name: 'Test product',
      description: 'Description',
      price: '120.000 đ',
      tags: 'Demo, Fresh',
      l10n: l10n,
    );

    expect(product.shopId, AppDataConfig.demoShopId);
    expect(product.price, 120000);
    expect(product.tags, ['Demo', 'Fresh']);
    // Not a draft: the server only exposes "active" and "published" products,
    // so a draft would be invisible to buyers and to the seller's own shop.
    expect(product.status, 'published');
    expect(cubit.state.saved, isTrue);
    expect(cubit.state.saving, isFalse);

    cubit.close();
  });

  testWidgets('a save that fails is reported, not announced as success', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final cubit = SellerCreateProductCubit(
      shopId: AppDataConfig.demoShopId,
      repositories: AppRepositories.forTesting(
        MockDb.instance,
        RemoteDataSource(
          ApiClient(
            baseUrl: 'http://localhost:5050',
            tokenReader: () => 'token',
            client: MockClient((_) async => throw http.ClientException('offline')),
          ),
        ),
      ),
    );

    await expectLater(
      cubit.save(
        name: 'Test product',
        description: '',
        price: '10.000 d',
        tags: '',
        l10n: l10n,
      ),
      throwsA(isA<Object>()),
    );

    // The button used to stay stuck spinning while the screen popped with a
    // success message for a product the server never received.
    expect(cubit.state.saving, isFalse);
    expect(cubit.state.saved, isFalse);

    cubit.close();
  });

  // An update replaces the whole record on the server, so a field the form
  // fails to send back is a field erased from the signed product. Editing the
  // price used to wipe the seller's spec table and description with it.
  testWidgets('editing carries the specs and description it did not touch', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final existing = Product(
      id: 'p1',
      shopId: AppDataConfig.demoShopId,
      name: 'Cà chua bi',
      description: 'Trái nhỏ',
      category: CategoryPresenter.selectable.first,
      freshnessScore: 8.9,
      freshnessNote: 'Hàng tuyển loại 1',
      price: 40000,
      tags: const ['Đà Lạt'],
      status: 'published',
      version: 12,
      imageUrls: const ['http://example.test/a.jpg'],
      specs: const [SpecItem(key: 'Xuất xứ', value: 'Đà Lạt')],
      descBlocks: const [
        DescBlock(type: DescBlock.heading, text: 'Điểm nổi bật'),
      ],
    );

    Map<String, Object?>? sent;
    final cubit = SellerCreateProductCubit(
      shopId: AppDataConfig.demoShopId,
      existing: existing,
      repositories: AppRepositories.forTesting(
        MockDb.instance,
        RemoteDataSource(
          ApiClient(
            baseUrl: 'http://localhost:5050',
            tokenReader: () => 'token',
            client: MockClient((request) async {
              sent = jsonDecode(request.body) as Map<String, Object?>;
              return http.Response(
                jsonEncode({
                  ...sent!,
                  'productId': 'p1',
                  'shopId': existing.shopId,
                  'version': 13,
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }),
          ),
        ),
      ),
    );

    // Only the price is touched, the way a seller adjusting a price would.
    await cubit.save(
      name: existing.name,
      description: existing.description,
      price: '42.000 đ',
      tags: 'Đà Lạt',
      l10n: l10n,
      changeReason: 'Giá nhập tăng',
    );

    expect(sent, isNotNull);
    expect(sent!['specs'], [
      {'key': 'Xuất xứ', 'value': 'Đà Lạt'},
    ]);
    expect(sent!['descBlocks'], [
      {'type': 'heading', 'text': 'Điểm nổi bật'},
    ]);
    // The photo and the freshness record are carried the same way.
    expect(sent!['imageUrls'], ['http://example.test/a.jpg']);
    expect(sent!['freshnessScore'], 8.9);

    cubit.close();
  });

  testWidgets('the form can replace the specs and description', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    Map<String, Object?>? sent;
    final cubit = SellerCreateProductCubit(
      shopId: AppDataConfig.demoShopId,
      repositories: AppRepositories.forTesting(
        MockDb.instance,
        RemoteDataSource(
          ApiClient(
            baseUrl: 'http://localhost:5050',
            tokenReader: () => 'token',
            client: MockClient((request) async {
              sent = jsonDecode(request.body) as Map<String, Object?>;
              return http.Response(
                jsonEncode({
                  ...sent!,
                  'productId': 'p2',
                  'shopId': AppDataConfig.demoShopId,
                  'version': 1,
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }),
          ),
        ),
      ),
    );

    cubit.setSpecs(const [SpecItem(key: 'Bảo quản', value: 'Ngăn mát')]);
    cubit.setDescBlocks(const [
      DescBlock(type: DescBlock.bullets, items: ['Hái sáng nay']),
    ]);

    await cubit.save(
      name: 'Rau cải',
      description: '',
      price: '19.000 đ',
      tags: '',
      l10n: l10n,
    );

    expect(sent!['specs'], [
      {'key': 'Bảo quản', 'value': 'Ngăn mát'},
    ]);
    expect(sent!['descBlocks'], [
      {
        'type': 'bullets',
        'items': ['Hái sáng nay'],
      },
    ]);

    cubit.close();
  });
}
