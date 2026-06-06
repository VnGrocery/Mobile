import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_cubit.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

void main() {
  test('SellerCreateProductCubit updates category and image state', () {
    final cubit = SellerCreateProductCubit(
      shopId: AppDataConfig.demoShopId,
      delayService: const NoopAppDelayService(),
    );

    cubit.setCategory(SellerProductPresenter.otherCategory);
    cubit.toggleImage();

    expect(cubit.state.category, SellerProductPresenter.otherCategory);
    expect(cubit.state.imageSelected, isTrue);

    cubit.close();
  });

  testWidgets('SellerCreateProductCubit saves draft product', (tester) async {
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
      delayService: const NoopAppDelayService(),
    );

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
    expect(product.status, 'Draft');
    expect(cubit.state.saved, isTrue);
    expect(cubit.state.saving, isFalse);

    cubit.close();
  });
}
