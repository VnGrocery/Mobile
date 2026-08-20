import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_cubit.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

void main() {
  test('SellerCreateProductCubit updates category and image state', () {
    final cubit = SellerCreateProductCubit(shopId: AppDataConfig.demoShopId);

    cubit.setCategory(SellerProductPresenter.otherCategory);
    // The photo is real bytes now, not a flag with nothing behind it.
    cubit.attachImage(Uint8List.fromList(const [1, 2, 3]));

    expect(cubit.state.category, SellerProductPresenter.otherCategory);
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
}
