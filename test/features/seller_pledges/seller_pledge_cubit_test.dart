import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_state.dart';
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

  test('a photo the scorer refuses is reported, not silently ignored', () async {
    // The seller tapped, waited, and landed back on the same step with no
    // explanation - and the pledge cannot proceed without the image hash the
    // scorer returns, so pretending nothing happened was the worst answer.
    final cubit = SellerPledgeCubit(
      productId: 'p1',
      repositories: AppRepositories.forTesting(
        MockDb.instance,
        RemoteDataSource(
          ApiClient(
            baseUrl: 'http://localhost:5050',
            tokenReader: () => 'token',
            client: MockClient(
              (_) async => http.Response('{"error":"unavailable"}', 503),
            ),
          ),
        ),
      ),
    );

    await cubit.capture(Uint8List.fromList(const [1, 2, 3]));

    expect(cubit.state.step, 1);
    expect(cubit.state.analyzing, isFalse);
    expect(cubit.state.failure, SellerPledgeCaptureFailure.unavailable);

    await cubit.close();
  });
}
