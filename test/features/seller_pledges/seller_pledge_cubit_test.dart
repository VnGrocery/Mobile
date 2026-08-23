import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_cubit.dart';
import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

void main() {
  test('SellerPledgeCubit advances capture flow to evaluate step', () async {
    final cubit = SellerPledgeCubit(productId: 'p1');

    await cubit.capture(Uint8List.fromList(const [1, 2, 3]));

    expect(cubit.state.step, 2);
    expect(cubit.state.analyzing, isFalse);

    cubit.close();
  });

  testWidgets('SellerPledgeCubit commits pledge history item', (tester) async {
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

    final productId = AppRepositories.instance.products.all().first.id;
    final before = AppRepositories.instance.pledges.ofProduct(productId).length;
    final cubit = SellerPledgeCubit(productId: productId);

    cubit.setCategory('seafood');
    await cubit.commit('9.1', l10n);

    final after = AppRepositories.instance.pledges.ofProduct(productId);
    expect(after.length, before + 1);
    expect(after.first.description, contains('9.1/10'));
    expect(
      after.first.description,
      contains(CategoryPresenter.label(l10n, 'seafood')),
    );
    expect(cubit.state.committed, isTrue);
    expect(cubit.state.committing, isFalse);

    cubit.close();
  });
}
